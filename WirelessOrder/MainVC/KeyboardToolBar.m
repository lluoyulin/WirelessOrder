//
//  KeyboardToolBar.m
//  WirelessOrder
//
//  Created by eteng on 15/1/23.
//  Copyright (c) 2015年 etenginfo. All rights reserved.
//

#import "KeyboardToolBar.h"

@implementation KeyboardToolBar

-(instancetype)init
{
   self=[super init];
    if (self) {
        self.frame=CGRectMake(0, 0, ScreenWidth, 30);
        [self setBarStyle:UIBarStyleDefault];
        UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboards)];
        NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButton,nil];
        [self setItems:buttonsArray];
    }
    
    return self;
}

-(void)resignKeyboards
{
    [self.delegateKeyboard resignKeyboard];
}

@end
