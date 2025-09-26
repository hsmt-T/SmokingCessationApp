import { Controller, Get, UseGuards,  Req,InternalServerErrorException } from '@nestjs/common';
import { LogService } from './log.service';
import { JwtAuthGuard } from 'src/auth/jwt-auth.guard'

@Controller('log')
export class LogController {
  constructor(private readonly logService: LogService ) {}

  @UseGuards(JwtAuthGuard)
  @Get('')
  async getlog (@Req() req: any) {
    try {
      const user_id = req.user?.user_id;
      return await this.logService.getPredictionLog(user_id);
    } catch (error) {
      console.log("LOG取得エラー", error)
      throw new InternalServerErrorException('LOG取得に失敗しました');
    }
  }
  
  @UseGuards(JwtAuthGuard)
  @Get('top')
  async getTopLog (@Req() req: any) {
    try {
      const user_id = req.user?.user_id
      return await this.logService.topLog(user_id);
    } catch (error) {
      console.log("TOPLOG取得エラー", error)
      throw new InternalServerErrorException('TOPLOG取得に失敗しました');
    }
  }
}
