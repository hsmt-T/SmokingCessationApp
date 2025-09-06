import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { AuthModule } from './auth/auth.module';
import { PrismaModule } from './prisma/prisma.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: '.env', // .env を全体で使えるようにする
    }),
    PrismaModule,
    AuthModule, // ← ここで認証モジュールを読み込み
  ],
})
export class AppModule {}
