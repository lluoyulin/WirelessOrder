//
//  SwipeBackNavigationViewController.m
//  WirelessOrder
//
//  Created by eteng on 15/2/26.
//  Copyright (c) 2015年 etenginfo. All rights reserved.
//

#import "SwipeBackNavigationViewController.h"
#import "PushViewAnimation.h"
#import "BackViewTransition.h"
#import "BackViewAnimation.h"

@interface SwipeBackNavigationViewController ()

@property(nonatomic,strong)PushViewAnimation *pushAnimation;
@property(nonatomic,strong)BackViewTransition *interactionController;
@property(nonatomic,strong)BackViewAnimation *backAnimation;
@property(nonatomic,strong)UIImageView *tarbar;

@end

@implementation SwipeBackNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate=self;
    self.pushAnimation=[PushViewAnimation new];
    self.interactionController=[BackViewTransition new];
    self.backAnimation=[BackViewAnimation new];
    self.interactionController.delegate=self;
}

//重写push
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count==1) {
        self.tarbar =(UIImageView *)[self.tabBarController.view viewWithTag:99];
        self.tarbar.hidden=YES;
    }
    [self.interactionController wireToViewController:viewController];
    
    [super pushViewController:viewController animated:animated];
}

//重写pop
-(UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    if (self.viewControllers.count==2) {
        self.tarbar.alpha=1;
        self.tarbar.hidden=NO;
    }
    
    return [super popViewControllerAnimated:animated];
}

#pragma BackViewTransition 委托
-(void)popSwipeBackControllerNavigation
{
    [self popViewControllerAnimated:YES];
}

-(void)moveTabBar:(CGFloat)translation moveState:(int)state
{
    switch (state) {
        case 1:
            self.tarbar.alpha=translation;
            break;
        case 2:
            self.tarbar.alpha=0;
            self.tarbar.hidden=YES;
            break;
        case 3:
            self.tarbar.alpha=1;
            break;
    }
}

#pragma UINavigationControllerDelegate 委托
//动画
- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPush) {
        return self.pushAnimation;
    }else if(operation == UINavigationControllerOperationPop){
        return self.backAnimation;
    }else{
        return nil;
    }
}

//交互
- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController
{
    if (self.interactionController.interacting) {
        self.tarbar.alpha=0;
        return self.interactionController;
    }
    else{
        return nil;
    }
}

@end
