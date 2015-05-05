//
//  MyInfoViewController.h
//  WirelessOrder
//
//  Created by eteng on 15/1/13.
//  Copyright (c) 2015年 etenginfo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "KeyboardToolBar.h"

@interface MyInfoViewController : UIViewController<UITextViewDelegate,KeyboardDelegate>
{
@private
    NSArray *_namelist;//名称
    NSArray *_imageList;//名称对应图片
    MBProgressHUD *_hudShowMsg;//提示语
    MBProgressHUD *_hudProgress;//进度提示语
    NSArray *_myInfoList;//卖家资料
}

@end
