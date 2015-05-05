//
//  OrderDetailInfoModel.m
//  WirelessOrder
//
//  Created by eteng on 14/12/24.
//  Copyright (c) 2014年 etenginfo. All rights reserved.
//

#import "OrderDetailInfoModel.h"
#import "FMDatabase.h"
#import "FMResultSet.h"

@implementation OrderDetailInfoModel

+(OrderDetailInfoModel *)OrderDetailInfoModelFromDictionary:(NSDictionary *)dic
{
    OrderDetailInfoModel *model=[[OrderDetailInfoModel alloc] init];
    model.detail_id=[dic objectForKey:@"detailId"];
    model.order_id=[dic objectForKey:@"orderId"];
    model.goods_id=[dic objectForKey:@"goodsId"];
    model.goods_name=[dic objectForKey:@"goodsName"];
    model.goods_single_price=[dic objectForKey:@"goodsSinglePrice"];
    model.goods_discount_price=[dic objectForKey:@"goodsDiscountPrice"];
    model.goods_number=[dic objectForKey:@"goodsNumber"];
    model.goods_attach_name=[dic objectForKey:@"goodsAttachName"];
    model.goods_attach_price=[dic objectForKey:@"goodsAttachPrice"];
    model.ask_for=[dic objectForKey:@"askFor"];
    model.total_price=[dic objectForKey:@"totalPrice"];
    model.create_time=[dic objectForKey:@"createTime"];
    model.create_person=[dic objectForKey:@"createPerson"];
    
    return model;
}

+(BOOL)checkTableCreateInDb:(FMDatabase *)db
{
    NSString *sql=@"CREATE TABLE IF NOT EXISTS order_detail ('detail_id' text,'order_id' text,'goods_id' text,'goods_name' text,'goods_single_price' text,'goods_discount_price' text,'goods_number' text,'goods_attach_name' text,'goods_attach_price' text,'ask_for' text,'total_price' text,'create_time' text,'create_person' text)";
    BOOL worked=[db executeUpdate:sql];
    
    return worked;
}

+(BOOL)saveOrderDetail:(OrderDetailInfoModel *)model
{
    FMDatabase *db=[FMDatabase databaseWithPath:DATABASE_PATH];
    
    if (![db open]) {
        NSLog(@"打开数据库失败");
        return NO;
    }
    
    [self checkTableCreateInDb:db];
    
    NSString *sql=@"insert or replace into order_detail ('detail_id' ,'order_id' ,'goods_id' ,'goods_name' ,'goods_single_price' ,'goods_discount_price' ,'goods_number' ,'goods_attach_name' ,'goods_attach_price' ,'ask_for' ,'total_price' ,'create_time' ,'create_person' ) values(?,?,?,?,?,?,?,?,?,?,?,?,?)";
    
    BOOL worked=[db executeUpdate:sql,model.detail_id,model.order_id,model.goods_id,model.goods_name,model.goods_single_price,model.goods_discount_price,model.goods_number,model.goods_attach_name,model.goods_attach_price,model.ask_for,model.total_price,model.create_time,model.create_person];
    [db close];
    
    return worked;
}

+(BOOL)deleteAllOrderDetail:(NSString *)where
{
    FMDatabase *db=[FMDatabase databaseWithPath:DATABASE_PATH];
    
    if (![db open]) {
        NSLog(@"打开数据库失败");
        return NO;
    }
    
    [self checkTableCreateInDb:db];
    
    NSMutableString *sql=[[NSMutableString alloc] initWithString:@"delete from order_detail"];
    if (where!=nil) {
        [sql appendFormat:@" where %@",where];
    }
    
    BOOL worked=[db executeUpdate:sql];
    [db close];
    
    return worked;
}

+(NSMutableArray *)getAllOrderDetail:(NSString *)where
{
    FMDatabase *db=[FMDatabase databaseWithPath:DATABASE_PATH];
    
    NSMutableArray *arr=[[NSMutableArray alloc] init];
    
    if (![db open]) {
        NSLog(@"打开数据库失败");
        return arr;
    }
    
    [self checkTableCreateInDb:db];
    
    NSMutableString *sql=[[NSMutableString alloc] initWithString:@"select * from order_detail"];
    if (where!=nil) {
        [sql appendFormat:@" where %@ order by create_time desc",where];
    }
    else{
        [sql appendString:@" order by create_time desc"];
    }
    
    FMResultSet *result=[db executeQuery:sql];
    OrderDetailInfoModel *model;
    while ([result next]) {
        model=[[OrderDetailInfoModel alloc] init];
        model.detail_id=[result stringForColumn:@"detail_id"];
        model.order_id=[result stringForColumn:@"order_id"];
        model.goods_id=[result stringForColumn:@"goods_id"];
        model.goods_name=[result stringForColumn:@"goods_name"];
        model.goods_single_price=[result stringForColumn:@"goods_single_price"];
        model.goods_discount_price=[result stringForColumn:@"goods_discount_price"];
        model.goods_number=[result stringForColumn:@"goods_number"];
        model.goods_attach_name=[result stringForColumn:@"goods_attach_name"];
        model.goods_attach_price=[result stringForColumn:@"goods_attach_price"];
        model.ask_for=[result stringForColumn:@"ask_for"];
        model.total_price=[result stringForColumn:@"total_price"];
        model.create_time=[result stringForColumn:@"create_time"];
        model.create_person=[result stringForColumn:@"create_person"];
        [arr addObject:model];
    }
    [db close];
    
    return arr;
}


@end
