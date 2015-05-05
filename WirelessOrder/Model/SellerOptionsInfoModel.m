//
//  SellerOptionsInfoModel.m
//  WirelessOrder
//
//  Created by eteng on 14/12/24.
//  Copyright (c) 2014年 etenginfo. All rights reserved.
//

#import "SellerOptionsInfoModel.h"
#import "FMDatabase.h"
#import "FMResultSet.h"

@implementation SellerOptionsInfoModel

+(SellerOptionsInfoModel *)SellerOptionsInfoModelFromDictionary:(NSDictionary *)dic
{
    SellerOptionsInfoModel *model=[[SellerOptionsInfoModel alloc] init];
    model.op_id=[dic objectForKey:@"id"];
    model.seller_id=[dic objectForKey:@"sellerId"];
    model.option_name=[dic objectForKey:@"optionName"];
    model.option_status=[dic objectForKey:@"optionStatus"];
    model.option_order=[dic objectForKey:@"optionOrder"];
    model.class_id=[dic objectForKey:@"classId"];
    
    return model;
}

+(BOOL)checkTableCreateInDb:(FMDatabase *)db
{
    NSString *sql=@"CREATE TABLE IF NOT EXISTS seller_options ('op_id' text,'seller_id' text,'option_name' text,'option_status' text,'option_order' text,'class_id' text)";
    BOOL worked=[db executeUpdate:sql];
    
    return worked;
}

+(BOOL)saveSellerOptions:(SellerOptionsInfoModel *)model
{
    FMDatabase *db=[FMDatabase databaseWithPath:DATABASE_PATH];
    
    if (![db open]) {
        NSLog(@"打开数据库失败");
        return NO;
    }
    
    [self checkTableCreateInDb:db];
    
    NSString *sql=@"insert or replace into seller_options ('op_id' ,'seller_id' ,'option_name' ,'option_status' ,'option_order' ,'class_id') values(?,?,?,?,?,?)";
    
    BOOL worked=[db executeUpdate:sql,model.op_id,model.seller_id,model.option_name,model.option_status,model.option_order,model.class_id];
    [db close];
    
    return worked;
}

+(BOOL)deleteAllSellerOptions:(NSString *)where
{
    FMDatabase *db=[FMDatabase databaseWithPath:DATABASE_PATH];
    
    if (![db open]) {
        NSLog(@"打开数据库失败");
        return NO;
    }
    
    [self checkTableCreateInDb:db];
    
    NSMutableString *sql=[[NSMutableString alloc] initWithString:@"delete from seller_options"];
    if (where!=nil) {
        [sql appendFormat:@" where %@",where];
    }
    
    BOOL worked=[db executeUpdate:sql];
    [db close];
    
    return worked;
}

+(NSMutableArray *)getAllSellerOptions:(NSString *)where
{
    FMDatabase *db=[FMDatabase databaseWithPath:DATABASE_PATH];
    
    NSMutableArray *arr=[[NSMutableArray alloc] init];
    
    if (![db open]) {
        NSLog(@"打开数据库失败");
        return arr;
    }
    
    [self checkTableCreateInDb:db];
    
    NSMutableString *sql=[[NSMutableString alloc] initWithString:@"select * from seller_options"];
    if (where!=nil) {
        [sql appendFormat:@" where %@ order by option_order",where];
    }
    else{
        [sql appendString:@" order by option_order"];
    }
    
    FMResultSet *result=[db executeQuery:sql];
    SellerOptionsInfoModel *model;
    while ([result next]) {
        model=[[SellerOptionsInfoModel alloc] init];
        model.op_id=[result stringForColumn:@"op_id"];
        model.seller_id=[result stringForColumn:@"seller_id"];
        model.option_name=[result stringForColumn:@"option_name"];
        model.option_status=[result stringForColumn:@"option_status"];
        model.option_order=[result stringForColumn:@"option_order"];
        model.class_id=[result stringForColumn:@"class_id"];
        [arr addObject:model];
    }
    [db close];
    
    return arr;
}


@end
