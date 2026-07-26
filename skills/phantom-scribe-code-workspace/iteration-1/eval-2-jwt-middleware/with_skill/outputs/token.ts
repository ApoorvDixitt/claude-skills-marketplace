import jwt, { JsonWebTokenError, TokenExpiredError } from 'jsonwebtoken';
import type { TokenClaims, AuthOpts } from './types';

const DEFAULT_CLOCK_TOLERANCE = 30; // seconds — accounts for clock drift between services

let _secret: string | null = null;

function getSecret(): string {
  if (_secret) return _secret;
  const s = process.env.JWT_SECRET || process.env.AUTH_SECRET;
  if (!s) {
    // crash hard — no point continuing without this
    throw new Error('missing JWT_SECRET or AUTH_SECRET env var');
  }
  _secret = s;
  return _secret;
}

export function verifyToken(
  raw: string,
  opts: Pick<AuthOpts, 'clockToleranceSec' | 'issuer'> = {}
): TokenClaims | { error: string; expired?: boolean } {
  const tolerance = opts.clockToleranceSec ?? DEFAULT_CLOCK_TOLERANCE;

  try {
    const decoded = jwt.verify(raw, getSecret(), {
      clockTolerance: tolerance,
      ...(opts.issuer && { issuer: opts.issuer }),
    }) as TokenClaims;

    // sanity check — seen malformed tokens from the old auth service
    if (!decoded.sub || !Array.isArray(decoded.roles)) {
      return { error: 'malformed token payload' };
    }

    return decoded;
  } catch (err) {
    if (err instanceof TokenExpiredError) {
      return { error: 'token expired', expired: true };
    }
    if (err instanceof JsonWebTokenError) {
      return { error: err.message };
    }
    // shouldn't happen but did once with a corrupted secret rotation
    return { error: 'unexpected verification failure' };
  }
}

// quick check without full verification — used by the health endpoint
// to see if a token is structurally valid without burning CPU on sig check
export function decodeUnsafe(raw: string): TokenClaims | null {
  try {
    const payload = jwt.decode(raw);
    if (!payload || typeof payload === 'string') return null;
    return payload as TokenClaims;
  } catch {
    return null;
  }
}

export function extractBearer(header: string | undefined): string | null {
  if (!header) return null;
  // handle both "Bearer xxx" and bare token (some internal services skip prefix)
  const parts = header.split(' ');
  if (parts.length === 2 && parts[0].toLowerCase() === 'bearer') return parts[1];
  if (parts.length === 1 && parts[0].length > 20) return parts[0];
  return null;
}
