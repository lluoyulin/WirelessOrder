//
//  OrderDetailViewController.m
//  WirelessOrder
//
//  Created by eteng on 15/1/4.
//  Copyright (c) 2015年 etenginfo. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "ReservationViewController.h"
#import "OrderDetailInfoModel.h"
#import "OrderListTableViewCell.h"
#import "BlueToothViewController.h"
#import "MainOrderInfoModel.h"
#import "BuyerAddressInfoModel.h"
#import "AFHTTPRequestOperationManager.h"
#import "WeiXinOrderViewController.h"
#import "SettingViewController.h"

@interface OrderDetailViewController ()

@end

@implementation OrderDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"订单";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化NavigationBar
    [self initNavigationBar];
    
    //创建订单View
    [self initView];
    
    _defaultBTServer = [BTServer defaultBTServer];
    _defaultBTServer.delegate = (id)self;
    
    _hudProgress=[[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_hudProgress];
    
    _orderList=[[NSMutableArray alloc] init];
    
    [self getOrder:self.orderid];
}

//初始化NavigationBar
-(void)initNavigationBar
{
    self.view.backgroundColor=kUIColorFromRGB(0xeaeaea);
    
    UIButton *btnBack=[UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame=CGRectMake(0, (44-36)/2, 50.25, 36);
    [btnBack setBackgroundImage:[UIImage imageNamed:@"bluetooth_back"] forState:UIControlStateNormal];
    [btnBack setBackgroundImage:[UIImage imageNamed:@"bluetooth_back_select"] forState:UIControlStateHighlighted];
    [btnBack addTarget:self action:@selector(pressBtnBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton=[[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem=leftBarButton;
    
    UIButton *settingBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    settingBtn.frame=CGRectMake(0, (44-36)/2, 50.25, 36);
    [settingBtn setBackgroundImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    [settingBtn setBackgroundImage:[UIImage imageNamed:@"setting_select"] forState:UIControlStateHighlighted];
    [settingBtn addTarget:self action:@selector(pressSettingBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButton=[[UIBarButtonItem alloc] initWithCustomView:settingBtn];
    self.navigationItem.rightBarButtonItem=rightBarButton;
}

//创建订单View
-(void)initView
{
    UIView *userInfoView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 170)];//用户信息view
    [self.view addSubview:userInfoView];
    
    UIImageView *userPhoneView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, (userInfoView.frame.size.height-4.0)/4.0)];
    [userPhoneView setImage:[UIImage imageNamed:@"phone_user_bg"]];
    userPhoneView.userInteractionEnabled=YES;
    [userInfoView addSubview:userPhoneView];
    
    UIImageView *phoneView=[[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth*0.10, (userPhoneView.frame.size.height-15.625)/2.0, 15.625, 15.625)];
    [phoneView setImage:[UIImage imageNamed:@"phone_user_phone"]];
    [userPhoneView addSubview:phoneView];
    
    UILabel *phoneLbl=[[UILabel alloc] initWithFrame:CGRectMake(phoneView.frame.origin.x+phoneView.frame.size.width+5, phoneView.frame.origin.y, 40, phoneView.frame.size.height)];
    phoneLbl.text=@"电话";
    phoneLbl.textAlignment=NSTextAlignmentCenter;
    [userPhoneView addSubview:phoneLbl];
    
    UILabel *phoneText=[[UILabel alloc] initWithFrame:CGRectMake(phoneLbl.frame.origin.x+phoneLbl.frame.size.width+10, 0, ScreenWidth-(phoneLbl.frame.origin.x+phoneLbl.frame.size.width+10)-(ScreenWidth*0.10), userPhoneView.frame.size.height)];
    phoneText.tag=102;
    [userPhoneView addSubview:phoneText];
    
    
    
    UIImageView *userDateView=[[UIImageView alloc] initWithFrame:CGRectMake(0, userPhoneView.frame.size.height, ScreenWidth, (userInfoView.frame.size.height-4)/4.0)];
    [userDateView setImage:[UIImage imageNamed:@"phone_user_bg"]];
    userDateView.userInteractionEnabled=YES;
    [userInfoView addSubview:userDateView];
    
    UIImageView *dateView=[[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth*0.10, (userPhoneView.frame.size.height-15.625)/2.0, 15.625, 15.625)];
    [dateView setImage:[UIImage imageNamed:@"phone_user_time"]];
    [userDateView addSubview:dateView];
    
    UILabel *dateLbl=[[UILabel alloc] initWithFrame:CGRectMake(phoneView.frame.origin.x+phoneView.frame.size.width+5, phoneView.frame.origin.y, 40, phoneView.frame.size.height)];
    dateLbl.text=@"时间";
    dateLbl.textAlignment=NSTextAlignmentCenter;
    [userDateView addSubview:dateLbl];
    
    UILabel *oderDateLbl=[[UILabel alloc] initWithFrame:CGRectMake(phoneLbl.frame.origin.x+phoneLbl.frame.size.width+10, 0, ScreenWidth-(phoneLbl.frame.origin.x+phoneLbl.frame.size.width+10)-(ScreenWidth*0.10), userDateView.frame.size.height)];
    oderDateLbl.tag=104;
    [userDateView addSubview:oderDateLbl];
    
    
    
    
    UIImageView *userAddrView=[[UIImageView alloc] initWithFrame:CGRectMake(0, userPhoneView.frame.size.height+userDateView.frame.size.height, ScreenWidth, (userInfoView.frame.size.height-4)/4.0)];
    [userAddrView setImage:[UIImage imageNamed:@"phone_user_bg"]];
    userAddrView.userInteractionEnabled=YES;
    [userInfoView addSubview:userAddrView];
    
    UIImageView *AddrView=[[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth*0.10, (userPhoneView.frame.size.height-15.625)/2.0, 15.625, 15.625)];
    [AddrView setImage:[UIImage imageNamed:@"phone_user_address"]];
    [userAddrView addSubview:AddrView];
    
    UILabel *AddrLbl=[[UILabel alloc] initWithFrame:CGRectMake(phoneView.frame.origin.x+phoneView.frame.size.width+5, phoneView.frame.origin.y, 40, phoneView.frame.size.height)];
    AddrLbl.text=@"地址";
    AddrLbl.textAlignment=NSTextAlignmentCenter;
    [userAddrView addSubview:AddrLbl];
    
    UILabel *AddrText=[[UILabel alloc] initWithFrame:CGRectMake(phoneLbl.frame.origin.x+phoneLbl.frame.size.width+10, 0, ScreenWidth-(phoneLbl.frame.origin.x+phoneLbl.frame.size.width+10), userAddrView.frame.size.height)];
    AddrText.tag=103;
    [userAddrView addSubview:AddrText];
    
    
    
    
    UIView *addOrderView=[[UIView alloc] initWithFrame:CGRectMake(0, userAddrView.frame.size.height+userAddrView.frame.origin.y, ScreenWidth, (userInfoView.frame.size.height-4)/4.0)];
    addOrderView.backgroundColor=kUIColorFromRGB(0xeaeaea);
    [userInfoView addSubview:addOrderView];
    
    UIImageView *bottomLineImage=[[UIImageView alloc] initWithFrame:CGRectMake(10, addOrderView.frame.size.height-2, addOrderView.frame.size.width-20, 2)];
    [bottomLineImage setImage:[UIImage imageNamed:@"dottedline"]];
    [addOrderView addSubview:bottomLineImage];
    
    UIButton *addOrderBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    addOrderBtn.frame=CGRectMake(bottomLineImage.frame.origin.x+15, (addOrderView.frame.size.height-32.6)/2, 73.5, 32.6);
    [addOrderBtn setBackgroundImage:[UIImage imageNamed:@"phone_order_add"] forState:UIControlStateNormal];
//    [addOrderBtn setBackgroundImage:[UIImage imageNamed:@"phone_order_add_select"] forState:UIControlStateHighlighted];
    [addOrderBtn setTitle:@"配餐" forState:UIControlStateNormal];
    [addOrderBtn setTitleColor:kUIColorFromRGB(0xea3808) forState:UIControlStateNormal];
    addOrderBtn.contentEdgeInsets=UIEdgeInsetsMake(0, 25, 0, 0);
    [addOrderView addSubview:addOrderBtn];
    
    
    
    
    [_orderTableView registerClass:[OrderListTableViewCell class] forCellReuseIdentifier:TableViewCellIdentifier];
    _orderTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-44-20-40)];//用户订单信息
    _orderTableView.backgroundColor=kUIColorFromRGB(0xeaeaea);
    _orderTableView.tableHeaderView=userInfoView;
    _orderTableView.separatorStyle=UITableViewCellAccessoryNone;
    _orderTableView.dataSource=self;
    _orderTableView.delegate=self;
    [self.view addSubview:_orderTableView];
    
    
    
    UIView *orderSumView=[[UIView alloc] initWithFrame:CGRectMake(0, _orderTableView.frame.size.height, ScreenWidth, 40)];//用户订单总计
    orderSumView.backgroundColor=kUIColorFromRGB(0xeaeaea);
    [self.view addSubview:orderSumView];
    
    UILabel *lblSum=[[UILabel alloc] initWithFrame:CGRectMake(0, (40-35)/2, ScreenWidth/2, 35)];
    lblSum.tag=101;
    lblSum.text=@"合计 0 元";
    lblSum.textColor=kUIColorFromRGB(0xea3808);
    lblSum.font=[UIFont systemFontOfSize:16.0];
    lblSum.textAlignment=NSTextAlignmentCenter;
    [orderSumView addSubview:lblSum];
    
    UIButton *submitBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame=CGRectMake((ScreenWidth/2-100)/2+ScreenWidth/2, (40-30)/2, 100, 30);
    [submitBtn setTitle:@"确认" forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"btnbg"] forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"btnbg_select"] forState:UIControlStateHighlighted];
    [submitBtn addTarget:self action:@selector(print:) forControlEvents:UIControlEventTouchUpInside];
    
    [orderSumView addSubview:submitBtn];
}

