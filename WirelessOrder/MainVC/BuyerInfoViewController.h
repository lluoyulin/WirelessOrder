//
//  BuyerInfoViewController.h
//  WirelessOrder
//
//  Created by eteng on 15/1/14.
//  Copyright (c) 2015年 etenginfo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuyerInfoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
@private
    UITableView *_tableView;
    NSMutableArray *_buyerInfoList;//数据源
}

@end
