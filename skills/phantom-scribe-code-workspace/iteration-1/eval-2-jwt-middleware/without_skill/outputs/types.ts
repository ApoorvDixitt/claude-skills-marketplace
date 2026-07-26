import { Request } from 'express';

export interface TokenPayload {
  sub: string;
  email: string;
  roles: Role[];
  iat: number;
  exp: number;
}

export type Role = 'admin' | 'editor' | 'viewer' | 'service';

export interface AuthenticatedRequest extends Request {
  user: TokenPayload;
}

export interface AuthConfig {
  secret: string;
  issuer?: string;
  audience?: string;
  clockToleranceSec?: number;
}

export class AuthError extends Error {
  constructor(
    message: string,
    public readonly statusCode: number = 401,
    public readonly code: string = 'UNAUTHORIZED'
  ) {
    super(message);
    this.name = 'AuthError';
  }
}