//打印
-(void)print:(UIButton *)btn
{
    if (self.issubmit) {//提交服务器
        showNetLogoYES;
        _hudProgress.labelText=@"正在提交订单...";
        [_hudProgress show:YES];
        
        AFHTTPRequestOperationManager *httpRequest=[AFHTTPRequestOperationManager manager];
        NSDictionary *parm=[[NSDictionary alloc] initWithObjectsAndKeys:self.orderid,@"orderId",@"1",@"orderStatus",nil];
        [httpRequest GET:[HttpUrl stringByAppendingString:@"updateOrderStatus"] parameters:parm success:^(AFHTTPRequestOperation *operation,id responseObject){
            showNetLogoNO;
            [_hudProgress hide:YES];
            
            NSDictionary *result=(NSDictionary *)responseObject;
            if ([[result objectForKey:@"code"] isEqualToString:@"0"]) {
                [MainOrderInfoModel updateMainOrderStatus:self.orderid OrderStatus:@"1"];
                
                [self printOrder:YES];
            }
            else{
                [self alertMessage:@"提交订单失败"];
            }
        } failure:^(AFHTTPRequestOperation *operation,NSError *error){
            showNetLogoNO;
            [_hudProgress hide:YES];
            NSLog(@"失败：%@",error);
            
            [self alertMessage:@"提交订单失败"];
        }];
    }
    else{
        [self printOrder:NO];
    }
}

