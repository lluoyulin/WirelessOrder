//
//  MainOrderInfoModel.m
//  WirelessOrder
//
//  Created by eteng on 14/12/24.
//  Copyright (c) 2014年 etenginfo. All rights reserved.
//

#import "MainOrderInfoModel.h"
#import "FMResultSet.h"
#import "FMDatabase.h"

@implementation MainOrderInfoModel

+(MainOrderInfoModel *)MainOrderInfoModelFromDictionary:(NSDictionary *)dic
{
    MainOrderInfoModel *model=[[MainOrderInfoModel alloc] init];
    model.order_id=[dic objectForKey:@"orderId"];
    model.order_sn=[dic objectForKey:@"orderSn"];
    model.seller_user_id=[dic objectForKey:@"sellerUserId"];
    model.buyer_user_id=[dic objectForKey:@"buyerUserId"];
    model.total_pay=[dic objectForKey:@"totalPay"];
    model.should_pay=[dic objectForKey:@"shouldPay"];
    model.order_source=[dic objectForKey:@"orderSource"];
    model.order_status=[dic objectForKey:@"orderStatus"];
    model.create_time=[dic objectForKey:@"createTime"];
    model.create_person=[dic objectForKey:@"createPerson"];
    model.besure_time=[dic objectForKey:@"besureTime"];
    model.besure_person=[dic objectForKey:@"besurePerson"];
    model.address_id=[dic objectForKey:@"addressId"];
    model.order_tel=[dic objectForKey:@"orderTel"];
    model.order_address=[dic objectForKey:@"orderAddress"];
    
    return model;
}

+(BOOL)checkTableCreateInDb:(FMDatabase *)db
{
    NSString *sql=@"CREATE TABLE IF NOT EXISTS main_order ('order_id' text,'order_sn' text,'seller_user_id' text,'buyer_user_id' text,'total_pay' text,'should_pay' text,'order_source' text,'order_status' text,'create_time' text,'create_person' text,'besure_time' text,'besure_person' text,'address_id' text,'order_tel' text,'order_address' text)";
    BOOL worked=[db executeUpdate:sql];
    
    return worked;
}

+(BOOL)saveMainOrder:(MainOrderInfoModel *)model
{
    FMDatabase *db=[FMDatabase databaseWithPath:DATABASE_PATH];
    
    if (![db open]) {
        NSLog(@"打开数据库失败");
        return NO;
    }
    
    [self checkTableCreateInDb:db];
    
    NSString *sql=@"insert or replace into main_order ('order_id' ,'order_sn' ,'seller_user_id' ,'buyer_user_id' ,'total_pay' ,'should_pay' ,'order_source' ,'order_status' ,'create_time' ,'create_person' ,'besure_time' ,'besure_person' ,'address_id' ,'order_tel' ,'order_address' ) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    
    BOOL worked=[db executeUpdate:sql,model.order_id,model.order_sn,model.seller_user_id,model.buyer_user_id,model.total_pay,model.should_pay,model.order_source,model.order_status,model.create_time,model.create_person,model.besure_time,model.besure_person,model.address_id,model.order_tel,model.order_address];
    [db close];
    
    return worked;
}

+(BOOL)deleteAllMainOrder:(NSString *)where
{
    FMDatabase *db=[FMDatabase databaseWithPath:DATABASE_PATH];
    
    if (![db open]) {
        NSLog(@"打开数据库失败");
        return NO;
    }
    
    [self checkTableCreateInDb:db];
    
    NSMutableString *sql=[[NSMutableString alloc] initWithString:@"delete from main_order"];
    if (where!=nil) {
        [sql appendFormat:@" where %@",where];
    }
    
    BOOL worked=[db executeUpdate:sql];
    [db close];
    
    return worked;
}

+(NSMutableArray *)getAllMainOrder:(NSString *)where
{
    FMDatabase *db=[FMDatabase databaseWithPath:DATABASE_PATH];
    
    NSMutableArray *arr=[[NSMutableArray alloc] init];
    
    if (![db open]) {
        NSLog(@"打开数据库失败");
        return arr;
    }
    
    [self checkTableCreateInDb:db];
    
    NSMutableString *sql=[[NSMutableString alloc] initWithString:@"select * from main_order"];
    if (where!=nil) {
        [sql appendFormat:@" where %@ order by create_time desc",where];
    }
    else{
        [sql appendString:@" order by create_time desc"];
    }
    
    FMResultSet *result=[db executeQuery:sql];
    MainOrderInfoModel *model;
    while ([result next]) {
        model=[[MainOrderInfoModel alloc] init];
        model.order_id=[result stringForColumn:@"order_id"];
        model.order_sn=[result stringForColumn:@"order_sn"];
        model.seller_user_id=[result stringForColumn:@"seller_user_id"];
        model.buyer_user_id=[result stringForColumn:@"buyer_user_id"];
        model.total_pay=[result stringForColumn:@"total_pay"];
        model.should_pay=[result stringForColumn:@"should_pay"];
        model.order_source=[result stringForColumn:@"order_source"];
        model.order_status=[result stringForColumn:@"order_status"];
        model.create_time=[result stringForColumn:@"create_time"];
        model.create_person=[result stringForColumn:@"create_person"];
        model.besure_time=[result stringForColumn:@"besure_time"];
        model.besure_person=[result stringForColumn:@"besure_person"];
        model.address_id=[result stringForColumn:@"address_id"];
        model.order_address=[result stringForColumn:@"order_address"];
        model.order_tel=[result stringForColumn:@"order_tel"];
        [arr addObject:model];
    }
    [db close];
    
    return arr;
}

+(BOOL)updateMainOrderStatus:(NSString *)orderid OrderStatus:(NSString *)status
{
    FMDatabase *db=[FMDatabase databaseWithPath:DATABASE_PATH];
    
    if (![db open]) {
        NSLog(@"打开数据库失败");
        return NO;
    }
    
    [self checkTableCreateInDb:db];
    
    NSString *sql=@"update main_order set order_status=? where order_id=?";
    
    BOOL worked=[db executeUpdate:sql,status,orderid];
    [db close];
    
    return worked;
}

@end
