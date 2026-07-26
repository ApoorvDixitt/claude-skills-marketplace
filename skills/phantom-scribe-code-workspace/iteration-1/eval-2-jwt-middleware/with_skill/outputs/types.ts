import type { Request } from 'express';

// kept in sync with the IAM service schema (v3)
export interface TokenClaims {
  sub: string;
  email: string;
  roles: Role[];
  org_id: string;
  iat: number;
  exp: number;
  // added for the audit trail feature, may be undefined on older tokens
  session_id?: string;
}

export type Role = 'admin' | 'editor' | 'viewer' | 'billing' | 'support';

export interface AuthenticatedRequest extends Request {
  user: TokenClaims;
  _authTs?: number; // perf tracking, set in middleware
}

// maps route patterns to minimum required roles
export type RoleGate = {
  allow: Role[];
  // if true, ANY of the listed roles is sufficient; default is ALL required
  match?: 'any' | 'all';
};

export interface AuthOpts {
  /**
   * Skip verification in local dev — obviously never in prod.
   * Reads from AUTH_BYPASS env if not set here.
   */
  bypass?: boolean;
  clockToleranceSec?: number;
  issuer?: string;
}
