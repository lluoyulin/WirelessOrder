//
//  SellerOptionsInfoModel.h
//  WirelessOrder
//
//  Created by eteng on 14/12/24.
//  Copyright (c) 2014年 etenginfo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SellerOptionsInfoModel : NSObject

@property (nonatomic,retain) NSString *op_id;//id
@property (nonatomic,retain) NSString *seller_id;//商户id
@property (nonatomic,retain) NSString *option_name;//备注名称
@property (nonatomic,retain) NSString *option_status;//状态 1不显示 2显示
@property (nonatomic,retain) NSString *option_order;//选项顺序
@property (nonatomic,retain) NSString *class_id ;//菜品类型id

//字典转化为实体类
+(SellerOptionsInfoModel *) SellerOptionsInfoModelFromDictionary:(NSDictionary *)dic;

//保存商户菜品备注信息
+(BOOL) saveSellerOptions:(SellerOptionsInfoModel *)model;

//删除商户菜品备注
+(BOOL) deleteAllSellerOptions:(NSString *)where;

//获取商户菜品备注
+(NSMutableArray *) getAllSellerOptions:(NSString *)where;

@end
