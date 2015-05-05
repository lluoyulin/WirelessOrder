//
//  CartAnimationView.h
//  WirelessOrder
//
//  Created by eteng on 15/2/2.
//  Copyright (c) 2015年 etenginfo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CartAnimationDelegate <NSObject>

-(void)addShoppingCartCount;

-(void)startCartAnimation;

@end

@interface CartAnimationView : UIView

@property(nonatomic,weak)id<CartAnimationDelegate> delegateAnimation;

@property(nonatomic,retain) UIImageView *image;

@end
