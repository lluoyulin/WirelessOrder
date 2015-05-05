//
//  AddGoodsViewController.h
//  WirelessOrder
//
//  Created by eteng on 15/1/16.
//  Copyright (c) 2015年 etenginfo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "KeyboardToolBar.h"

@interface AddGoodsViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,KeyboardDelegate>
{
@private
    UIImageView *_picImage;
    MBProgressHUD *_hudShowMsg;//提示语
    MBProgressHUD *_hudProgress;//进度提示语
    UIImagePickerController *_picker;
}

@property(nonatomic,retain) NSString *goodsclassid;

@end
