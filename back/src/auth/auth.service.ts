import { Injectable, UnauthorizedException } from '@nestjs/common';
import { HttpService } from '@nestjs/axios';
import { JwtService } from '@nestjs/jwt';
import axios from 'axios';
import { URLSearchParams } from 'url';
import * as jwt from 'jsonwebtoken';
import jwkToPem from 'jwk-to-pem';

interface LineIdTokenPayload {
  sub: string;
  name: string;
  picture?: string;
  [key: string]: any;
}

@Injectable()
export class AuthService {
  constructor(
    private readonly http: HttpService,
    private readonly jwtService: JwtService,
  ) {}

  getLoginUrl(): string {
    const clientId = process.env.LINE_CLIENT_ID!;
    const redirectUri = process.env.LINE_REDIRECT_URI!;
    const params = new URLSearchParams({
      response_type: 'code',
      client_id: clientId,
      redirect_uri: redirectUri,
      state: 'random_state_string',
      scope: 'openid profile',
    });
    return `https://access.line.me/oauth2/v2.1/authorize?${params}`;
  }

  async handleCallback(code: string) {
    try {
      const redirectUri = process.env.LINE_REDIRECT_URI!;
      const clientId = process.env.LINE_CLIENT_ID!;
      const clientSecret = process.env.LINE_CLIENT_SECRET!;

      const tokenRes = await this.http.axiosRef.post(
        'https://api.line.me/oauth2/v2.1/token',
        new URLSearchParams({
          grant_type: 'authorization_code',
          code,
          redirect_uri: redirectUri,
          client_id: clientId,
          client_secret: clientSecret,
        }),
        { headers: { 'Content-Type': 'application/x-www-form-urlencoded' } },
      );

      const { id_token } = tokenRes.data;
      const userInfo = await this.verifyIdToken(id_token);

      const appToken = this.jwtService.sign({
        sub: userInfo.sub,
        name: userInfo.name,
      });

      return { user: userInfo, jwt: appToken };
    } catch (e) {
      console.error('LINE login error:', e.response?.data || e.message || e);
      throw new UnauthorizedException('LINE login failed');
    }
  }

  private async verifyIdToken(idToken: string) {
    const decodedHeader = jwt.decode(idToken, { complete: true }) as any;
    if (!decodedHeader || !decodedHeader.header?.alg) {
      throw new UnauthorizedException('不正なid_tokenです');
    }

    const alg = decodedHeader.header.alg;
    let payload: LineIdTokenPayload;

    if (alg === 'HS256') {
      payload = jwt.verify(idToken, process.env.LINE_CLIENT_SECRET!, {
        algorithms: ['HS256'],
        audience: process.env.LINE_CLIENT_ID,
        issuer: 'https://access.line.me',
      }) as LineIdTokenPayload;
    } else if (alg === 'RS256') {
      const jwtRes = await axios.get('https://api.line.me/oauth2/v2.1/certs');
      const jwks = jwtRes.data.keys;
      const kid = decodedHeader.header.kid;
      const jwk = jwks.find((key) => key.kid === kid);
      if (!jwk) throw new UnauthorizedException('keyが間違っています');

      const pubkey = jwkToPem(jwk);
      payload = jwt.verify(idToken, pubkey, {
        algorithms: ['RS256'],
        audience: process.env.LINE_CLIENT_ID,
        issuer: 'https://access.line.me',
      }) as LineIdTokenPayload;
    } else {
      throw new UnauthorizedException(`未対応の署名アルゴリズム: ${alg}`);
    }

    return {
      sub: payload.sub,
      name: payload.name,
      picture: payload.picture,
    };
  }
}
