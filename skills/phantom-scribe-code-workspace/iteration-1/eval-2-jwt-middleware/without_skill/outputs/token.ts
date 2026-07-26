import jwt, { JsonWebTokenError, TokenExpiredError } from 'jsonwebtoken';
import { TokenPayload, AuthConfig, AuthError } from './types';

const DEFAULT_CLOCK_TOLERANCE = 30; // seconds

export function validateToken(token: string, config: AuthConfig): TokenPayload {
  try {
    const payload = jwt.verify(token, config.secret, {
      issuer: config.issuer,
      audience: config.audience,
      clockTolerance: config.clockToleranceSec ?? DEFAULT_CLOCK_TOLERANCE,
      algorithms: ['HS256', 'HS384', 'HS512'],
    }) as TokenPayload;

    if (!payload.sub || !Array.isArray(payload.roles)) {
      throw new AuthError('Token payload missing required fields', 401, 'INVALID_TOKEN');
    }

    return payload;
  } catch (err) {
    if (err instanceof AuthError) {
      throw err;
    }
    if (err instanceof TokenExpiredError) {
      throw new AuthError('Token has expired', 401, 'TOKEN_EXPIRED');
    }
    if (err instanceof JsonWebTokenError) {
      throw new AuthError(`Invalid token: ${err.message}`, 401, 'INVALID_TOKEN');
    }
    throw new AuthError('Token validation failed', 401, 'VALIDATION_FAILED');
  }
}

export function extractBearerToken(authHeader: string | undefined): string {
  if (!authHeader) {
    throw new AuthError('Authorization header is missing', 401, 'MISSING_AUTH_HEADER');
  }

  const parts = authHeader.split(' ');
  if (parts.length !== 2 || parts[0] !== 'Bearer') {
    throw new AuthError('Authorization header must use Bearer scheme', 401, 'INVALID_AUTH_SCHEME');
  }

  const token = parts[1];
  if (!token || token.length === 0) {
    throw new AuthError('Bearer token is empty', 401, 'EMPTY_TOKEN');
  }

  return token;
}
