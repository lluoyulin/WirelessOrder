//
//  SettingViewController.h
//  WirelessOrder
//
//  Created by eteng on 15/1/14.
//  Copyright (c) 2015年 etenginfo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface SettingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
@private
    UITableView *_tableView;
    MBProgressHUD *_hudShowMsg;//提示语
    MBProgressHUD *_hudProgress;//进度提示语
}
@end
