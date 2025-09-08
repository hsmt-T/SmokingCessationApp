import { Controller, Get, UseGuards,Req } from '@nestjs/common';
import { UserService } from './user.service';
import { AuthGuard } from '@nestjs/passport';

@Controller('user')
export class UserController {
  constructor(private readonly userService: UserService) {}

  @UseGuards(AuthGuard('jet'))
  @Get('me')
  getMe(@Req() req: any) {
    return req.user;
  }
}