//打印订单
-(void)printOrder:(BOOL)bl
{ 
    //打印
    _defaultBTServer.printString=_printString;
    
    [_defaultBTServer stopScan:YES];
    
    NSUserDefaults *userData=[NSUserDefaults standardUserDefaults];
    
    if ([_defaultBTServer.discoveredPeripherals count] > 0) {//找到蓝牙设备
        [userData setObject:@"1" forKey:@"printstate"];
        [userData synchronize];
        _periperal = _defaultBTServer.discoveredPeripherals[0];
        [_defaultBTServer connect:_periperal withFinishCB:^(CBPeripheral *peripheral, BOOL status, NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (status) {
                    [self showMessage];
                    
                    NSLog(@"connected success!");
                    
                    _timer= [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(requestService) userInfo:nil repeats:YES];
                    
                }else{
                    NSLog(@"connected failed!");
                    
                    [self alertMessage:@"蓝牙连接失败"];
                }
            });
        }];
    }
    else{//未找到蓝牙设备
        [userData setObject:@"0" forKey:@"printstate"];
        [userData synchronize];
        
        if (bl) {
            [self alertMessage:@"订单提交成功！未找到蓝牙设备,请到设置中心管理蓝牙"];
        }
        else{
            [self alertMessage:@"未找到蓝牙设备,请到设置中心管理蓝牙"];
        }
    }
}

