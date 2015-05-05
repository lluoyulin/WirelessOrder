//
//  BuyerInfoModel.m
//  WirelessOrder
//
//  Created by eteng on 15/1/14.
//  Copyright (c) 2015年 etenginfo. All rights reserved.
//

#import "BuyerInfoModel.h"
#import "FMDatabase.h"
#import "FMResultSet.h"

@implementation BuyerInfoModel

+(BuyerInfoModel *) BuyerInfoModelFromDictionary:(NSDictionary *)dic
{
    BuyerInfoModel *model=[[BuyerInfoModel alloc] init];
    model.tel=[dic objectForKey:@"tel"];
    model.address=[dic objectForKey:@"address"];
    model.totalMoney=[dic objectForKey:@"totalMoney"];
    model.totalNumber=[dic objectForKey:@"totalNumber"];
    
    return model;
}

+(BOOL)checkTableCreateInDb:(FMDatabase *)db
{
    NSString *sql=@"CREATE TABLE IF NOT EXISTS buyer_info ('tel' text,'address' text,'totalMoney' text,'totalNumber' text)";
    BOOL worked=[db executeUpdate:sql];
    
    return worked;
}

+(BOOL)saveBuyerInfo:(BuyerInfoModel *)model
{
    FMDatabase *db=[FMDatabase databaseWithPath:DATABASE_PATH];
    
    if (![db open]) {
        NSLog(@"打开数据库失败");
        return NO;
    }
    
    [self checkTableCreateInDb:db];
    
    NSString *sql=@"insert or replace into buyer_info ('tel','address','totalMoney','totalNumber') values(?,?,?,?)";
    
    BOOL worked=[db executeUpdate:sql,model.tel,model.address,model.totalMoney,model.totalNumber];
    [db close];
    
    return worked;
}

+(BOOL)deleteAllBuyerInfo:(NSString *)where
{
    FMDatabase *db=[FMDatabase databaseWithPath:DATABASE_PATH];
    
    if (![db open]) {
        NSLog(@"打开数据库失败");
        return NO;
    }
    
    [self checkTableCreateInDb:db];
    
    NSMutableString *sql=[[NSMutableString alloc] initWithString:@"delete from buyer_info"];
    if (where!=nil) {
        [sql appendFormat:@" where %@",where];
    }
    
    BOOL worked=[db executeUpdate:sql];
    [db close];
    
    return worked;
}

+(NSMutableArray *)getAllBuyerInfo:(NSString *)where
{
    FMDatabase *db=[FMDatabase databaseWithPath:DATABASE_PATH];
    
    NSMutableArray *arr=[[NSMutableArray alloc] init];
    
    if (![db open]) {
        NSLog(@"打开数据库失败");
        return arr;
    }
    
    [self checkTableCreateInDb:db];
    
    NSMutableString *sql=[[NSMutableString alloc] initWithString:@"select * from buyer_info"];
    if (where!=nil) {
        [sql appendFormat:@" where %@ order by totalNumber desc",where];
    }
    else{
        [sql appendString:@" order by totalNumber desc"];
    }
    
    FMResultSet *result=[db executeQuery:sql];
    BuyerInfoModel *model;
    while ([result next]) {
        model=[[BuyerInfoModel alloc] init];
        model.tel=[result stringForColumn:@"tel"];
        model.address=[result stringForColumn:@"address"];
        model.totalMoney=[result stringForColumn:@"totalMoney"];
        model.totalNumber=[result stringForColumn:@"totalNumber"];
        [arr addObject:model];
    }
    [db close];
    
    return arr;
}

//更新用户信息
+(BOOL) updateBuyerInfo:(BuyerInfoModel *)model
{
    NSArray *arrModel=[self getAllBuyerInfo:[NSString stringWithFormat:@"tel='%@'",model.tel]];
    if (arrModel.count>0) {
        BuyerInfoModel *temp=arrModel[0];
        model.totalMoney=[NSString stringWithFormat:@"%.2f",[temp.totalMoney floatValue]+[model.totalMoney floatValue]];
        model.totalNumber=[NSString stringWithFormat:@"%d",[temp.totalNumber intValue]+[model.totalNumber intValue]];
        
        FMDatabase *db=[FMDatabase databaseWithPath:DATABASE_PATH];
        
        if (![db open]) {
            NSLog(@"打开数据库失败");
            return NO;
        }
        
        [self checkTableCreateInDb:db];
        
        NSString *sql=@"update buyer_info set address=?,totalMoney=?,totalNumber=? where tel=?";
        
        BOOL worked=[db executeUpdate:sql,model.address,model.totalMoney,model.totalNumber,model.tel];
        [db close];
        
        return worked;
    }
    else{
        return [self saveBuyerInfo:model];
    }
}


@end
