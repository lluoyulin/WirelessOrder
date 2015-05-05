//
//  WeiXinOrderViewController.h
//  WirelessOrder
//
//  Created by eteng on 14/12/12.
//  Copyright (c) 2014年 etenginfo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface WeiXinOrderViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
@private
    UITableView *_tableView;
    NSMutableArray *_orderList;//订单数据
    MBProgressHUD *_progressHud;
}

@property(nonatomic,getter=isHidden) BOOL tabarHiddien;

@end
