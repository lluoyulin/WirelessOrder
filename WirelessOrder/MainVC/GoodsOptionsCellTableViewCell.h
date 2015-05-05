//
//  GoodsOptionsCellTableViewCell.h
//  WirelessOrder
//
//  Created by eteng on 15/1/20.
//  Copyright (c) 2015年 etenginfo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsClassInfoModel.h"
#import "MBProgressHUD.h"
#import "KeyboardToolBar.h"

@interface GoodsOptionsCellTableViewCell : UITableViewCell<UITextFieldDelegate,KeyboardDelegate>
{
@private
    UIImageView *_bottomLineImage;//单元格线
    UILabel *_goodsClassLbl;//类别名称
    UIButton *_options1;//备注1
    UIButton *_options2;//备注2
    UIButton *_options3;//备注3
    UIButton *_options4;//备注4
    UIButton *_options5;//备注5
    UIButton *_options6;//备注6
    NSMutableArray *_optionsList;//备注数据源
    
    MBProgressHUD *_hudShowMsg;//提示语
    MBProgressHUD *_hudProgress;//进度提示语
    
    NSString *_opid;//备注id
}

@property(nonatomic,retain) GoodsClassInfoModel *goodsClassModel;

@end
