"""
Rate limiting module for API clients.

Supports sliding window and token bucket algorithms for controlling
request throughput to external services.
"""

import time
import threading
from collections import deque
from abc import ABC, abstractmethod


class RateLimiter(ABC):
    """Base class for rate limiting strategies."""

    @abstractmethod
    def acquire(self, tokens: int = 1, timeout: float | None = None) -> bool:
        """
        Attempt to acquire permission to make a request.

        Args:
            tokens: Number of tokens/permits to acquire.
            timeout: Max seconds to wait. None means don't block.

        Returns:
            True if acquired, False if rate limit would be exceeded.
        """
        ...

    @abstractmethod
    def reset(self) -> None:
        """Reset the limiter to its initial state."""
        ...


class SlidingWindowLimiter(RateLimiter):
    """
    Sliding window rate limiter.

    Tracks timestamps of recent requests and enforces a maximum number
    of requests within a rolling time window.

    Example:
        limiter = SlidingWindowLimiter(max_requests=100, window_seconds=60)
        if limiter.acquire():
            response = client.get("/endpoint")
    """

    def __init__(self, max_requests: int, window_seconds: float):
        if max_requests <= 0:
            raise ValueError("max_requests must be positive")
        if window_seconds <= 0:
            raise ValueError("window_seconds must be positive")

        self.max_requests = max_requests
        self.window_seconds = window_seconds
        self._timestamps: deque[float] = deque()
        self._lock = threading.Lock()

    def _evict_expired(self, now: float) -> None:
        cutoff = now - self.window_seconds
        while self._timestamps and self._timestamps[0] <= cutoff:
            self._timestamps.popleft()

    def acquire(self, tokens: int = 1, timeout: float | None = None) -> bool:
        if tokens > self.max_requests:
            return False

        deadline = time.monotonic() + timeout if timeout else None

        while True:
            with self._lock:
                now = time.monotonic()
                self._evict_expired(now)

                if len(self._timestamps) + tokens <= self.max_requests:
                    for _ in range(tokens):
                        self._timestamps.append(now)
                    return True

            if deadline is None:
                return False

            remaining = deadline - time.monotonic()
            if remaining <= 0:
                return False

            # Sleep briefly before retrying
            time.sleep(min(0.01, remaining))

    def reset(self) -> None:
        with self._lock:
            self._timestamps.clear()

    @property
    def available(self) -> int:
        """Number of requests available in the current window."""
        with self._lock:
            self._evict_expired(time.monotonic())
            return self.max_requests - len(self._timestamps)


class TokenBucketLimiter(RateLimiter):
    """
    Token bucket rate limiter.

    Tokens are added to the bucket at a fixed rate. Each request consumes
    one or more tokens. Allows short bursts up to the bucket capacity
    while enforcing an average rate over time.

    Example:
        # 10 requests/sec with burst capacity of 20
        limiter = TokenBucketLimiter(rate=10.0, capacity=20)
        if limiter.acquire():
            response = client.post("/data", json=payload)
    """

    def __init__(self, rate: float, capacity: int | None = None):
        """
        Args:
            rate: Tokens added per second.
            capacity: Maximum tokens in the bucket. Defaults to rate
                      (i.e., 1 second worth of tokens).
        """
        if rate <= 0:
            raise ValueError("rate must be positive")

        self.rate = rate
        self.capacity = capacity if capacity is not None else int(rate)
        if self.capacity <= 0:
            raise ValueError("capacity must be positive")

        self._tokens = float(self.capacity)
        self._last_refill = time.monotonic()
        self._lock = threading.Lock()

    def _refill(self) -> None:
        now = time.monotonic()
        elapsed = now - self._last_refill
        self._tokens = min(self.capacity, self._tokens + elapsed * self.rate)
        self._last_refill = now

    def acquire(self, tokens: int = 1, timeout: float | None = None) -> bool:
        if tokens > self.capacity:
            return False

        deadline = time.monotonic() + timeout if timeout else None

        while True:
            with self._lock:
                self._refill()

                if self._tokens >= tokens:
                    self._tokens -= tokens
                    return True

                # Calculate how long until enough tokens are available
                deficit = tokens - self._tokens
                wait_time = deficit / self.rate

            if deadline is None:
                return False

            remaining = deadline - time.monotonic()
            if remaining <= 0:
                return False

            time.sleep(min(wait_time, remaining))

    def reset(self) -> None:
        with self._lock:
            self._tokens = float(self.capacity)
            self._last_refill = time.monotonic()

    @property
    def available(self) -> float:
        """Approximate number of tokens currently available."""
        with self._lock:
            self._refill()
            return self._tokens


class CompositeRateLimiter(RateLimiter):
    """
    Combines multiple rate limiters. All must allow the request
    for it to proceed. Useful when you need to enforce both
    per-second and per-minute limits simultaneously.

    Example:
        limiter = CompositeRateLimiter([
            TokenBucketLimiter(rate=10.0, capacity=15),      # burst control
            SlidingWindowLimiter(max_requests=500, window_seconds=60),  # per-minute cap
        ])
    """

    def __init__(self, limiters: list[RateLimiter]):
        if not limiters:
            raise ValueError("At least one limiter is required")
        self._limiters = limiters

    def acquire(self, tokens: int = 1, timeout: float | None = None) -> bool:
        # Try all limiters. If any fails, the request is denied.
        # Note: this isn't perfectly atomic across limiters, but it's
        # good enough for most API client use cases.
        for limiter in self._limiters:
            if not limiter.acquire(tokens=tokens, timeout=timeout):
                return False
        return True

    def reset(self) -> None:
        for limiter in self._limiters:
            limiter.reset()
