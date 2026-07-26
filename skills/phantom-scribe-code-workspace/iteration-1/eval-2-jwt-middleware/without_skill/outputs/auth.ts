import { Request, Response, NextFunction } from 'express';
import { AuthenticatedRequest, AuthConfig, AuthError, Role } from './types';
import { validateToken, extractBearerToken } from './token';

/**
 * Creates an authentication middleware that validates JWT tokens
 * and attaches the decoded payload to `req.user`.
 */
export function authenticate(config: AuthConfig) {
  return (req: Request, res: Response, next: NextFunction): void => {
    try {
      const token = extractBearerToken(req.headers.authorization);
      const payload = validateToken(token, config);

      (req as AuthenticatedRequest).user = payload;
      next();
    } catch (err) {
      if (err instanceof AuthError) {
        res.status(err.statusCode).json({
          error: err.code,
          message: err.message,
        });
        return;
      }
      res.status(500).json({
        error: 'INTERNAL_ERROR',
        message: 'An unexpected error occurred during authentication',
      });
    }
  };
}

/**
 * Creates a middleware that checks whether the authenticated user
 * has at least one of the required roles.
 *
 * Must be placed after `authenticate` in the middleware chain.
 */
export function requireRoles(...allowedRoles: Role[]) {
  return (req: Request, res: Response, next: NextFunction): void => {
    const user = (req as AuthenticatedRequest).user;

    if (!user) {
      res.status(401).json({
        error: 'UNAUTHENTICATED',
        message: 'Authentication is required before checking roles',
      });
      return;
    }

    const hasRole = user.roles.some((role) => allowedRoles.includes(role));
    if (!hasRole) {
      res.status(403).json({
        error: 'FORBIDDEN',
        message: `Requires one of: ${allowedRoles.join(', ')}`,
      });
      return;
    }

    next();
  };
}

/**
 * Convenience: combines authenticate + requireRoles into a single middleware array.
 *
 * Usage:
 *   router.get('/admin', ...authorizeRoles(config, 'admin'), handler);
 */
export function authorizeRoles(config: AuthConfig, ...roles: Role[]) {
  return [authenticate(config), requireRoles(...roles)];
}
