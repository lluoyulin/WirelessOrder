//
//  WeiXinOrderTableViewCell.h
//  WirelessOrder
//
//  Created by eteng on 15/1/4.
//  Copyright (c) 2015年 etenginfo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainOrderInfoModel.h"

@interface WeiXinOrderTableViewCell : UITableViewCell
{
@private
    UIImageView *_dotImage;//小点
    UIImageView *_bottomLineImage;//cell分割线
    UILabel *_phoneLbl;//电话
    UILabel *_addressLbl;//地址
}

@property(nonatomic,retain) MainOrderInfoModel *model;//订单信息

@end
