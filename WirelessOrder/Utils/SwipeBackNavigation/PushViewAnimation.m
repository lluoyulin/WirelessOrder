//
//  PushViewAnimation.m
//  WirelessOrder
//
//  Created by eteng on 15/2/26.
//  Copyright (c) 2015年 etenginfo. All rights reserved.
//

#import "PushViewAnimation.h"

@implementation PushViewAnimation

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.6;
}
// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    // 可以看做为destination ViewController
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    // 添加toView到容器上
    // 如果是XCode6 就可以用这段
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        // iOS8 SDK 新API
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        [[transitionContext containerView] addSubview:toView];
    }else{
        // 添加toView到容器上
        [[transitionContext containerView] addSubview:toViewController.view];
    }
    
    toViewController.view.frame=CGRectMake(-320, toViewController.view.frame.origin.y, toViewController.view.frame.size.width, toViewController.view.frame.size.height);
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        toViewController.view.frame=CGRectMake(0, toViewController.view.frame.origin.y, toViewController.view.frame.size.width, toViewController.view.frame.size.height);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

@end
