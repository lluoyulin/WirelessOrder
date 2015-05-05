//
//  MainViewController.m
//  WirelessOrder
//
//  Created by eteng on 14/12/12.
//  Copyright (c) 2014年 etenginfo. All rights reserved.
//

#import "MainViewController.h"
#import "PhoneOrderViewController.h"
#import "DayOrderViewController.h"
#import "HistoryOrderViewController.h"
#import "WeiXinOrderViewController.h"
#import "SwipeBackNavigationViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBar.hidden=YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _btnBG=@[@"phoneorder",@"weixinorder",@"dayorder",@"historyorder"];
    
    _btnBGSelect=@[@"phoneorder_select",@"weixinorder_select",@"dayorder_select",@"historyorder_select"];
    
    _btnName=@[@"电话订单",@"微信订单",@"已处理",@"历史订单"];
    
    [self initViewController];
    
    [self initCustomTabbar];
}

//初始化ViewController
-(void)initViewController{
        
    PhoneOrderViewController *phoneVC=[[PhoneOrderViewController alloc] init];
    
    WeiXinOrderViewController *weixinVC=[[WeiXinOrderViewController alloc] init];
    
    DayOrderViewController *dayVC=[[DayOrderViewController alloc] init];
    
    HistoryOrderViewController *historyVC=[[HistoryOrderViewController alloc] init];
    
    self.viewControllers=@[[[SwipeBackNavigationViewController alloc] initWithRootViewController:phoneVC],[[SwipeBackNavigationViewController alloc] initWithRootViewController:weixinVC],[[SwipeBackNavigationViewController alloc] initWithRootViewController:dayVC],[[SwipeBackNavigationViewController alloc] initWithRootViewController:historyVC]];
}

//初始化自定义tabbar
-(void)initCustomTabbar{
    
    UIImageView *tabbarBG=[[UIImageView alloc] initWithFrame:CGRectMake(0, ScreenHeight-49, ScreenWidth, 49)];
    tabbarBG.tag=99;
    [tabbarBG setImage:[UIImage imageNamed:@"tabbarbg"]];
    tabbarBG.userInteractionEnabled=YES;
    [self.view addSubview:tabbarBG];
    
    for (int index=0; index<4; index++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(tabbarBG.frame.size.width/4*index, 0, tabbarBG.frame.size.width/4, 49);
        btn.tag=index;
        [btn addTarget:self action:@selector(changeVC:) forControlEvents:UIControlEventTouchUpInside];
       
        UIImageView *image=[[UIImageView alloc] initWithFrame:CGRectMake((btn.frame.size.width-19)/2, 10, 18.75, 17.5)];
        image.tag=index*10+1;
        [image setImage:[UIImage imageNamed:_btnBG[index]]];
        [btn addSubview:image];
        
        
        UILabel *lbl=[[UILabel alloc] init];
        lbl.tag=index*10+2;
        lbl.text=_btnName[index];
        lbl.font=[UIFont systemFontOfSize:10.0];
        
        //自动调整高度
        NSDictionary *attributes = @{NSFontAttributeName:lbl.font};
        CGSize fontSize=[lbl.text boundingRectWithSize:CGSizeMake(btn.frame.size.width, btn.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        
        lbl.frame=CGRectMake((btn.frame.size.width-fontSize.width)/2, image.frame.size.height+10+5, fontSize.width, fontSize.height);
        [btn addSubview:lbl];
        
        [tabbarBG addSubview:btn];
        
        if (index==0) {
            [self changeVC:btn];
        }
    }
    
}

-(void)changeVC:(UIButton *)btn{
    self.selectedIndex=btn.tag;
    NSArray *arrayBtn=[[btn superview] subviews];
    for (int i=0; i<arrayBtn.count; i++) {
        UIImageView *image=(UIImageView *)[arrayBtn[i] viewWithTag:i*10+1];
        UILabel *lbl=(UILabel *)[arrayBtn[i] viewWithTag:i*10+2];
        
        if (btn.tag==i) {
            [image setImage:[UIImage imageNamed:_btnBGSelect[i]]];
            lbl.textColor=kUIColorFromRGB(0xdf2203);
        }
        else{
            [image setImage:[UIImage imageNamed:_btnBG[i]]];
            lbl.textColor=[UIColor blackColor];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [UserData setBool:YES forKey:@"islogin"];
    [UserData synchronize];
    
    if ([[UserData stringForKey:@"guidepage"] intValue]<1) {
        [UserData setObject:@"1" forKey:@"guidepage"];
        [UserData setBool:NO forKey:@"islogin"];
        [UserData synchronize];
        [self showIntroWithCrossDissolve];
    }
}

- (void)showIntroWithCrossDissolve {
    NSMutableArray *arr=[[NSMutableArray alloc] init];
    
    for (int i=0; i<5; i++) {
        EAIntroPage *page = [EAIntroPage page];
        page.bgImage = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i+1]];
        [arr addObject:page];
    }
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:arr];
    
    [intro setDelegate:self];
    [intro showInView:self.view animateDuration:0.0];
}

@end
