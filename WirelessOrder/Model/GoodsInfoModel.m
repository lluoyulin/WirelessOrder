//
//  GoodsInfoModel.m
//  WirelessOrder
//
//  Created by eteng on 14/12/23.
//  Copyright (c) 2014年 etenginfo. All rights reserved.
//

#import "GoodsInfoModel.h"
#import "FMDatabase.h"
#import "FMResultSet.h"

@implementation GoodsInfoModel

+(GoodsInfoModel *)GoodsModelFromDictionary:(NSDictionary *)dic
{
    GoodsInfoModel *model=[[GoodsInfoModel alloc] init];
    model.good_production=[dic objectForKey:@"goodProduction"];
    model.goods_id=[dic objectForKey:@"goodsId"];
    model.goods_img_path=[dic objectForKey:@"goodsImgPath"];
    model.goods_name=[dic objectForKey:@"goodsName"];
    model.goods_number=[dic objectForKey:@"goodsNumber"];
    model.goods_price=[dic objectForKey:@"goodsPrice"];
    model.goods_serial=[dic objectForKey:@"goodsSerial"];
    model.goods_status=[dic objectForKey:@"goodsStatus"];
    model.goods_type=[dic objectForKey:@"goodsType"];
    model.discount_price=[dic objectForKey:@"discountPrice"];
    model.create_person=[dic objectForKey:@"createPerson"];
    model.create_time=[dic objectForKey:@"createTime"];
    model.goods_class=[dic objectForKey:@"goodsClass"];
    model.goods_owner_id=[dic objectForKey:@"goodsOwnerId"];
    model.goods_sort=[dic objectForKey:@"goodsOrder"];
    
    return model;
}

+(BOOL)checkTableCreateInDb:(FMDatabase *)db
{
    NSString *sql=@"CREATE TABLE IF NOT EXISTS goods ('goods_id' text,'goods_owner_id' text,'goods_serial' text,'goods_name' text,'good_production' text,'goods_price' text,'discount_price' text,'goods_number' text,'goods_img_path' text,'goods_type' text,'goods_status' text,'create_time' text,'create_person' text,'goods_class' text,'goods_sort' INTEGER)";
    BOOL worked=[db executeUpdate:sql];
    
    return worked;
}

+(BOOL)saveGoods:(GoodsInfoModel *)model
{
    FMDatabase *db=[FMDatabase databaseWithPath:DATABASE_PATH];
    
    if (![db open]) {
        NSLog(@"打开数据库失败");
        return NO;
    }
    
    [self checkTableCreateInDb:db];
    
    NSString *sql=@"insert or replace into goods ('goods_id','goods_owner_id','goods_serial','goods_name','good_production','goods_price','discount_price','goods_number','goods_img_path','goods_type','goods_status','create_time','create_person','goods_class','goods_sort') values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    
    BOOL worked=[db executeUpdate:sql,model.goods_id,model.goods_owner_id,model.goods_serial,model.goods_name,model.good_production,model.goods_price,model.discount_price,model.goods_number,model.goods_img_path,model.goods_type,model.goods_status,model.create_time,model.create_person,model.goods_class,model.goods_sort];
    [db close];
    
    return worked;
}

+(BOOL)deleteAllGoods:(NSString *)where
{
    FMDatabase *db=[FMDatabase databaseWithPath:DATABASE_PATH];
    
    if (![db open]) {
        NSLog(@"打开数据库失败");
        return NO;
    }
    
    [self checkTableCreateInDb:db];
    
    NSMutableString *sql=[[NSMutableString alloc] initWithString:@"delete from goods"];
    if (where!=nil) {
        [sql appendFormat:@" where %@",where];
    }
    
    BOOL worked=[db executeUpdate:sql];
    [db close];
    
    return worked;
}

+(NSMutableArray *)getAllGoods:(NSString *)where
{
    FMDatabase *db=[FMDatabase databaseWithPath:DATABASE_PATH];
    
    NSMutableArray *arr=[[NSMutableArray alloc] init];
    
    if (![db open]) {
        NSLog(@"打开数据库失败");
        return arr;
    }
    
    [self checkTableCreateInDb:db];
    
    NSMutableString *sql=[[NSMutableString alloc] initWithString:@"select * from goods"];
    if (where!=nil) {
        [sql appendFormat:@" where %@ order by goods_sort",where];
    }
    else{
        [sql appendString:@" order by goods_sort"];
    }
    
    FMResultSet *result=[db executeQuery:sql];
    GoodsInfoModel *model;
    while ([result next]) {
        model=[[GoodsInfoModel alloc] init];
        model.good_production=[result stringForColumn:@"good_production"];
        model.goods_class=[result stringForColumn:@"goods_class"];
        model.goods_id=[result stringForColumn:@"goods_id"];
        model.goods_img_path=[result stringForColumn:@"goods_img_path"];
        model.goods_name=[result stringForColumn:@"goods_name"];
        model.goods_number=[result stringForColumn:@"goods_number"];
        model.goods_owner_id=[result stringForColumn:@"goods_owner_id"];
        model.goods_price=[result stringForColumn:@"goods_price"];
        model.goods_serial=[result stringForColumn:@"goods_serial"];
        model.goods_status=[result stringForColumn:@"goods_status"];
        model.goods_type=[result stringForColumn:@"goods_type"];
        model.discount_price=[result stringForColumn:@"discount_price"];
        model.create_person=[result stringForColumn:@"create_person"];
        model.create_time=[result stringForColumn:@"create_time"];
        model.goods_sort=[result stringForColumn:@"goods_sort"];
        [arr addObject:model];
    }
    [db close];
    
    return arr;
}

+(BOOL)updateGoodsStatus:(NSString *)goods_status goods_id:(NSString *)goods_id
{
    FMDatabase *db=[FMDatabase databaseWithPath:DATABASE_PATH];
    
    if (![db open]) {
        NSLog(@"打开数据库失败");
        return NO;
    }
    
    [self checkTableCreateInDb:db];
    
    NSString *sql=@"update goods set goods_status=? where goods_id=?";
    
    BOOL worked=[db executeUpdate:sql,goods_status,goods_id];
    [db close];
    
    return worked;
}

+(BOOL)updateGoodsSort:(NSString *)goods_sort goods_id:(NSString *)goods_id
{
    FMDatabase *db=[FMDatabase databaseWithPath:DATABASE_PATH];
    
    if (![db open]) {
        NSLog(@"打开数据库失败");
        return NO;
    }
    
    [self checkTableCreateInDb:db];
    
    NSString *sql=@"update goods set goods_sort=? where goods_id=?";
    
    BOOL worked=[db executeUpdate:sql,goods_sort,goods_id];
    [db close];
    
    return worked;
}

@end
