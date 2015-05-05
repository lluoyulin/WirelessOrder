//
//  MainViewController.h
//  WirelessOrder
//
//  Created by eteng on 14/12/12.
//  Copyright (c) 2014年 etenginfo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EAIntroView.h"

@interface MainViewController : UITabBarController<EAIntroDelegate>
{
@private
    NSArray *_btnBG;
    NSArray *_btnBGSelect;
    NSArray *_btnName;
}
@end
