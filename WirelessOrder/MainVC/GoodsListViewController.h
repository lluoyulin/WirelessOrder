//
//  GoodsListViewController.h
//  WirelessOrder
//
//  Created by eteng on 15/1/16.
//  Copyright (c) 2015年 etenginfo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "KeyboardToolBar.h"

@interface GoodsListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,KeyboardDelegate>
{
@private
    UITableView *_tableView;
    NSMutableArray *_goodsList;//数据源
    MBProgressHUD *_hudShowMsg;//提示语
    MBProgressHUD *_hudProgress;//进度提示语
}

@property(nonatomic,retain) NSString *goodsclassid;

@end
