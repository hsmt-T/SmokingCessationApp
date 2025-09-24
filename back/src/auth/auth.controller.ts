import { Controller, Get, Query, Redirect, } from '@nestjs/common';
import { AuthService } from './auth.service';

@Controller('auth/line')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  // Flutter が叩くエンドポイント
  @Get('login')
  getLoginUrl() {
    return { url: this.authService.getLoginUrl() };
  }

  // LINEからのコールバック
  @Get('callback')
  @Redirect()
  async callback(@Query('code') code: string,) {
    const result = await this.authService.handleCallback(code);
    console.log(code)

    // DeepLink にリダイレクト
    const jwt = result.jwt;
    return { url: `nosmoke://callback?jwt=${jwt}` };
  }
}
