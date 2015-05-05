//
//  HistoryOrderViewController.m
//  WirelessOrder
//
//  Created by eteng on 14/12/12.
//  Copyright (c) 2014年 etenginfo. All rights reserved.
//

#import "HistoryOrderViewController.h"
#import "BlueToothViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "MainOrderInfoModel.h"
#import "WeiXinOrderTableViewCell.h"
#import "OrderDetailViewController.h"
#import "LoginViewController.h"
#import "SettingViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface HistoryOrderViewController ()

@end

@implementation HistoryOrderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"历史订单";
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
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    _beginDate=[formatter stringFromDate:[NSDate date]];
    _endDate=[formatter stringFromDate:[NSDate date]];
    
    _progressHud=[[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_progressHud];
    _progressHud.labelText=@"正在获取数据...";
}

//初始化顶部视图
-(void)initTopView
{
    UIView *topView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 88)];
    topView.tag=100;
    topView.backgroundColor=kUIColorFromRGB(0xeaeaea);
    [self.view addSubview:topView];
    
    UILabel *orderCountLbl=[[UILabel alloc] init];
    orderCountLbl.frame=CGRectMake(27, (topView.frame.size.height/2-40)/2, 45, 40);
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
    
    UILabel *orderTotal=[[UILabel alloc] initWithFrame:CGRectMake(orderCountUnitLbl.frame.size.width+orderCountUnitLbl.frame.origin.x+40, (topView.frame.size.height/2-40)/2, 150, 40)];
    orderTotal.tag=103;
    orderTotal.text=@"金额: 0.00元";
    orderTotal.font=[UIFont systemFontOfSize:18.0];
    [topView addSubview:orderTotal];
    
    UIImageView *bottomLine=[[UIImageView alloc] initWithFrame:CGRectMake(0, 43, ScreenWidth, 1)];
    [bottomLine setImage:[UIImage imageNamed:@"remarkline"]];
    [topView addSubview:bottomLine];
    
    UIView *serachView=[[UIView alloc] initWithFrame:CGRectMake(0, 44, topView.frame.size.width, 44)];
    serachView.backgroundColor=kUIColorFromRGB(0xffffff);
    [topView addSubview:serachView];
    
    UILabel *beginDateLbl=[[UILabel alloc] initWithFrame:CGRectMake(10,(topView.frame.size.height/2-40)/2, 40, 40)];
    beginDateLbl.text=@"开始:";
    beginDateLbl.font=[UIFont systemFontOfSize:16.0];
    [serachView addSubview:beginDateLbl];
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yy-MM-dd"];
    
    UIButton *beginDateBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    beginDateBtn.frame=CGRectMake(beginDateLbl.frame.origin.x+beginDateLbl.frame.size.width, (serachView.frame.size.height-28)/2, 80, 28);
    beginDateBtn.tag=105;
    [beginDateBtn setTitle:[formatter stringFromDate:[NSDate date]] forState:UIControlStateNormal];
    [beginDateBtn setBackgroundImage:[UIImage imageNamed:@"date_bg"] forState:UIControlStateNormal];
    [beginDateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [beginDateBtn addTarget:self action:@selector(pressDate:) forControlEvents:UIControlEventTouchUpInside];
    [serachView addSubview:beginDateBtn];
    
    UILabel *endDateLbl=[[UILabel alloc] initWithFrame:CGRectMake(beginDateBtn.frame.size.width+beginDateBtn.frame.origin.x+15, (topView.frame.size.height/2-40)/2, 40, 40)];
    endDateLbl.text=@"截止:";
    endDateLbl.font=[UIFont systemFontOfSize:16.0];
    [serachView addSubview:endDateLbl];
    
    UIButton *endDateBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    endDateBtn.frame=CGRectMake(endDateLbl.frame.origin.x+endDateLbl.frame.size.width, beginDateBtn.frame.origin.y, 80, 28);
    endDateBtn.tag=106;
    [endDateBtn setTitle:[formatter stringFromDate:[NSDate date]] forState:UIControlStateNormal];
    [endDateBtn setBackgroundImage:[UIImage imageNamed:@"date_bg"] forState:UIControlStateNormal];
    [endDateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [endDateBtn addTarget:self action:@selector(pressDate:) forControlEvents:UIControlEventTouchUpInside];
    [serachView addSubview:endDateBtn];
    
    UIButton *serachBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    serachBtn.frame=CGRectMake(endDateBtn.frame.origin.x+endDateBtn.frame.size.width+15, (serachView.frame.size.height-25.25)/2,27.125,25.25);
    [serachBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [serachBtn setImage:[UIImage imageNamed:@"search_select"] forState:UIControlStateHighlighted];
    [serachBtn addTarget:self action:@selector(pressSearch:) forControlEvents:UIControlEventTouchUpInside];
    [serachView addSubview:serachBtn];
    
    UIImageView *searchBottomLine=[[UIImageView alloc] initWithFrame:CGRectMake(0, 43, ScreenWidth, 1)];
    [searchBottomLine setImage:[UIImage imageNamed:@"remarkline"]];
    [serachView addSubview:searchBottomLine];
    
}

//搜索
-(void)pressSearch:(UIButton *)btn
{
    //加载订单数据
    [self loadOrderData];
}

//选择时间
-(void)pressDate:(UIButton *)btn
{
    UIView *popView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    popView.tag=110;
    popView.backgroundColor=[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"pop_bg"]];
    [self.view addSubview:popView];

    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yy-MM-dd"];
    
    UIDatePicker *dataPicker=[[UIDatePicker alloc] initWithFrame:CGRectMake(0, ScreenHeight-216-44-49-19, 0, 0)];
    dataPicker.backgroundColor=kUIColorFromRGB(0xffffff);
    dataPicker.tag=119;
    dataPicker.datePickerMode=UIDatePickerModeDate;
    [popView addSubview:dataPicker];

    UIView *btnView=[[UIView alloc] initWithFrame:CGRectMake(0,dataPicker.frame.origin.y-35, ScreenWidth, 40)];
    btnView.backgroundColor=kUIColorFromRGB(0xedecec);
    [popView addSubview:btnView];
    
    UIButton *submitBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    if (btn.tag==105) {//开始时间
        submitBtn.tag=115;
        dataPicker.date=[formatter dateFromString:_beginDate];
    }
    else{//截止时间
        submitBtn.tag=116;
        dataPicker.date=[formatter dateFromString:_endDate];
    }
    submitBtn.frame=CGRectMake(btnView.frame.size.width-60, (btnView.frame.size.height-30)/2, 50, 30);
    [submitBtn setTitle:@"完成" forState:UIControlStateNormal];
    [submitBtn setTitleColor:kUIColorFromRGB(0xf33637) forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitDate:) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:submitBtn];
    
    UIButton *cancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame=CGRectMake(10,(btnView.frame.size.height-30)/2, 50, 30);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:kUIColorFromRGB(0xf33637) forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelDate:) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:cancelBtn];
}

