import { Injectable, Logger } from '@nestjs/common';
import { Cron, CronExpression } from '@nestjs/schedule';
import { PrismaService } from 'src/prisma/prisma.service';

@Injectable()
export class LogService {

  private readonly logger = new Logger(LogService.name)
  constructor(private readonly prisma: PrismaService) {}

  private async Average(user_id: string): Promise<number | null> {
    const log = await this.prisma.smoking_Log.findUnique({
      where: {user_id},
      select: {
        smoke_totalCount: true,
        created_at: true,
      },
    });

    if(!log) return null;

    const startDate = new Date(log.created_at!);
    const today = new Date();
    const diffTime = today.getTime() - startDate.getTime();
    const diffDays = Math.floor(diffTime / (1000 * 60 * 60 * 24)) + 1;

    return log.smoke_totalCount! / diffDays;
  }

  async getPredictionLog(user_id: string) {
    const log = await this.prisma.smoking_Log.findUnique({
      where: { user_id },
      select: {
        smoke_totalCount: true,
        smoke_price: true,
      },
    });

    if (!log) return null;

    //計算

    const average = await this.Average(user_id);
    const threeMonthsPredictionSmoke = average ? Math.round(average * 30 * 3) : null;
    const pricePerCigarette = log.smoke_price! /20;
    

    let boxNum = Math.floor(log.smoke_totalCount! / 20);
    const remainder = log.smoke_totalCount! % 20;

    if (remainder !== 0) {
      boxNum++;
    }

    //結果
    const threeMonthsPredictionPrice = threeMonthsPredictionSmoke !== null
      ? Math.round(threeMonthsPredictionSmoke * pricePerCigarette)
      : null;
    const usePrice = boxNum * log.smoke_price!;
    const lifespan = log.smoke_totalCount! * 11;
    const useTime = log.smoke_totalCount! * 5;
    return {
      threeMonthsPredictionPrice,
      usePrice,
      totalSmoke: log.smoke_totalCount,
      lifespan,
      useTime
    };
  }

  async topLog (user_id: string) {
    const topLog = await this.prisma.smoking_Log.findUnique({
      where: {user_id},
      select: {
        smoke_todayCount: true,
        smoke_totalCount: true,
        created_at: true
      }
    });

    if (!topLog) return null;

    const average = await this.Average(user_id)
    console.log('topLog成功');
    return {
      today: topLog.smoke_todayCount,
      average: Math.floor(average!),
    }
  }

  async count (user_id) {
    const countIncrement = await this.prisma.smoking_Log.update({
      where: {user_id},
      data:{
        smoke_totalCount: {increment: 1},
        smoke_todayCount: {increment: 1}
      },
      select: {
        user_id: true,
        smoke_totalCount: true,
        smoke_todayCount: true,
      }
    })

    console.log('count成功');
    return { today: countIncrement.smoke_todayCount };
  }

  @Cron(CronExpression.EVERY_DAY_AT_MIDNIGHT)
  async resetTodayCount() {
    try {
      await this.prisma.smoking_Log.updateMany({
        data: { smoke_todayCount : 0 },
      });
      this.logger.log('全ユーザーのtodayCountをリセットしました')
    } catch (error) {
      this.logger.error('todayCountのリセットに失敗', error.stack)
    }
  }
  
}
