import { Controller, Get, UseGuards,Req, Patch, Body,InternalServerErrorException } from '@nestjs/common';
import { UserService } from './user.service';
import { JwtAuthGuard } from 'src/auth/jwt-auth.guard'
import { UpdateUserDto } from './dto/update-user.dto';

@Controller('user')
export class UserController {
  constructor(private readonly userService: UserService) {}

  @UseGuards(JwtAuthGuard)
  @Get('me')
  getMe(@Req() req: any) {
    return req.user;
  }

  @UseGuards(JwtAuthGuard)
  @Patch('')
  patchSetting(@Body() updateData: UpdateUserDto,@Req() req: any) {
    try {
      const user_id = req.user?.user_id;
      return this.userService.patchSetting(updateData,user_id);
    } catch (error) {
      console.log("設定変更エラー", error);
      throw new InternalServerErrorException('設定更新に失敗しました');
    }
  }
}
