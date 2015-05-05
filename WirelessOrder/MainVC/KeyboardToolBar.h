//
//  KeyboardToolBar.h
//  WirelessOrder
//
//  Created by eteng on 15/1/23.
//  Copyright (c) 2015年 etenginfo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KeyboardDelegate <NSObject>

-(void)resignKeyboard;

@end

@interface KeyboardToolBar : UIToolbar

@property(weak)id<KeyboardDelegate> delegateKeyboard;

@end
