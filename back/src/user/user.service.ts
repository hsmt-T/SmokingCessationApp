import { Injectable } from '@nestjs/common';
import { UpdateUserDto } from './dto/update-user.dto';
import { PrismaService } from 'src/prisma/prisma.service';

@Injectable()
export class UserService {
  constructor(private readonly prisma: PrismaService) {}

  patchSetting(updateData: UpdateUserDto, user_id: string) {
    return this.prisma.smoking_Log.update({
      where: {user_id},
      data: updateData
    })
  }
}
