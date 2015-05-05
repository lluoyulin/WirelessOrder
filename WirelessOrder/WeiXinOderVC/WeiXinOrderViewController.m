//
//  WeiXinOrderViewController.m
//  WirelessOrder
//
//  Created by eteng on 14/12/12.
//  Copyright (c) 2014年 etenginfo. All rights reserved.
//

#import "WeiXinOrderViewController.h"
#import "BlueToothViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "MainOrderInfoModel.h"
#import "WeiXinOrderTableViewCell.h"
#import "OrderDetailViewController.h"
#import "LoginViewController.h"
#import "SettingViewController.h"

@interface WeiXinOrderViewController ()

@end

@implementation WeiXinOrderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"微信订单";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化NavigationBar
    [self initNavigationBar];
    
    //初始化顶部视图
    [self initTopView];
    
    //初始化订单列表
    [self initOrderList];
    
    //初始化数据
    [self initData];
}

//初始化NavigationBar
-(void)initNavigationBar
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_bg"] forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor=kUIColorFromRGB(0xeaeaea);
    NSDictionary *dic=[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes=dic;
    
    UIButton *settingBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    settingBtn.frame=CGRectMake(0, (44-36)/2, 50.25, 36);
    [settingBtn setBackgroundImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    [settingBtn setBackgroundImage:[UIImage imageNamed:@"setting_select"] forState:UIControlStateHighlighted];
    [settingBtn addTarget:self action:@selector(pressSettingBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButton=[[UIBarButtonItem alloc] initWithCustomView:settingBtn];
    self.navigationItem.rightBarButtonItem=rightBarButton;
}

//设置
-(void)pressSettingBtn:(UIButton *)btn
{
    if (![self isLogin]) {
        self.tabarHiddien=YES;
        SettingViewController *vc=[[SettingViewController alloc] init];
        vc.title=@"设置";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//初始化数据
-(void)initData
{
    _orderList=[[NSMutableArray alloc] init];
    
    _progressHud=[[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_progressHud];
    _progressHud.labelText=@"正在获取数据...";
}

//初始化顶部视图
-(void)initTopView
{
    UIView *topView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    topView.tag=100;
    topView.backgroundColor=kUIColorFromRGB(0xeaeaea);
    [self.view addSubview:topView];
    
    UILabel *orderCountLbl=[[UILabel alloc] init];
    orderCountLbl.frame=CGRectMake(27, (topView.frame.size.height-40)/2, 45, 40);
    orderCountLbl.text=@"订单:";
    orderCountLbl.font=[UIFont systemFontOfSize:18.0];
    [topView addSubview:orderCountLbl];
    
    UILabel *orderCountTextLbl=[[UILabel alloc] init];
    orderCountTextLbl.tag=101;
    orderCountTextLbl.frame=CGRectMake(orderCountLbl.frame.origin.x+orderCountLbl.frame.size.width, orderCountLbl.frame.origin.y, 10, orderCountLbl.frame.size.height);
    orderCountTextLbl.text=@"0";
    orderCountTextLbl.font=[UIFont systemFontOfSize:18.0];
    orderCountTextLbl.textColor=[UIColor redColor];
    [topView addSubview:orderCountTextLbl];
    
    UILabel *orderCountUnitLbl=[[UILabel alloc] init];
    orderCountUnitLbl.tag=102;
    orderCountUnitLbl.frame=CGRectMake(orderCountTextLbl.frame.origin.x+orderCountTextLbl.frame.size.width, orderCountTextLbl.frame.origin.y, 20, orderCountTextLbl.frame.size.height);
    orderCountUnitLbl.text=@"单";
    orderCountUnitLbl.font=[UIFont systemFontOfSize:18.0];
    [topView addSubview:orderCountUnitLbl];
    
    UILabel *orderTotal=[[UILabel alloc] initWithFrame:CGRectMake(orderCountUnitLbl.frame.size.width+orderCountUnitLbl.frame.origin.x+40, (topView.frame.size.height-40)/2, 150, 40)];
    orderTotal.tag=103;
    orderTotal.text=@"金额: 0.00元";
    orderTotal.font=[UIFont systemFontOfSize:18.0];
    [topView addSubview:orderTotal];
    
    UIImageView *bottomLine=[[UIImageView alloc] initWithFrame:CGRectMake(0, 43, ScreenWidth, 1)];
    [bottomLine setImage:[UIImage imageNamed:@"remarkline"]];
    [topView addSubview:bottomLine];
}

//初始化订单列表
-(void)initOrderList
{
    [_tableView registerClass:[WeiXinOrderTableViewCell class] forCellReuseIdentifier:TableViewCellIdentifier];
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 44, ScreenWidth, ScreenHeight-44-49-44-18)];
    _tableView.backgroundColor=kUIColorFromRGB(0xffffff);
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

//加载订单数据
-(void)loadOrderData
{
    showNetLogoYES;
    AFHTTPRequestOperationManager *httpRequest=[AFHTTPRequestOperationManager manager];
    NSUserDefaults *userData=[NSUserDefaults standardUserDefaults];
    NSDictionary *parm=[[NSDictionary alloc] initWithObjectsAndKeys:[userData stringForKey:@"sellerId"],@"sellerId",@"2",@"queryType",@"0",@"page",@"0",@"pageCount",nil];
    [httpRequest GET:[HttpUrl stringByAppendingString:@"queryOrderBySellerId"] parameters:parm success:^(AFHTTPRequestOperation *operation,id responseObject){
        showNetLogoNO;
        [_progressHud hide:YES];
        
        NSDictionary *result=(NSDictionary *)responseObject;
        if ([[result objectForKey:@"code"] isEqualToString:@"0"]) {
            UIView *topView=(UIView *)[self.view viewWithTag:100];
            UILabel *orderCountTextLbl=(UILabel *)[topView viewWithTag:101];
            UILabel *orderCountUnitLbl=(UILabel *)[topView viewWithTag:102];
            UILabel *orderTotal=(UILabel *)[topView viewWithTag:103];
            
            orderCountTextLbl.text=[NSString stringWithFormat:@"%@",[result objectForKey:@"totalCount"]];
            
            //自动调整高度
            NSDictionary *attributes = @{NSFontAttributeName:orderCountTextLbl.font};
            
            CGSize lblFontSize=[orderCountTextLbl.text boundingRectWithSize:CGSizeMake(100,40) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
            
            orderCountTextLbl.frame=CGRectMake(orderCountTextLbl.frame.origin.x, orderCountTextLbl.frame.origin.y, lblFontSize.width, orderCountTextLbl.frame.size.height);
            
            orderCountUnitLbl.frame=CGRectMake(orderCountTextLbl.frame.origin.x+orderCountTextLbl.frame.size.width, orderCountTextLbl.frame.origin.y, 20, orderCountTextLbl.frame.size.height);
            
            orderTotal.frame=CGRectMake(orderCountUnitLbl.frame.size.width+orderCountUnitLbl.frame.origin.x+40, (topView.frame.size.height-40)/2, 150, 40);
            orderTotal.text=[NSString stringWithFormat:@"金额: %.2f元",[[result objectForKey:@"totalMoney"] floatValue]];
            
//            [MainOrderInfoModel deleteAllMainOrder:@"order_source='2'"];
            [_orderList removeAllObjects];
            NSArray *arr=[result objectForKey:@"orderList"];
            for (NSDictionary *dic in arr) {
                MainOrderInfoModel *model=[MainOrderInfoModel MainOrderInfoModelFromDictionary:dic];
//                [MainOrderInfoModel saveMainOrder:model];
                [_orderList addObject:model];
            }
            [_tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        showNetLogoNO;
        NSLog(@"失败：%@",error);
    }];
}

//是否需要登录
-(BOOL)isLogin
{
    NSUserDefaults *userData=[NSUserDefaults standardUserDefaults];
    if ([[userData stringForKey:@"sellerId"] isEqualToString:@""] || [userData stringForKey:@"sellerId"]==nil) {
        LoginViewController *loginView=[[LoginViewController alloc] init];
        [self.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:loginView] animated:YES completion:nil];
        return YES;
    }
    return NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    if (self.tabarHiddien) {
//        UIImageView *tarbar =(UIImageView *)[self.tabBarController.view viewWithTag:99];
//        tarbar.hidden=NO;
//        self.tabarHiddien=NO;
//    }
    
    if (![self isLogin]) {
        [_progressHud show:YES];
        
        //加载订单数据
        [self loadOrderData];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    if (self.tabarHiddien) {
//        UIImageView *tarbar =(UIImageView *)[self.tabBarController.view viewWithTag:99];
//        tarbar.hidden=YES;
//    }
}

#pragma tableview数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _orderList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeiXinOrderTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:TableViewCellIdentifier];
    
    if (cell==nil) {
        cell=[[WeiXinOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableViewCellIdentifier];
    }
    
    cell.model=_orderList[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainOrderInfoModel *model=_orderList[indexPath.row];
    OrderDetailViewController *vc=[[OrderDetailViewController alloc] init];
    vc.orderid=model.order_id;
    vc.issubmit=YES;
    
//    self.tabarHiddien=YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
