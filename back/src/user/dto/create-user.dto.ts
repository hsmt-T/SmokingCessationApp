import { IsInt, IsOptional, IsString } from 'class-validator';

export class CreateUserDto {
    @IsString()
    user_id: string;

    @IsString()
    user_name: string;

    @IsOptional()
    @IsInt()
    smoke_totalCount?: number;

    @IsOptional()
    @IsString()
    smoke_type?: string;

    @IsOptional()
    @IsInt()
    smoke_price?: number;

    @IsOptional()
    @IsInt()
    smoke_todayCount?: number;
}
