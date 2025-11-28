import { Injectable } from '@nestjs/common';
import { PrismaService } from 'src/prisma/prisma.service';

@Injectable()
export class ItemService {
  constructor (private readonly prisma : PrismaService) {}

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

  if (!item) return { buyItemName: null };

  return { buyItemName: item.item_name};
  }
}
