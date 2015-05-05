//
//  PhoneOrderViewController.h
//  WirelessOrder
//
//  Created by eteng on 14/12/12.
//  Copyright (c) 2014年 etenginfo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTServer.h"
#import "MBProgressHUD.h"
#import "KeyboardToolBar.h"

@interface PhoneOrderViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,BTServerDelegate,KeyboardDelegate>
{
@private
    UITableView *_orderTableView;
    NSMutableArray *_orderList;//订单数据
    float _orderSum;//订单总价
    BTServer *_defaultBTServer;//蓝牙服务
    PeriperalInfo *_periperal;//蓝牙设备
    NSTimer *_timer;
    NSUserDefaults *_userData;//用户数据
    MBProgressHUD *_hudProgress;//提示框
    MBProgressHUD *_progress;//进度条
}

@property(nonatomic,getter=isHidden) BOOL tabarHiddien;

@end
