//
//  CartAnimationView.m
//  WirelessOrder
//
//  Created by eteng on 15/2/2.
//  Copyright (c) 2015年 etenginfo. All rights reserved.
//

#import "CartAnimationView.h"
#import <QuartzCore/QuartzCore.h>

@implementation CartAnimationView

//-(instancetype)initWithFrame:(CGRect)frame
//{
//    self=[super initWithFrame:frame];
//    if (self) {
//        self.image=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 31.8, 20.5)];
//        [self.image setImage:ImageNamed(@"cpdefult")];
//        [self addSubview:self.image];
//    }
//    return self;
//}

-(instancetype)init
{
    self=[super init];
    if (self) {
        self.image=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 31.8, 20.5)];
        [self.image setImage:ImageNamed(@"cpdefult")];
        [self addSubview:self.image];
        
        CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        pathAnimation.calculationMode = kCAAnimationPaced;
        pathAnimation.fillMode = kCAFillModeForwards;
        pathAnimation.removedOnCompletion = NO;
        pathAnimation.duration = 0.8;
        pathAnimation.repeatCount = 1000;
        pathAnimation.delegate=self;
        
        CGMutablePathRef curvedPath = CGPathCreateMutable();
        CGPathMoveToPoint(curvedPath, NULL, (ScreenWidth-120)/2+60, ScreenHeight-35);
        CGPathAddQuadCurveToPoint(curvedPath, NULL, (ScreenWidth-120)/2+60, 250, 40, 38);
        
        pathAnimation.path = curvedPath;
        CGPathRelease(curvedPath);
        
        [self.image.layer addAnimation:pathAnimation forKey:@"moveTheSquare"];
    }
    return self;

}

//- (void)drawRect:(CGRect)rect {
////    CGContextRef ctx=UIGraphicsGetCurrentContext();
////    
////    CGContextSetStrokeColorWithColor(ctx,[UIColor redColor].CGColor);
////    
////    CGContextSetLineWidth(ctx, 2);
////    
////    CGContextMoveToPoint(ctx, 50, 20);
////    
//////    CGContextAddLineToPoint(ctx, 150, 50);
//////    
//////    CGContextAddRect(ctx, CGRectMake(10, 10, 80, 50));
////    
////    CGContextAddCurveToPoint(ctx, 10, 10, 200, 400, 0, 0);
////    
////    CGContextDrawPath(ctx, kCGPathStroke);
//    
//    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//    pathAnimation.calculationMode = kCAAnimationPaced;
//    pathAnimation.fillMode = kCAFillModeForwards;
//    pathAnimation.removedOnCompletion = NO;
//    pathAnimation.duration = 0.8;
//    pathAnimation.repeatCount = 1000;
//    pathAnimation.delegate=self;
//    
//    CGMutablePathRef curvedPath = CGPathCreateMutable();
//    CGPathMoveToPoint(curvedPath, NULL, (ScreenWidth-120)/2+60, ScreenHeight-35);
//    CGPathAddQuadCurveToPoint(curvedPath, NULL, (ScreenWidth-120)/2+60, 250, 40, 38);
//    
//    pathAnimation.path = curvedPath;
//    CGPathRelease(curvedPath);
//    
//    [self.image.layer addAnimation:pathAnimation forKey:@"moveTheSquare"];
//}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSLog(@"完成");
}

@end
