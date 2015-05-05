//
//  GoodsClassInfoModel.h
//  WirelessOrder
//
//  Created by eteng on 14/12/23.
//  Copyright (c) 2014年 etenginfo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsClassInfoModel : NSObject

@property (nonatomic,retain) NSString *class_id;//分类ID
@property (nonatomic,retain) NSString *seller_id;//商户ID
@property (nonatomic,retain) NSString *class_code;//分类代码
@property (nonatomic,retain) NSString *class_name;//分类名称
@property (nonatomic,retain) NSString *create_date;//创建日期
@property (nonatomic,retain) NSString *create_person;//创建人
@property (nonatomic,retain) NSString *class_sort;//产品类型排序
@property (nonatomic,retain) NSString *class_status;//产品类型状态：1上架  0下架
@property (nonatomic,retain) NSString *is_noodle;//是否粉面：0 不是 1是 

//字典转化为实体类
+(GoodsClassInfoModel *) GoodsClassModelFromDictionary:(NSDictionary *)dic;

//保存产品类别信息
+(BOOL) saveGoodsClass:(GoodsClassInfoModel *)model;

//删除全部产品类别
+(BOOL) deleteAllGoodsClass:(NSString *) where;

//获取全部产品类别
+(NSMutableArray *) getAllGoodsClass:(NSString *) where;

//修改产品类别状态
+(BOOL)updateGoodsClassStatus:(NSString *)class_status class_id:(NSString *)class_id;

//修改产品类别顺序
+(BOOL)updateGoodsClassSort:(NSString *)class_sort class_id:(NSString *)class_id;

//修改产品类型的名字
+(BOOL)updateGoodsClassName:(NSString *)class_name class_id:(NSString *)class_id;

@end
