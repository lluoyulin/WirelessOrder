//
//  SellerModel.h
//  WirelessOrder
//
//  Created by eteng on 14/12/22.
//  Copyright (c) 2014年 etenginfo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SellerModel : NSObject

@property (nonatomic,retain) NSString *seller_id;//商户id
@property (nonatomic,retain) NSString *seller_name;//商户名称
@property (nonatomic,retain) NSString *link_tel;//联系电话
@property (nonatomic,retain) NSString *address;//商户地址
@property (nonatomic,retain) NSString *seller_detail;//商户介绍
@property (nonatomic,retain) NSString *seller_circle;//商家配送范围
@property (nonatomic,retain) NSString *seller_img;//商户图片
@property (nonatomic,retain) NSString *seller_status;//状态 1启用 2禁用
@property (nonatomic,retain) NSString *seller_weixin_id;//商家微信id
@property (nonatomic,retain) NSString *create_time;//创建时间
@property (nonatomic,retain) NSString *create_id;//创建者id
@property (nonatomic,retain) NSString *create_name;//创建者姓名
@property (nonatomic,retain) NSString *note;//备注
@property (nonatomic,retain) NSString *sellerAacount;//账号
@property (nonatomic,retain) NSString *sellerPwd;//密码

//字典转化为实体类
+(SellerModel *) SellerModelFromDictionary:(NSDictionary *)dic;

//保存商户的基本信息
+(BOOL) saveSeller:(SellerModel *)model;

//删除商户信息
+(BOOL) deleteSeller;

//获取商户信息
+(NSMutableArray *) getSeller;

@end
