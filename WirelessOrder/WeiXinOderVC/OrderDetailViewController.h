//
//  OrderDetailViewController.h
//  WirelessOrder
//
//  Created by eteng on 15/1/4.
//  Copyright (c) 2015年 etenginfo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTServer.h"
#import "MBProgressHUD.h"

@interface OrderDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,BTServerDelegate>
{
@private
    UITableView *_orderTableView;
    NSMutableArray *_orderList;//订单数据
    float _orderSum;//订单总价
    BTServer *_defaultBTServer;//蓝牙服务
    PeriperalInfo *_periperal;//蓝牙设备
    NSTimer *_timer;
    MBProgressHUD *_hudProgress;//提示框
    MBProgressHUD *_progress;//进度条
    NSMutableString *_printString;//打印小票
}

@property(nonatomic,retain) NSString *orderid;//订单id
@property(nonatomic) BOOL issubmit;//是否提交服务器

@end
