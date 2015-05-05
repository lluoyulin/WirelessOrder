//
//  OrderDetailInfoModel.h
//  WirelessOrder
//
//  Created by eteng on 14/12/24.
//  Copyright (c) 2014年 etenginfo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderDetailInfoModel : NSObject

@property (nonatomic,retain) NSString *detail_id;//明细id
@property (nonatomic,retain) NSString *order_id;//关联主订单id
@property (nonatomic,retain) NSString *goods_id;//关联商品id
@property (nonatomic,retain) NSString *goods_name;//商品名
@property (nonatomic,retain) NSString *goods_single_price;//单价
@property (nonatomic,retain) NSString *goods_discount_price ;//优惠价
@property (nonatomic,retain) NSString *goods_number;//购买数量
@property (nonatomic,retain) NSString *goods_attach_name;//附加产品
@property (nonatomic,retain) NSString *goods_attach_price;//附加产品总价
@property (nonatomic,retain) NSString *ask_for;//特殊要求
@property (nonatomic,retain) NSString *total_price;//小计
@property (nonatomic,retain) NSString *create_time ;//创建时间
@property (nonatomic,retain) NSString *create_person ;//创建人

//字典转化为实体类
+(OrderDetailInfoModel *) OrderDetailInfoModelFromDictionary:(NSDictionary *)dic;

//保存产品订单明细表信息
+(BOOL) saveOrderDetail:(OrderDetailInfoModel *)model;

//删除产品订单明细表
+(BOOL) deleteAllOrderDetail:(NSString *)where;

//获取产品订单明细表
+(NSMutableArray *) getAllOrderDetail:(NSString *)where;

@end
