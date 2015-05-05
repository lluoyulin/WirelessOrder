//  QCSlideViewController.m
//  QCSliderTableView
//
//  Created by “ 邵鹏 on 14-4-16.
//  Copyright (c) 2014年 Scasy. All rights reserved.
//

#import "QCSlideViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "QCListViewController.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>

#import "GoodsClassInfoModel.h"
#import "AFHTTPRequestOperationManager.h"

@interface QCSlideViewController ()

@end

@implementation QCSlideViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"电话点餐";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_bg"] forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor=kUIColorFromRGB(0xeaeaea);
    NSDictionary *dic=[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes=dic;
    
    [self initOrderNO];
    
    UIButton *btnBack=[UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame=CGRectMake(0, (44-36)/2, 50.25, 36);
    [btnBack setBackgroundImage:[UIImage imageNamed:@"backphoneorder"] forState:UIControlStateNormal];
    [btnBack setBackgroundImage:[UIImage imageNamed:@"backphoneorder_select"] forState:UIControlStateHighlighted];
    [btnBack addTarget:self action:@selector(pressBtnBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton=[[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem=leftBarButton;
    
    UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(btnBack.frame.size.width-30, 5, 30, 15)];
    lbl.tag=100;
    lbl.font=[UIFont systemFontOfSize:10.0];
//    lbl.text=[NSString stringWithFormat:@"%d",_goodsCount];
    lbl.textColor=[UIColor whiteColor];
    [btnBack addSubview:lbl];
    
    //自动调整高度
    NSDictionary *attributes = @{NSFontAttributeName:lbl.font};
    
    CGSize lblNameFontSize=[lbl.text boundingRectWithSize:CGSizeMake(btnBack.frame.size.width,btnBack.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    lbl.frame=CGRectMake(btnBack.frame.size.width-lblNameFontSize.width-5, 5, lblNameFontSize.width, 15);
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    //加载菜单类型
    [self loadItem];
    
    _slideSwitchView.tabItemNormalColor = [QCSlideSwitchView colorFromHexRGB:@"868686"];
    _slideSwitchView.tabItemSelectedColor = [QCSlideSwitchView colorFromHexRGB:@"bb0b15"];
    _slideSwitchView.shadowImage = [[UIImage imageNamed:@"red_line_and_shadow.png"]
                                    stretchableImageWithLeftCapWidth:59.0f topCapHeight:0.0f];
    
    
    _viewArray=[[NSMutableArray alloc] initWithCapacity:_goodsClassList.count];
    
    for (int i=0; i<_goodsClassList.count; i++) {
        GoodsClassInfoModel *model=_goodsClassList[i];
        ReservationViewController *vc=[[ReservationViewController alloc] init];
        vc.title=model.class_name;
        vc.GoodsClassId=model.class_id;
        vc.IsNoodle=model.is_noodle;
        vc.addCartdelegate=self;
        [_viewArray addObject:vc];
    }
    
    UIButton *rightSideButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightSideButton setImage:[UIImage imageNamed:@"icon_rightarrow.png"] forState:UIControlStateNormal];
    [rightSideButton setImage:[UIImage imageNamed:@"icon_rightarrow.png"]  forState:UIControlStateHighlighted];
    rightSideButton.frame = CGRectMake(0, 0, 20.0f, 44.0f);
    rightSideButton.userInteractionEnabled = NO;
    _slideSwitchView.rigthSideButton = rightSideButton;
    
    [_slideSwitchView buildUI];
}

//创建订单号
-(void)initOrderNO
{
    NSUserDefaults *userData=[NSUserDefaults standardUserDefaults];
    if ([[userData stringForKey:@"orderno"] isEqualToString:@""] || [userData stringForKey:@"orderno"]==nil) {
        NSDate *date=[NSDate date];
        NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMddHHMMssSSS"];
        
        [userData setObject:[formatter stringFromDate:date] forKey:@"orderno"];
        [userData synchronize];
    }
}

-(void)pressBtnBack:(UIButton *)btn
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

//加载菜单类型
-(void)loadItem
{
    _goodsClassList=[GoodsClassInfoModel getAllGoodsClass:@"class_status='1'"];
}

#pragma mark - 滑动tab视图代理方法


- (NSUInteger)numberOfTab:(QCSlideSwitchView *)view
{
    // you can set the best you can do it ;
    return _viewArray.count;
}

- (UIViewController *)slideSwitchView:(QCSlideSwitchView *)view viewOfTab:(NSUInteger)number
{
    return _viewArray[number];
}

- (void)slideSwitchView:(QCSlideSwitchView *)view panLeftEdge:(UIPanGestureRecognizer *)panParam
{
    QCViewController *drawerController = (QCViewController *)self.navigationController.mm_drawerController;
    [drawerController panGestureCallback:panParam];
}

//- (void)slideSwitchView:(QCSlideSwitchView *)view didselectTab:(NSUInteger)number
//{
//    QCListViewController *vc = _viewArray[number];
//    [vc viewDidCurrentView];
//}

#pragma mark - 内存报警

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
        NSLog(@"aaaa");
    }
}

-(void)AddCart:(NSString *)imagePath GoodsCount:(NSInteger)count
{
    UIImageView *image=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 31.8, 20.5)];
    image.layer.masksToBounds=YES;
    image.layer.cornerRadius=5.0;
    [image sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"cpdefult"]];
    [self.navigationController.view addSubview:image];
    
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.duration = 0.4;
    pathAnimation.repeatCount = 1;
    pathAnimation.delegate=[[ReservationViewController alloc] init];;
    
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGPathMoveToPoint(curvedPath, NULL, (ScreenWidth-120)/2+60, ScreenHeight-35);
    CGPathAddQuadCurveToPoint(curvedPath, NULL, (ScreenWidth-120)/2+60, 250, 40, 38);
    
    pathAnimation.path = curvedPath;
    CGPathRelease(curvedPath);
    
    [image.layer addAnimation:pathAnimation forKey:@"moveTheSquare"];
    
    UIBarButtonItem *barbtn=self.navigationItem.leftBarButtonItem;
    UIButton *btnBack=(UIButton *)barbtn.customView;
    
    btnBack.transform=CGAffineTransformMakeScale(2.0, 2.0);
    [UIView animateWithDuration:0.3 delay:0.4 options:UIViewAnimationOptionCurveLinear animations:^{
        btnBack.transform=CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        [image removeFromSuperview];
        
        _goodsCount+=count;
        
        UILabel *lbl=(UILabel *)[btnBack viewWithTag:100];
        lbl.text=[NSString stringWithFormat:@"%d",_goodsCount];
        
        //自动调整高度
        NSDictionary *attributes = @{NSFontAttributeName:lbl.font};
        
        CGSize lblNameFontSize=[lbl.text boundingRectWithSize:CGSizeMake(btnBack.frame.size.width,btnBack.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        
        lbl.frame=CGRectMake(btnBack.frame.size.width-lblNameFontSize.width-5, 5, lblNameFontSize.width, 15);
    }];
}

@end
