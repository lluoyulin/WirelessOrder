//
//  BlueToothViewController.h
//  WirelessOrder
//
//  Created by eteng on 14/12/29.
//  Copyright (c) 2014年 etenginfo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTServer.h"
#import "MBProgressHUD.h"

@interface BlueToothViewController : UIViewController<BTServerDelegate,UITableViewDataSource,UITableViewDelegate>
{
@private
    BTServer *_defaultBTServer;
    UITableView *_printerTalbe;
    PeriperalInfo *_pi;
    NSTimer *_timer;
    MBProgressHUD *_hudProgress;//提示框
}

@end
