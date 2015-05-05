//
//  GoodsCellTableViewCell.h
//  WirelessOrder
//
//  Created by eteng on 15/1/16.
//  Copyright (c) 2015年 etenginfo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsInfoModel.h"
#import "MBProgressHUD.h"

@interface GoodsCellTableViewCell : UITableViewCell
{
@private
    UIImageView *_goodsImage;//商品图片
    UIImageView *_cellLineImage;//单元格线
    UILabel *_goodsNameLbl;//商品名称
    UILabel *_goodsPriceLbl;//商品价格
    UIButton *_goodsUpBtn;//商品上架
    UIButton *_goodsDownBtn;//商品下架
    
    MBProgressHUD *_hudShowMsg;//提示语
    MBProgressHUD *_hudProgress;//进度提示语
}

@property(nonatomic,retain) GoodsInfoModel *model;

@end
