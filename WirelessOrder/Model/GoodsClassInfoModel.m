//
//  GoodsClassInfoModel.m
//  WirelessOrder
//
//  Created by eteng on 14/12/23.
//  Copyright (c) 2014年 etenginfo. All rights reserved.
//

#import "GoodsClassInfoModel.h"
#import "FMResultSet.h"
#import "FMDatabase.h"

@implementation GoodsClassInfoModel

+(GoodsClassInfoModel *)GoodsClassModelFromDictionary:(NSDictionary *)dic
{
    GoodsClassInfoModel *moele=[[GoodsClassInfoModel alloc] init];
    moele.class_id=[dic objectForKey:@"classId"];
    moele.seller_id=[dic objectForKey:@"sellerId"];
    moele.class_code=[dic objectForKey:@"classCode"];
    moele.class_name=[dic objectForKey:@"className"];
    moele.create_date=[dic objectForKey:@"createDate"];
    moele.create_person=[dic objectForKey:@"createPerson"];
    moele.class_sort=[dic objectForKey:@"classOrder"];
    moele.class_status=[dic objectForKey:@"classStatus"];
    moele.is_noodle=[dic objectForKey:@"isNoodle"];
    return moele;
}

+(BOOL)checkTableCreateInDb:(FMDatabase *)db
{
    NSString *sql=@"CREATE TABLE IF NOT EXISTS goods_class ('class_id' text,'seller_id' text,'class_code' text,'class_name' text,'create_date' text,'create_person' text,'class_sort' INTEGER,'class_status' text,'is_noodle' text)";
    BOOL worked=[db executeUpdate:sql];
    
    return worked;
}

+(BOOL)saveGoodsClass:(GoodsClassInfoModel *)model
{
    FMDatabase *db=[FMDatabase databaseWithPath:DATABASE_PATH];
    
    if (![db open]) {
        NSLog(@"打开数据库失败");
        return NO;
    }
    
    [self checkTableCreateInDb:db];
    
    NSString *sql=@"insert or replace into goods_class ('class_id' ,'seller_id' ,'class_code' ,'class_name' ,'create_date' ,'create_person' ,'class_sort','class_status','is_noodle') values(?,?,?,?,?,?,?,?,?)";
    
    BOOL worked=[db executeUpdate:sql,model.class_id,model.seller_id,model.class_code,model.class_name,model.create_date,model.create_person,model.class_sort,model.class_status,model.is_noodle];
    [db close];
    
    return worked;
}

+(BOOL)deleteAllGoodsClass:(NSString *)where
{
    FMDatabase *db=[FMDatabase databaseWithPath:DATABASE_PATH];
    
    if (![db open]) {
        NSLog(@"打开数据库失败");
        return NO;
    }
    
    [self checkTableCreateInDb:db];
    
    NSMutableString *sql=[[NSMutableString alloc] initWithString:@"delete from goods_class"];
    if (where!=nil) {
        [sql appendFormat:@" where %@",where];
    }
    
    BOOL worked=[db executeUpdate:sql];
    [db close];
    
    return worked;
}

+(NSMutableArray *)getAllGoodsClass:(NSString *)where
{
    FMDatabase *db=[FMDatabase databaseWithPath:DATABASE_PATH];
    
    NSMutableArray *arr=[[NSMutableArray alloc] init];
    
    if (![db open]) {
        NSLog(@"打开数据库失败");
        return arr;
    }
    
    [self checkTableCreateInDb:db];
    
    NSMutableString *sql=[[NSMutableString alloc] initWithString:@"select * from goods_class"];
    if (where!=nil) {
        [sql appendFormat:@" where %@ order by class_sort",where];
    }
    else{
        [sql appendString:@" order by class_sort"];
    }
    
    FMResultSet *result=[db executeQuery:sql];
    GoodsClassInfoModel *model;
    while ([result next]) {
        model=[[GoodsClassInfoModel alloc] init];
        model.class_id=[result stringForColumn:@"class_id"];
        model.seller_id=[result stringForColumn:@"seller_id"];
        model.class_code=[result stringForColumn:@"class_code"];
        model.class_name=[result stringForColumn:@"class_name"];
        model.create_date=[result stringForColumn:@"create_date"];
        model.create_person=[result stringForColumn:@"create_person"];
        model.class_sort=[result stringForColumn:@"class_sort"];
        model.class_status=[result stringForColumn:@"class_status"];
        model.is_noodle=[result stringForColumn:@"is_noodle"];
        [arr addObject:model];
    }
    [db close];
    
    return arr;
}

+(BOOL)updateGoodsClassStatus:(NSString *)class_status class_id:(NSString *)class_id
{
    FMDatabase *db=[FMDatabase databaseWithPath:DATABASE_PATH];
    
    if (![db open]) {
        NSLog(@"打开数据库失败");
        return NO;
    }
    
    [self checkTableCreateInDb:db];
    
    NSString *sql=@"update goods_class set class_status=? where class_id=?";
    
    BOOL worked=[db executeUpdate:sql,class_status,class_id];
    [db close];
    
    return worked;
}

+(BOOL)updateGoodsClassSort:(NSString *)class_sort class_id:(NSString *)class_id
{
    FMDatabase *db=[FMDatabase databaseWithPath:DATABASE_PATH];
    
    if (![db open]) {
        NSLog(@"打开数据库失败");
        return NO;
    }
    
    [self checkTableCreateInDb:db];
    
    NSString *sql=@"update goods_class set class_sort=? where class_id=?";
    
    BOOL worked=[db executeUpdate:sql,class_sort,class_id];
    [db close];
    
    return worked;
}

+(BOOL)updateGoodsClassName:(NSString *)class_name class_id:(NSString *)class_id
{
    FMDatabase *db=[FMDatabase databaseWithPath:DATABASE_PATH];
    
    if (![db open]) {
        NSLog(@"打开数据库失败");
        return NO;
    }
    
    [self checkTableCreateInDb:db];
    
    NSString *sql=@"update goods_class set class_name=? where class_id=?";
    
    BOOL worked=[db executeUpdate:sql,class_name,class_id];
    [db close];
    
    return worked;
}

@end
