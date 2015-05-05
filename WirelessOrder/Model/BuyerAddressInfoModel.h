//
//  BuyerAddressInfoModel.h
//  WirelessOrder
//
//  Created by eteng on 14/12/24.
//  Copyright (c) 2014年 etenginfo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuyerAddressInfoModel : NSObject

@property (nonatomic,retain) NSString *address_id;//地址id
@property (nonatomic,retain) NSString *buyer_id;//买家id
@property (nonatomic,retain) NSString *buyer_name;//买家姓名
@property (nonatomic,retain) NSString *buyer_tel;//买家联系方式
@property (nonatomic,retain) NSString *detail_address;//详细地址
@property (nonatomic,retain) NSString *add_status ;//地址状态：1显示 2不显示 3默认地址
@property (nonatomic,retain) NSString *create_person;//创建者
@property (nonatomic,retain) NSString *create_date;//创建时间

//字典转化为实体类
+(BuyerAddressInfoModel *) BuyerAddressInfoModelFromDictionary:(NSDictionary *)dic;

//保存用户地址
+(BOOL) saveBuyerAddress:(BuyerAddressInfoModel *)model;

//删除用户地址
+(BOOL) deleteAllBuyerAddress:(NSString *)where;

//获取用户地址
+(NSMutableArray *) getAllBuyerAddress:(NSString *)where;

@end
