import { IsNumber } from 'class-validator';

export class FindItemDto {
    @IsNumber()
    threeMonthsPredictionPrice: number;
}
