//
//  GoodsClassListViewController.h
//  WirelessOrder
//
//  Created by eteng on 15/1/15.
//  Copyright (c) 2015年 etenginfo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "KeyboardToolBar.h"

@interface GoodsClassListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,KeyboardDelegate>
{
@private
    UITableView *_tableView;
    NSMutableArray *_goodsClassList;//数据源
    MBProgressHUD *_hudShowMsg;//提示语
    MBProgressHUD *_hudProgress;//进度提示语
    BOOL _isShowPopView;//是否弹出添加菜品类目
}

@end
