//
//  GoodsInfoModel.h
//  WirelessOrder
//
//  Created by eteng on 14/12/23.
//  Copyright (c) 2014年 etenginfo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsInfoModel : NSObject

@property (nonatomic,retain) NSString *goods_id;//产品id
@property (nonatomic,retain) NSString *goods_serial;//产品编号
@property (nonatomic,retain) NSString *goods_name;//产品名称
@property (nonatomic,retain) NSString *good_production;//产品介绍
@property (nonatomic,retain) NSString *goods_price;//产品价格
@property (nonatomic,retain) NSString *discount_price;//促销价
@property (nonatomic,retain) NSString *goods_number;//库存数量
@property (nonatomic,retain) NSString *goods_img_path;//商品图片路径
@property (nonatomic,retain) NSString *goods_type;//类型：1正品 2 附加 3赠品
@property (nonatomic,retain) NSString *goods_status;//商品状态：1上架  2下架
@property (nonatomic,retain) NSString *create_time;//创建时间
@property (nonatomic,retain) NSString *create_person;//创建人
@property (nonatomic,retain) NSString *goods_class;//产品分类id
@property (nonatomic,retain) NSString *goods_owner_id;//商户id
@property (nonatomic,retain) NSString *goods_sort;//产品排序

//字典转化为实体类
+(GoodsInfoModel *) GoodsModelFromDictionary:(NSDictionary *)dic;

//保存产品的基本信息
+(BOOL) saveGoods:(GoodsInfoModel *)model;

//删除全部产品
+(BOOL) deleteAllGoods:(NSString *)where;

//获取全部产品
+(NSMutableArray *) getAllGoods:(NSString *)where;

//修改产品类别状态
+(BOOL)updateGoodsStatus:(NSString *)goods_status goods_id:(NSString *)goods_id;

//修改产品类别顺序
+(BOOL)updateGoodsSort:(NSString *)goods_sort goods_id:(NSString *)goods_id;

@end
