//
//  LoginViewController.h
//  WirelessOrder
//
//  Created by eteng on 15/1/8.
//  Copyright (c) 2015年 etenginfo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface LoginViewController : UIViewController<UITextFieldDelegate>
{
@private
    MBProgressHUD *_progress;//提示框
    NSUserDefaults *_userData;//用户数据
}

@end
