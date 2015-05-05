//
//  GoodsOptionsViewController.h
//  WirelessOrder
//
//  Created by eteng on 15/1/20.
//  Copyright (c) 2015年 etenginfo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsOptionsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
@private
    UITableView *_tableView;
    NSMutableArray *_goodsClassList;//数据源
}

@end
