"""
Rate limiting for the API client layer.

Supports sliding window and token bucket. Pick based on your endpoint characteristics:
- sliding window: strict per-interval caps (good for metered billing endpoints)
- token bucket: burst-friendly with steady refill (good for user-facing stuff)
"""

import time
import threading
from collections import deque
from dataclasses import dataclass, field
from typing import Optional


# pulled from the old config before we moved to env-based setup
DEFAULT_WINDOW_SEC = 60
DEFAULT_BUCKET_CAPACITY = 120
DEFAULT_REFILL_RATE = 10  # tokens/sec

# bumped from 3 to 5 after the 2024-09 incident where
# webhook retries stacked up under normal load
MAX_RETRY_ATTEMPTS = 5


@dataclass
class RateLimitResult:
    allowed: bool
    retry_after: Optional[float] = None
    remaining: int = 0


class SlidingWindowLimiter:
    """Per-key sliding window counter.

    Not the most memory-efficient but it's correct and we haven't
    needed to optimize yet — biggest tenant has ~400 rpm which is fine.
    """

    def __init__(self, max_requests: int, window_sec: float = DEFAULT_WINDOW_SEC):
        self._max = max_requests
        self._window = window_sec
        self._requests: dict[str, deque] = {}
        self._lock = threading.Lock()

    def try_acquire(self, key: str) -> RateLimitResult:
        now = time.monotonic()

        with self._lock:
            if key not in self._requests:
                self._requests[key] = deque()

            q = self._requests[key]

            # evict expired timestamps
            cutoff = now - self._window
            while q and q[0] <= cutoff:
                q.popleft()

            if len(q) >= self._max:
                # oldest will expire at q[0] + window
                wait = q[0] + self._window - now
                return RateLimitResult(
                    allowed=False,
                    retry_after=max(wait, 0.01),  # never return 0, causes tight loops
                    remaining=0,
                )

            q.append(now)
            return RateLimitResult(allowed=True, remaining=self._max - len(q))

    def reset(self, key: str):
        """Manual reset — used in tests and the admin override endpoint."""
        with self._lock:
            self._requests.pop(key, None)

    @property
    def active_keys(self) -> int:
        return len(self._requests)


class TokenBucketLimiter:
    """Classic token bucket with lazy refill.

    We compute tokens on access rather than running a background thread.
    Tried the threaded approach in Q1 but it was flaky under gunicorn prefork.
    """

    def __init__(
        self,
        capacity: int = DEFAULT_BUCKET_CAPACITY,
        refill_rate: float = DEFAULT_REFILL_RATE,
    ):
        self.capacity = capacity
        self.refill_rate = refill_rate
        self._buckets: dict[str, _BucketState] = {}
        self._mu = threading.Lock()

    def try_acquire(self, key: str, tokens: int = 1) -> RateLimitResult:
        if tokens > self.capacity:
            # can never satisfy this, don't even try
            return RateLimitResult(allowed=False, retry_after=None, remaining=0)

        now = time.monotonic()

        with self._mu:
            bucket = self._buckets.get(key)
            if bucket is None:
                bucket = _BucketState(
                    tokens=float(self.capacity),
                    last_refill=now,
                )
                self._buckets[key] = bucket

            # lazy refill
            elapsed = now - bucket.last_refill
            if elapsed > 0:
                added = elapsed * self.refill_rate
                bucket.tokens = min(self.capacity, bucket.tokens + added)
                bucket.last_refill = now

            if bucket.tokens >= tokens:
                bucket.tokens -= tokens
                return RateLimitResult(
                    allowed=True,
                    remaining=int(bucket.tokens),
                )

            # how long until enough tokens accumulate
            deficit = tokens - bucket.tokens
            wait_sec = deficit / self.refill_rate
            return RateLimitResult(
                allowed=False,
                retry_after=wait_sec,
                remaining=int(bucket.tokens),
            )

    def peek(self, key: str) -> int:
        """Check available tokens without consuming. Doesn't refill."""
        with self._mu:
            b = self._buckets.get(key)
            return int(b.tokens) if b else self.capacity


@dataclass
class _BucketState:
    tokens: float
    last_refill: float


# --- Composite limiter for multi-tier setups ---


class CompositeLimiter:
    """Chains multiple limiters. All must allow for request to proceed.

    We use this for the public API where we want both per-second burst
    protection (token bucket) and per-minute hard caps (sliding window).
    """

    def __init__(self, *limiters):
        if not limiters:
            raise ValueError("need at least one limiter")
        self._limiters = limiters

    def try_acquire(self, key: str, tokens: int = 1) -> RateLimitResult:
        results = []
        for lim in self._limiters:
            # token bucket takes a `tokens` param, sliding window doesn't
            if isinstance(lim, TokenBucketLimiter):
                r = lim.try_acquire(key, tokens)
            else:
                r = lim.try_acquire(key)
            results.append(r)

        denied = [r for r in results if not r.allowed]
        if denied:
            # return the longest wait — client should sleep for the max
            longest = max(r.retry_after or 0 for r in denied)
            return RateLimitResult(
                allowed=False,
                retry_after=longest if longest > 0 else None,
                remaining=min(r.remaining for r in results),
            )

        return RateLimitResult(
            allowed=True,
            remaining=min(r.remaining for r in results),
        )


def create_default_limiter(
    rpm: int = 60,
    burst: Optional[int] = None,
    refill: Optional[float] = None,
) -> CompositeLimiter:
    """Factory for the standard two-tier limiter we use on most endpoints.

    rpm: requests per minute cap (sliding window)
    burst: max burst capacity (defaults to 2x rpm)
    refill: tokens/sec refill rate (defaults to rpm/60)
    """
    if burst is None:
        burst = rpm * 2
    if refill is None:
        refill = rpm / 60.0

    sw = SlidingWindowLimiter(max_requests=rpm, window_sec=60)
    tb = TokenBucketLimiter(capacity=burst, refill_rate=refill)
    return CompositeLimiter(sw, tb)
