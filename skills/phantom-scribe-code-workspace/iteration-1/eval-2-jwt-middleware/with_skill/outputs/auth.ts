import type { Response, NextFunction } from 'express';
import type { AuthenticatedRequest, AuthOpts, RoleGate, Role } from './types';
import { verifyToken, extractBearer } from './token';

const BYPASS_ENABLED = process.env.AUTH_BYPASS === '1'
  || process.env.AUTH_BYPASS === 'true';

/**
 * Core auth middleware. Validates JWT and attaches decoded claims to req.user.
 */
export function authenticate(opts: AuthOpts = {}) {
  const shouldBypass = opts.bypass ?? BYPASS_ENABLED;

  return (req: AuthenticatedRequest, res: Response, next: NextFunction) => {
    if (shouldBypass) {
      // stub user for local dev — roles match our seed data
      req.user = {
        sub: 'dev-user-000',
        email: 'dev@localhost',
        roles: ['admin'],
        org_id: 'org_local',
        iat: Math.floor(Date.now() / 1000),
        exp: Math.floor(Date.now() / 1000) + 86400,
      };
      return next();
    }

    const raw = extractBearer(req.headers.authorization);
    if (!raw) {
      return res.status(401).json({ error: 'missing auth token' });
    }

    const result = verifyToken(raw, {
      clockToleranceSec: opts.clockToleranceSec,
      issuer: opts.issuer,
    });

    if ('error' in result) {
      const status = result.expired ? 401 : 403;
      return res.status(status).json({ error: result.error });
    }

    req.user = result;
    req._authTs = Date.now();
    next();
  };
}

/**
 * Role gate — use after authenticate(). Checks that the user has
 * the required roles for this route.
 *
 * Usage:
 *   router.delete('/org/:id', authenticate(), requireRoles({ allow: ['admin'] }), handler)
 */
export function requireRoles(gate: RoleGate) {
  const matchMode = gate.match || 'any'; // default any — most common case

  return (req: AuthenticatedRequest, res: Response, next: NextFunction) => {
    const userRoles = req.user?.roles;

    // shouldn't happen if authenticate() ran first, but guard anyway
    if (!userRoles) {
      return res.status(401).json({ error: 'unauthenticated' });
    }

    const hasAccess = matchMode === 'any'
      ? gate.allow.some((r) => userRoles.includes(r))
      : gate.allow.every((r) => userRoles.includes(r));

    if (!hasAccess) {
      // don't leak which roles are required — just deny
      return res.status(403).json({ error: 'insufficient permissions' });
    }

    next();
  };
}

// convenience — combine auth + role check in one call for simple routes
export function authWithRoles(roles: Role[], opts?: AuthOpts) {
  const authMw = authenticate(opts);
  const roleMw = requireRoles({ allow: roles });

  return (req: AuthenticatedRequest, res: Response, next: NextFunction) => {
    authMw(req, res, (err?: any) => {
      if (err) return next(err);
      // res already sent if auth failed, but check just in case
      if (res.headersSent) return;
      roleMw(req, res, next);
    });
  };
}
