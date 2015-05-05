//
//  BuyerInfoCellTableViewCell.h
//  WirelessOrder
//
//  Created by eteng on 15/1/14.
//  Copyright (c) 2015年 etenginfo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BuyerInfoModel.h"

@interface BuyerInfoCellTableViewCell : UITableViewCell
{
@private
    UILabel *_telLbl;
    UILabel *_tel;//电话
    UILabel *_addressLbl;
    UILabel *_address;//地址
    UILabel *_totalNumberLbl;
    UILabel *_totalNumber;//总订单数
    UILabel *_totalMoneyLbl;
    UILabel *_totalMoney;//订单总价
    UIImageView *_cellLineImage1;
    UIImageView *_cellLineImage2;
}

@property(nonatomic,retain) BuyerInfoModel *model;

@end