//取消时间
-(void)cancelDate:(UIButton *)btn
{
    UIView *popView=(UIView *)[self.view viewWithTag:110];
    [popView removeFromSuperview];
}

//确定时间
-(void)submitDate:(UIButton *)btn
{
    UIView *popView=(UIView *)[self.view viewWithTag:110];
    UIDatePicker *dataPicker=(UIDatePicker *)[popView viewWithTag:119];
    UIView *topView=(UIView *)[self.view viewWithTag:100];
    NSDateFormatter *formatterString=[[NSDateFormatter alloc] init];
    [formatterString setDateFormat:@"yyyy-MM-dd"];
    NSDateFormatter *formatterBtn=[[NSDateFormatter alloc] init];
    [formatterBtn setDateFormat:@"yy-MM-dd"];
    if (btn.tag==115) {
        UIButton *beginDateBtn=(UIButton *)[topView viewWithTag:105];
        _beginDate=[formatterString stringFromDate:dataPicker.date];
        [beginDateBtn setTitle:[formatterBtn stringFromDate:dataPicker.date] forState:UIControlStateNormal];
    }
    else{
        UIButton *endDateBtn=(UIButton *)[topView viewWithTag:106];
        _endDate=[formatterString stringFromDate:dataPicker.date];
        [endDateBtn setTitle:[formatterBtn stringFromDate:dataPicker.date] forState:UIControlStateNormal];
    }
    [popView removeFromSuperview];
}

//初始化订单列表
-(void)initOrderList
{
    [_tableView registerClass:[WeiXinOrderTableViewCell class] forCellReuseIdentifier:TableViewCellIdentifier];
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 88, ScreenWidth, ScreenHeight-44-49-44-18-44)];
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
    [_progressHud show:YES];
    AFHTTPRequestOperationManager *httpRequest=[AFHTTPRequestOperationManager manager];
    NSUserDefaults *userData=[NSUserDefaults standardUserDefaults];
    NSDictionary *parm=[[NSDictionary alloc] initWithObjectsAndKeys:[userData stringForKey:@"sellerId"],@"sellerId",@"1",@"queryType",@"0",@"page",@"0",@"pageCount",_beginDate,@"startDate",_endDate,@"endDate",nil];
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
            
            orderTotal.frame=CGRectMake(orderCountUnitLbl.frame.size.width+orderCountUnitLbl.frame.origin.x+40, (topView.frame.size.height/2-40)/2, 150, 40);
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
    
    [self isLogin];
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
    
//    self.tabarHiddien=YES;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
