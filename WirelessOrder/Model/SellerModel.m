//
//  SellerModel.m
//  WirelessOrder
//
//  Created by eteng on 14/12/22.
//  Copyright (c) 2014年 etenginfo. All rights reserved.
//

#import "SellerModel.h"
#import "FMDatabase.h"
#import "FMResultSet.h"

@implementation SellerModel

+(SellerModel *)SellerModelFromDictionary:(NSDictionary *)dic
{
    SellerModel *moele=[[SellerModel alloc] init];
    moele.seller_id=[dic objectForKey:@"sellerId"];
    moele.seller_name=[dic objectForKey:@"sellerName"];
    moele.link_tel=[dic objectForKey:@"linkTel"];
    moele.address=[dic objectForKey:@"address"];
    moele.seller_detail=[dic objectForKey:@"sellerDetail"];
    moele.seller_circle=[dic objectForKey:@"sellerCircle"];
    moele.seller_img=[dic objectForKey:@"sellerImg"];
    moele.seller_status=[dic objectForKey:@"sellerStatus"];
    moele.seller_weixin_id=[dic objectForKey:@"sellerWeixinId"];
    moele.create_time=[dic objectForKey:@"createTime"];
    moele.create_id=[dic objectForKey:@"createId"];
    moele.create_name=[dic objectForKey:@"createName"];
    moele.note=[dic objectForKey:@"note"];
    moele.sellerAacount=[dic objectForKey:@"sellerAacount"];
    moele.sellerPwd=[dic objectForKey:@"sellerPwd"];
    
    return moele;
}

+(BOOL)checkTableCreateInDb:(FMDatabase *)db
{
    NSString *sql=@"CREATE TABLE IF NOT EXISTS seller ('seller_id' text,'seller_name' text,'link_tel' text,'address' text,'seller_detail' text,'seller_circle' text,'seller_img' text,'seller_status' text,'seller_weixin_id' text,'create_time' text,'create_id' text,'create_name' text,'note' text,'sellerAacount' text,'sellerPwd' text)";
    BOOL worked=[db executeUpdate:sql];
    
    return worked;
}

+(BOOL)saveSeller:(SellerModel *)model
{
    FMDatabase *db=[FMDatabase databaseWithPath:DATABASE_PATH];
    
    if (![db open]) {
        NSLog(@"打开数据库失败");
        return NO;
    }
    
    [self checkTableCreateInDb:db];
    
    NSString *sql=@"insert or replace into seller ('seller_id' ,'seller_name' ,'link_tel' ,'address' ,'seller_detail' ,'seller_circle' ,'seller_img' ,'seller_status' ,'seller_weixin_id' ,'create_time' ,'create_id' ,'create_name' ,'note' ,'sellerAacount' ,'sellerPwd') values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    
    BOOL worked=[db executeUpdate:sql,model.seller_id,model.seller_name,model.link_tel,model.address,model.seller_detail,model.seller_circle,model.seller_img,model.seller_status,model.seller_weixin_id,model.create_time,model.create_id,model.create_name,model.note,model.sellerAacount,model.sellerPwd];
    [db close];
    
    return worked;
}

+(BOOL)deleteSeller
{
    FMDatabase *db=[FMDatabase databaseWithPath:DATABASE_PATH];
    
    if (![db open]) {
        NSLog(@"打开数据库失败");
        return NO;
    }
    
    [self checkTableCreateInDb:db];
    
    NSString *sql=@"delete from seller";
    
    BOOL worked=[db executeUpdate:sql];
    [db close];
    
    return worked;
}

+(NSMutableArray *)getSeller
{
    FMDatabase *db=[FMDatabase databaseWithPath:DATABASE_PATH];
    
    NSMutableArray *arr=[[NSMutableArray alloc] init];
    
    if (![db open]) {
        NSLog(@"打开数据库失败");
        return arr;
    }
    
    [self checkTableCreateInDb:db];
    
    NSString *sql=@"select * from seller";
    FMResultSet *result=[db executeQuery:sql];
    SellerModel *model;
    while ([result next]) {
        model=[[SellerModel alloc] init];
        model.seller_id=[result stringForColumn:@"seller_id"];
        model.seller_name=[result stringForColumn:@"seller_name"];
        model.link_tel=[result stringForColumn:@"link_tel"];
        model.address=[result stringForColumn:@"address"];
        model.seller_detail=[result stringForColumn:@"seller_detail"];
        model.seller_circle=[result stringForColumn:@"seller_circle"];
        model.seller_img=[result stringForColumn:@"seller_img"];
        model.seller_status=[result stringForColumn:@"seller_status"];
        model.seller_weixin_id=[result stringForColumn:@"seller_weixin_id"];
        model.create_time=[result stringForColumn:@"create_time"];
        model.create_id=[result stringForColumn:@"create_id"];
        model.create_name=[result stringForColumn:@"create_name"];
        model.note=[result stringForColumn:@"note"];
        model.sellerAacount=[result stringForColumn:@"sellerAacount"];
        model.sellerPwd=[result stringForColumn:@"sellerPwd"];
        [arr addObject:model];
    }
    [db close];
    
    return arr;
}


@end
