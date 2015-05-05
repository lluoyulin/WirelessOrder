//
//  MainOrderInfoModel.h
//  WirelessOrder
//
//  Created by eteng on 14/12/24.
//  Copyright (c) 2014年 etenginfo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainOrderInfoModel : NSObject

@property (nonatomic,retain) NSString *order_id;//订单id
@property (nonatomic,retain) NSString *order_sn;//订单编号
@property (nonatomic,retain) NSString *seller_user_id;//卖家id
@property (nonatomic,retain) NSString *buyer_user_id;//买家id
@property (nonatomic,retain) NSString *total_pay;//实际总价
@property (nonatomic,retain) NSString *should_pay ;//应付总价
@property (nonatomic,retain) NSString *order_source;//订单来源 1电话订单 2微信订单
@property (nonatomic,retain) NSString *order_status;//订单状态 1已完成 2未完成
@property (nonatomic,retain) NSString *create_time;//下单时间
@property (nonatomic,retain) NSString *create_person;//下单者
@property (nonatomic,retain) NSString *besure_time;//订单确认时间
@property (nonatomic,retain) NSString *besure_person;//确认人
@property (nonatomic,retain) NSString *address_id;//买家地址id
@property (nonatomic,retain) NSString *order_tel;//买家电话
@property (nonatomic,retain) NSString *order_address;//买家地址


//字典转化为实体类
+(MainOrderInfoModel *) MainOrderInfoModelFromDictionary:(NSDictionary *)dic;

//保存产品订单表信息
+(BOOL) saveMainOrder:(MainOrderInfoModel *)model;

//删除产品订单表
+(BOOL) deleteAllMainOrder:(NSString *)where;

//获取产品订单表
+(NSMutableArray *) getAllMainOrder:(NSString *)where;

//修改订单状态
+(BOOL)updateMainOrderStatus:(NSString *)orderid OrderStatus:(NSString *) status;

@end
