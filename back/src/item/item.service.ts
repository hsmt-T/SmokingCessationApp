import { Injectable } from '@nestjs/common';
import { PrismaService } from 'src/prisma/prisma.service';

@Injectable()
export class ItemService {
  constructor (private readonly prisma : PrismaService) {}

  // findAll() {
  //   return this.prisma.items.findMany()
  // }

  async findOne(threeMonthsPredictionPrice: number) {
  const item = await this.prisma.items.findFirst({
    where: {
      item_price: {
        lte: threeMonthsPredictionPrice,
      },
    },
    orderBy: {
      item_price: 'desc',
    },
  });

  if (!item) return "";
  return item.item_name;
}

}