//获取订单信息
-(void)getOrder:(NSString *)orderid
{
    UILabel *phone=(UILabel *)[self.view viewWithTag:102];//电话号码
    UILabel *address=(UILabel *)[self.view viewWithTag:103];//地址
    UILabel *orderdate=(UILabel *)[self.view viewWithTag:104];//订单时间
    UILabel *pay=(UILabel *)[self.view viewWithTag:101];//总价
    
    showNetLogoYES;
    _hudProgress.labelText=@"正在获取订单详情...";
    [_hudProgress show:YES];
    
    AFHTTPRequestOperationManager *httpRequest=[AFHTTPRequestOperationManager manager];
    NSDictionary *parm=[[NSDictionary alloc] initWithObjectsAndKeys:orderid,@"orderId",nil];
    [httpRequest GET:[HttpUrl stringByAppendingString:@"queryOrderByOrderId"] parameters:parm success:^(AFHTTPRequestOperation *operation,id responseObject){
        showNetLogoNO;
        [_hudProgress hide:YES];
        
        NSDictionary *result=(NSDictionary *)responseObject;
        if ([[result objectForKey:@"code"] isEqualToString:@"0"]) {
            _printString=[[NSMutableString alloc] init];//打印文本
            
            //同步服务器订单
            MainOrderInfoModel *mainOrderModel=[MainOrderInfoModel MainOrderInfoModelFromDictionary:[result objectForKey:@"orderInfo"]];
            [MainOrderInfoModel saveMainOrder:mainOrderModel];
            
            phone.text=mainOrderModel.order_tel;
            address.text=mainOrderModel.order_address;
            orderdate.text=mainOrderModel.create_time;
            pay.text=[NSString stringWithFormat:@"合计 %.2f 元",[mainOrderModel.should_pay floatValue]];
            
            [_printString appendFormat:@"\n\n订单编号：%@\n",mainOrderModel.order_sn];
            [_printString appendFormat:@"电话：%@\n",mainOrderModel.order_tel];
            [_printString appendFormat:@"时间：%@\n",mainOrderModel.create_time];
            [_printString appendFormat:@"地址：%@\n\n",mainOrderModel.order_address];
            
            OrderDetailInfoModel *orderDetail;
            for (NSDictionary *dic in [result objectForKey:@"orderDetailsList"]) {
                orderDetail=[OrderDetailInfoModel OrderDetailInfoModelFromDictionary:dic];
                [OrderDetailInfoModel saveOrderDetail:orderDetail];
                
                if ([orderDetail.goods_attach_name isEqualToString:@""]) {
                    [_printString appendFormat:@"配餐：%@\n",orderDetail.goods_name];
                }
                else{
                    [_printString appendFormat:@"配餐：%@\n",[orderDetail.goods_name stringByAppendingFormat:@"+%@",[orderDetail.goods_attach_name stringByReplacingOccurrencesOfString:@"," withString:@"+"]]];
                }
                [_printString appendFormat:@"小计：%@元\n",orderDetail.total_price];
                [_printString appendFormat:@"备注：%@\n",orderDetail.ask_for];
                [_printString appendString:@"\n"];
                
                [_orderList addObject:orderDetail];
            }
            [_printString appendFormat:@"合计：%@元\n\n\n\n\n\n\n\n",mainOrderModel.should_pay];
            
//            BuyerAddressInfoModel *addressModel=[BuyerAddressInfoModel BuyerAddressInfoModelFromDictionary:[result objectForKey:@"address"]];
//            [BuyerAddressInfoModel saveBuyerAddress:addressModel];
            
            [_orderTableView reloadData];
            
        }
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        showNetLogoNO;
        [_hudProgress hide:YES];
        NSLog(@"失败：%@",error);
        
        [self alertMessage:@"获取订单详情失败"];
    }];

}

