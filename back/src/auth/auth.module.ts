import { Module } from '@nestjs/common';
import { HttpModule } from '@nestjs/axios';
import { PassportModule } from '@nestjs/passport'; 
import { JwtModule } from '@nestjs/jwt';
import { JwtStrategy } from './jwt.strategy';  
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';

@Module({
  imports: [
    HttpModule,
    PassportModule.register({ defaultStrategy: 'jwt'}),
    JwtModule.register({
      secret: process.env.JWT_SECRET || 'default_secret',
      signOptions: { expiresIn: '7d' },
    }),
  ],
  controllers: [AuthController],
  providers: [AuthService, JwtStrategy],
})
export class AuthModule {}
