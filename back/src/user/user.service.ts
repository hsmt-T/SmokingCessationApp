import { Injectable } from '@nestjs/common';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { PrismaServise } from 'src/prisma/prisma.service';

@Injectable()
export class UserService {
  constructor(private readonly prisma: PrismaServise) {}

  create(createUserDto: CreateUserDto) {
    return 'This action adds a new user';
  }

  patchSetting(updateData: UpdateUserDto, user_id: string) {
    return this.prisma.smoking_Log.update({
      where: {user_id},
      data: updateData
    })
  }
}
