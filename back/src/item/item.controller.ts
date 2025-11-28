import { Controller, Post, Body} from '@nestjs/common';
import { ItemService } from './item.service';
import { FindItemDto } from './dto/item.dto';

@Controller('item')
export class ItemController {
  constructor(private readonly itemService: ItemService) {}

  @Post()
  async findOne(@Body() body: FindItemDto) {
    return await this.itemService.findOne(body.threeMonthsPredictionPrice);
  }
}
