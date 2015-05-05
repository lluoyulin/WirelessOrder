//
//  OrderListTableViewCell.h
//  WirelessOrder
//
//  Created by eteng on 14/12/26.
//  Copyright (c) 2014年 etenginfo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderDetailInfoModel;

@interface OrderListTableViewCell : UITableViewCell
{
@private
    UIImageView *_dotImage;//小点
    UIImageView *_bottomLineImage;//cell分割线
    UILabel *_orderLbl;//配菜
    UILabel *_orderTextLbl;//配菜文本
    UILabel *_sumLbl;//小计
    UILabel *_sumTextLbl;//小计文本
    UILabel *_remarkLbl;//备注
    UILabel *_remarkTextLbl;//备注文本
}

@property(nonatomic,retain) OrderDetailInfoModel *model;

@end
