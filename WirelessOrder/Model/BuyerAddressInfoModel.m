//
//  BuyerAddressInfoModel.m
//  WirelessOrder
//
//  Created by eteng on 14/12/24.
//  Copyright (c) 2014年 etenginfo. All rights reserved.
//

#import "BuyerAddressInfoModel.h"
#import "FMResultSet.h"
#import "FMDatabase.h"

@implementation BuyerAddressInfoModel

+(BuyerAddressInfoModel *)BuyerAddressInfoModelFromDictionary:(NSDictionary *)dic
{
    BuyerAddressInfoModel *model=[[BuyerAddressInfoModel alloc] init];
    model.address_id=[dic objectForKey:@"addressId"];
    model.buyer_id=[dic objectForKey:@"buyerId"];
    model.buyer_name=[dic objectForKey:@"buyerName"];
    model.buyer_tel=[dic objectForKey:@"buyerTel"];
    model.detail_address=[dic objectForKey:@"detailAddress"];
    model.add_status=[dic objectForKey:@"addStatus"];
    model.create_person=[dic objectForKey:@"createPerson"];
    model.create_date=[dic objectForKey:@"createDate"];
    
    return model;
}

+(BOOL)checkTableCreateInDb:(FMDatabase *)db
{
    NSString *sql=@"CREATE TABLE IF NOT EXISTS buyer_address ('address_id' text,'buyer_id' text,'buyer_name' text,'buyer_tel' text,'detail_address' text,'add_status' text,'create_person' text,'create_date' text)";
    BOOL worked=[db executeUpdate:sql];
    
    return worked;
}

+(BOOL)saveBuyerAddress:(BuyerAddressInfoModel *)model
{
    FMDatabase *db=[FMDatabase databaseWithPath:DATABASE_PATH];
    
    if (![db open]) {
        NSLog(@"打开数据库失败");
        return NO;
    }
    
    [self checkTableCreateInDb:db];
    
    NSString *sql=@"insert or replace into buyer_address ('address_id' ,'buyer_id' ,'buyer_name' ,'buyer_tel' ,'detail_address' ,'add_status' ,'create_person' ,'create_date') values(?,?,?,?,?,?,?,?)";
    
    BOOL worked=[db executeUpdate:sql,model.address_id,model.buyer_id,model.buyer_name,model.buyer_tel,model.detail_address,model.add_status,model.create_person,model.create_date];
    [db close];
    
    return worked;
}

+(BOOL)deleteAllBuyerAddress:(NSString *)where
{
    FMDatabase *db=[FMDatabase databaseWithPath:DATABASE_PATH];
    
    if (![db open]) {
        NSLog(@"打开数据库失败");
        return NO;
    }
    
    [self checkTableCreateInDb:db];
    
    NSMutableString *sql=[[NSMutableString alloc] initWithString:@"delete from buyer_address"];
    if (where!=nil) {
        [sql appendFormat:@" where %@",where];
    }
    
    BOOL worked=[db executeUpdate:sql];
    [db close];
    
    return worked;
}

+(NSMutableArray *)getAllBuyerAddress:(NSString *)where
{
    FMDatabase *db=[FMDatabase databaseWithPath:DATABASE_PATH];
    
    NSMutableArray *arr=[[NSMutableArray alloc] init];
    
    if (![db open]) {
        NSLog(@"打开数据库失败");
        return arr;
    }
    
    [self checkTableCreateInDb:db];
    
    NSMutableString *sql=[[NSMutableString alloc] initWithString:@"select * from buyer_address"];
    if (where!=nil) {
        [sql appendFormat:@" where %@ order by create_date desc",where];
    }
    else{
        [sql appendString:@" order by create_date desc"];
    }
    
    FMResultSet *result=[db executeQuery:sql];
    BuyerAddressInfoModel *model;
    while ([result next]) {
        model=[[BuyerAddressInfoModel alloc] init];
        model.address_id=[result stringForColumn:@"address_id"];
        model.buyer_id=[result stringForColumn:@"buyer_id"];
        model.buyer_name=[result stringForColumn:@"buyer_name"];
        model.buyer_tel=[result stringForColumn:@"buyer_tel"];
        model.detail_address=[result stringForColumn:@"detail_address"];
        model.add_status=[result stringForColumn:@"add_status"];
        model.create_person=[result stringForColumn:@"create_person"];
        model.create_date=[result stringForColumn:@"create_date"];
        [arr addObject:model];
    }
    [db close];
    
    return arr;
}


@end