-(void)didDisconnect
{
    [self alertMessage:@"蓝牙设备断开连接"];
}

//设置
-(void)pressSettingBtn:(UIButton *)btn
{
    SettingViewController *vc=[[SettingViewController alloc] init];
    vc.title=@"设置";
    [self.navigationController pushViewController:vc animated:YES];
}

//返回
-(void)pressBtnBack:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma tableview数据代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _orderList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderListTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:TableViewCellIdentifier];
    if (cell==nil) {
        cell=[[OrderListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableViewCellIdentifier];
    }
    
    cell.model=_orderList[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    WeiXinOrderViewController *phoneVC=[[WeiXinOrderViewController alloc] init];

    UIImageView *tarbar =(UIImageView *)[self.tabBarController.view viewWithTag:99];
    tarbar.hidden=YES;
    phoneVC.tabarHiddien=YES;
}

#pragma mark ----connection service
- (void)requestService
{
    
    for (CBService* ser  in _defaultBTServer.selectPeripheral.services) {
        
        [_defaultBTServer discoverService:ser];
        
        for (CBCharacteristic *ch in _defaultBTServer.discoveredSevice.characteristics) {
            
            NSString *s = [self getPropertiesString:ch.properties];
            
            if ([s isEqualToString:@" Read Write Notify Indicate"]) {
                
                [_timer invalidate];
                _timer=nil;
                
                [_defaultBTServer readValue:ch];
                
            }
        }
    }
}

-(NSString *)getPropertiesString:(CBCharacteristicProperties)properties
{
    NSMutableString *s = [[NSMutableString alloc]init];
    [s appendString:@""];
    
    if ((properties & CBCharacteristicPropertyBroadcast) == CBCharacteristicPropertyBroadcast) {
        [s appendString:@" Broadcast"];
    }
    if ((properties & CBCharacteristicPropertyRead) == CBCharacteristicPropertyRead) {
        [s appendString:@" Read"];
    }
    if ((properties & CBCharacteristicPropertyWriteWithoutResponse) == CBCharacteristicPropertyWriteWithoutResponse) {
        [s appendString:@" WriteWithoutResponse"];
    }
    if ((properties & CBCharacteristicPropertyWrite) == CBCharacteristicPropertyWrite) {
        [s appendString:@" Write"];
    }
    if ((properties & CBCharacteristicPropertyNotify) == CBCharacteristicPropertyNotify) {
        [s appendString:@" Notify"];
    }
    if ((properties & CBCharacteristicPropertyIndicate) == CBCharacteristicPropertyIndicate) {
        [s appendString:@" Indicate"];
    }
    if ((properties & CBCharacteristicPropertyAuthenticatedSignedWrites) == CBCharacteristicPropertyAuthenticatedSignedWrites) {
        [s appendString:@" AuthenticatedSignedWrites"];
    }
    if ((properties & CBCharacteristicPropertyExtendedProperties) == CBCharacteristicPropertyExtendedProperties) {
        [s appendString:@" ExtendedProperties"];
    }
    if ((properties & CBCharacteristicPropertyNotifyEncryptionRequired) == CBCharacteristicPropertyNotifyEncryptionRequired) {
        [s appendString:@" NotifyEncryptionRequired"];
    }
    if ((properties & CBCharacteristicPropertyIndicateEncryptionRequired) == CBCharacteristicPropertyIndicateEncryptionRequired) {
        [s appendString:@" IndicateEncryptionRequired"];
    }
    
    if ([s length]<2) {
        [s appendString:@"unknow"];
    }
    return s;
}

//弹出系统提示框
-(void)alertMessage:(NSString *)msg
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

//提交成功
-(void)showMessage
{
    _progress=[[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_progress];
    _progress.labelText=@"打印成功";
    _progress.mode=MBProgressHUDModeText;
    
    [_progress showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    } completionBlock:^{
        [_progress removeFromSuperview];
        _progress=nil;
    }];
}

@end
