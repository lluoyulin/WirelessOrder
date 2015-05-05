//
//  BuyerInfoModel.h
//  WirelessOrder
//
//  Created by eteng on 15/1/14.
//  Copyright (c) 2015年 etenginfo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuyerInfoModel : NSObject

@property (nonatomic,retain) NSString *tel;//买家电话
@property (nonatomic,retain) NSString *address;//买家地址
@property (nonatomic,retain) NSString *totalNumber;//订单总笔数
@property (nonatomic,retain) NSString *totalMoney;//订单总价

//字典转化为实体类
+(BuyerInfoModel *) BuyerInfoModelFromDictionary:(NSDictionary *)dic;

//保存用户信息
+(BOOL) saveBuyerInfo:(BuyerInfoModel *)model;

//更新用户信息
+(BOOL) updateBuyerInfo:(BuyerInfoModel *)model;

//删除用户信息
+(BOOL) deleteAllBuyerInfo:(NSString *)where;

//获取用户信息
+(NSMutableArray *) getAllBuyerInfo:(NSString *)where;

@end
