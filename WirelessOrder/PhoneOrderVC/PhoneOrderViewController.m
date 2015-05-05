//
//  PhoneOrderViewController.m
//  WirelessOrder
//
//  Created by eteng on 14/12/12.
//  Copyright (c) 2014年 etenginfo. All rights reserved.
//

#import "PhoneOrderViewController.h"
#import "ReservationViewController.h"
#import "OrderDetailInfoModel.h"
#import "OrderListTableViewCell.h"
#import "BlueToothViewController.h"
#import "MainOrderInfoModel.h"
#import "BuyerAddressInfoModel.h"
#import "AFHTTPRequestOperationManager.h"
#import "QCSlideViewController.h"
#import "LoginViewController.h"
#import "SettingViewController.h"
#import "BuyerInfoModel.h"

#import "QCLeftMenuViewController.h"
#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"

static const CGFloat kPublicLeftMenuWidth = 180.0f;

@interface PhoneOrderViewController ()

@end

@implementation PhoneOrderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"电话订单";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化NavigationBar
    [self initNavigationBar];
    
    //创建订单View
    [self initView];

    _userData=[NSUserDefaults standardUserDefaults];
    
    _defaultBTServer = [BTServer defaultBTServer];
    _defaultBTServer.delegate = (id)self;
//    [_defaultBTServer startScan];
    
    _hudProgress=[[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_hudProgress];
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

//创建订单View
-(void)initView
{
    UIView *userInfoView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 170)];//用户信息view
    userInfoView.tag=110;
  
    UIImageView *userPhoneView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, (userInfoView.frame.size.height-4.0)/4.0)];
    userPhoneView.tag=120;
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
    
    UITextField *phoneText=[[UITextField alloc] initWithFrame:CGRectMake(phoneLbl.frame.origin.x+phoneLbl.frame.size.width+10, 0, ScreenWidth-(phoneLbl.frame.origin.x+phoneLbl.frame.size.width+10)-(ScreenWidth*0.10), userPhoneView.frame.size.height)];
    phoneText.tag=102;
    phoneText.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    phoneText.placeholder=@"请输入完整号码或后4位";
    phoneText.font=[UIFont systemFontOfSize:14.0];
    phoneText.keyboardType=UIKeyboardTypeNamePhonePad;
    phoneText.returnKeyType=UIReturnKeyGoogle;
    phoneText.delegate=self;
    phoneText.clearButtonMode=UITextFieldViewModeWhileEditing;
    
    KeyboardToolBar *keyboard=[[KeyboardToolBar alloc] init];
    keyboard.delegateKeyboard=self;
    
    phoneText.inputAccessoryView=keyboard;
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
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    oderDateLbl.text=[formatter stringFromDate:[NSDate date]];
    [userDateView addSubview:oderDateLbl];
    
    
    
    
    UIImageView *userAddrView=[[UIImageView alloc] initWithFrame:CGRectMake(0, userPhoneView.frame.size.height+userDateView.frame.size.height, ScreenWidth, (userInfoView.frame.size.height-4)/4.0)];
    userAddrView.tag=130;
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
    
    UITextField *AddrText=[[UITextField alloc] initWithFrame:CGRectMake(phoneLbl.frame.origin.x+phoneLbl.frame.size.width+10, 0, ScreenWidth-(phoneLbl.frame.origin.x+phoneLbl.frame.size.width+10), userAddrView.frame.size.height)];
    AddrText.tag=103;
    AddrText.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    AddrText.placeholder=@"请输入地址";
    AddrText.font=[UIFont systemFontOfSize:14.0];
    AddrText.delegate=self;
    AddrText.clearButtonMode=UITextFieldViewModeWhileEditing;
    AddrText.inputAccessoryView=keyboard;
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
    [addOrderBtn setBackgroundImage:[UIImage imageNamed:@"phone_order_add_select"] forState:UIControlStateHighlighted];
    [addOrderBtn setTitle:@"配餐" forState:UIControlStateNormal];
    [addOrderBtn setTitleColor:kUIColorFromRGB(0xea3808) forState:UIControlStateNormal];
    [addOrderBtn addTarget:self action:@selector(pressOrderBtn:) forControlEvents:UIControlEventTouchUpInside];
    addOrderBtn.contentEdgeInsets=UIEdgeInsetsMake(0, 25, 0, 0);
    [addOrderView addSubview:addOrderBtn];
    

    
    
    [_orderTableView registerClass:[OrderListTableViewCell class] forCellReuseIdentifier:TableViewCellIdentifier];
    _orderTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-49-44-20-40)];//用户订单信息
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
    [submitBtn addTarget:self action:@selector(submitOrder) forControlEvents:UIControlEventTouchUpInside];
    
    [orderSumView addSubview:submitBtn];
}

//关闭键盘
- (void)resignKeyboard
{
    UIView *userInfoView=(UIView *)[self.view viewWithTag:110];
    UIImageView *userPhoneView=(UIImageView *)[userInfoView viewWithTag:120];
    UIImageView *userAddrView=(UIImageView *)[userInfoView viewWithTag:130];
    UITextField *phoneText=(UITextField *)[userPhoneView viewWithTag:102];
    UITextField *AddrText=(UITextField *)[userAddrView viewWithTag:103];
    
    [phoneText resignFirstResponder];
    [AddrText resignFirstResponder];
}

//提交订单
-(void)submitOrder
{
    if (_orderList.count>0) {
        UITextField *phone=(UITextField *)[self.view viewWithTag:102];//电话号码
        UITextField *address=(UITextField *)[self.view viewWithTag:103];//地址
        
        if ([phone.text isEqualToString:@""]) {
            [self alertMessage:@"电话不能为空"];
        }
        else{
            if ([address.text isEqualToString:@""]) {
                [self alertMessage:@"地址不能为空"];
            }
            else{
                NSDictionary *orderInfo=@{@"orderId":@"",@"orderSn":@"",@"sellerUserId":[_userData stringForKey:@"sellerId"],@"buyerUserId":@"",@"totalPay":[NSString stringWithFormat:@"%.2f",_orderSum],@"shouldPay":[NSString stringWithFormat:@"%.2f",_orderSum],@"orderSource":@"1",@"orderStatus":@"1",@"createTime":@"",@"createPerson":@"",@"besureTime":@"",@"besurePerson":@"",@"addressId":@"",@"orderTel":phone.text,@"orderAddress":address.text};//订单信息
                NSError *errorOrderInfo = nil;
                NSData *dataOrderInfo=[NSJSONSerialization dataWithJSONObject:orderInfo options:NSJSONWritingPrettyPrinted error:&errorOrderInfo];
                NSString *jsonOrderinfo=@"";
                if ([dataOrderInfo length] > 0 && errorOrderInfo == nil){
                    jsonOrderinfo=[[NSString alloc] initWithData:dataOrderInfo encoding:NSUTF8StringEncoding];
                }else{
                    
                }
                
                NSMutableArray *orderDetailsList=[[NSMutableArray alloc] init];//订单明细
                for (OrderDetailInfoModel *model in _orderList) {
                    NSDictionary *dic=@{@"detailId":@"",@"orderId":@"",@"goodsId":model.goods_id,@"goodsName":model.goods_name,@"goodsSinglePrice":model.goods_single_price,@"goodsDiscountPrice":model.goods_discount_price,@"goodsNumber":model.goods_number,@"goodsAttachName":model.goods_attach_name,@"goodsAttachPrice":model.goods_attach_price,@"askFor":model.ask_for,@"totalPrice":model.total_price,@"createTime":@"",@"createPerson":@""};
                    [orderDetailsList addObject:dic];
                }
                NSError *errorOrderDetailsList=nil;
                NSData *dataOrderDetailsList=[NSJSONSerialization dataWithJSONObject:orderDetailsList options:NSJSONWritingPrettyPrinted error:&errorOrderDetailsList];
                NSString *jsonOrderDetailsList=@"";
                if ([dataOrderDetailsList length]>0 && errorOrderDetailsList ==nil) {
                    jsonOrderDetailsList=[[NSString alloc] initWithData:dataOrderDetailsList encoding:NSUTF8StringEncoding];
                }
                else{
                    
                }
                
                NSDictionary *addressInfo=@{@"addressId":@"",@"buyerId":@"",@"buyerName":@"",@"buyerTel":phone.text,@"detailAddress":address.text,@"addStatus":@"1",@"createPerson":@"",@"createDate":@""};//地址信息
                NSError *errorAddressInfo=nil;
                NSData *dataAddressInfo=[NSJSONSerialization dataWithJSONObject:addressInfo options:NSJSONWritingPrettyPrinted error:&errorAddressInfo];
                NSString *jsonAddressInfo=@"";
                if ([dataAddressInfo length]>0 && errorAddressInfo ==nil) {
                    jsonAddressInfo=[[NSString alloc] initWithData:dataAddressInfo encoding:NSUTF8StringEncoding];
                }
                else{
                    
                }
                
                showNetLogoYES;
                _hudProgress.labelText=@"正在提交订单...";
                [_hudProgress show:YES];
                
                AFHTTPRequestOperationManager *httpRequest=[AFHTTPRequestOperationManager manager];
                NSDictionary *parm=[[NSDictionary alloc] initWithObjectsAndKeys:jsonOrderinfo,@"orderInfo",jsonOrderDetailsList,@"orderDetailsList",jsonAddressInfo,@"addressInfo",nil];
                [httpRequest POST:[HttpUrl stringByAppendingString:@"addOrder"] parameters:parm success:^(AFHTTPRequestOperation *operation,id responseObject){
                    showNetLogoNO;
                    [_hudProgress hide:YES];
                    
                    NSDictionary *result=(NSDictionary *)responseObject;
                    if ([[result objectForKey:@"code"] isEqualToString:@"0"]) {
                        NSMutableString *printString=[[NSMutableString alloc] init];//打印文本
                        
                        //清空当前订单
                        [OrderDetailInfoModel deleteAllOrderDetail:[NSString stringWithFormat:@"order_id='%@'",[_userData stringForKey:@"orderno"]]];
                        [_userData setObject:@"" forKey:@"orderno"];
                        [_userData synchronize];
                        
                        //同步服务器订单
                        MainOrderInfoModel *mainOrderModel=[MainOrderInfoModel MainOrderInfoModelFromDictionary:[result objectForKey:@"order"]];
//                        [MainOrderInfoModel saveMainOrder:mainOrderModel];
                        [printString appendFormat:@"\n\n订单编号：%@\n",mainOrderModel.order_sn];
                        [printString appendFormat:@"电话：%@\n",mainOrderModel.order_tel];
                        [printString appendFormat:@"时间：%@\n",mainOrderModel.create_time];
                        [printString appendFormat:@"地址：%@\n\n",mainOrderModel.order_address];
                        
                        OrderDetailInfoModel *orderDetail;
                        for (NSDictionary *dic in [result objectForKey:@"orderDetailsList"]) {
                            orderDetail=[OrderDetailInfoModel OrderDetailInfoModelFromDictionary:dic];
//                            [OrderDetailInfoModel saveOrderDetail:orderDetail];
                            
                            if ([orderDetail.goods_attach_name isEqualToString:@""]) {
                                [printString appendFormat:@"配餐：%@\n",orderDetail.goods_name];
                            }
                            else{
                                [printString appendFormat:@"配餐：%@\n",[orderDetail.goods_name stringByAppendingFormat:@"+%@",[orderDetail.goods_attach_name stringByReplacingOccurrencesOfString:@"," withString:@"+"]]];
                            }
                            [printString appendFormat:@"小计：%@元\n",orderDetail.total_price];
                            [printString appendFormat:@"备注：%@\n",orderDetail.ask_for];
                            [printString appendString:@"\n"];
                        }
                        [printString appendFormat:@"合计：%@元\n\n\n\n\n\n\n\n",mainOrderModel.should_pay];
                        
//                        BuyerAddressInfoModel *addressModel=[BuyerAddressInfoModel BuyerAddressInfoModelFromDictionary:[result objectForKey:@"address"]];
//                        [BuyerAddressInfoModel saveBuyerAddress:addressModel];
                        
                        BuyerInfoModel *buyerInfoModel=[[BuyerInfoModel alloc] init];
                        buyerInfoModel.tel=mainOrderModel.order_tel;
                        buyerInfoModel.address=mainOrderModel.order_address;
                        buyerInfoModel.totalNumber=@"1";
                        buyerInfoModel.totalMoney=mainOrderModel.should_pay;
                        [BuyerInfoModel updateBuyerInfo:buyerInfoModel];
                        
                        //打印
                        _defaultBTServer.printString=printString;
                        
                        [_defaultBTServer stopScan:YES];
                        
                        if ([_defaultBTServer.discoveredPeripherals count] > 0) {//找到蓝牙设备
                            [_userData setObject:@"1" forKey:@"printstate"];
                            [_userData synchronize];
                            _periperal = _defaultBTServer.discoveredPeripherals[0];
                            [_defaultBTServer connect:_periperal withFinishCB:^(CBPeripheral *peripheral, BOOL status, NSError *error) {
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    if (status) {
                                        [self showMessage];
                                        
                                        [self reset];
                                        
                                        NSLog(@"connected success!");
                                        
                                        _timer= [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(requestService) userInfo:nil repeats:YES];
                                        
                                    }else{
                                        NSLog(@"connected failed!");
                                        
                                        [self alertMessage:@"订单已提交成功！蓝牙连接失败"];
                                        
                                        [self reset];
                                    }
                                });
                            }];
                        }
                        else{//未找到蓝牙设备
                            [_userData setObject:@"0" forKey:@"printstate"];
                            [_userData synchronize];
                            
                            [self alertMessage:@"订单已提交成功！未找到蓝牙设备,请到设置中心管理蓝牙"];
                            
                            [self reset];
                        }
                    }
                } failure:^(AFHTTPRequestOperation *operation,NSError *error){
                    showNetLogoNO;
                    [_hudProgress hide:YES];
                    NSLog(@"失败：%@",error);
                    
                    [self alertMessage:@"提交订单失败"];
                }];
            }
        }
    }
    else{
        [self alertMessage:@"请至少点一餐"];
    }
}

-(void)didDisconnect
{
    [self alertMessage:@"蓝牙设备断开连接"];
}

//键盘回车事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.tag==102)//电话
    {
        if(textField.text.length>0)
        {
            NSMutableString *where=[[NSMutableString alloc] init];
            if (textField.text.length==4) {
                [where appendString:[NSString stringWithFormat:@"substr(tel,8,4)='%@'",textField.text]];
            }
            else{
                [where appendString:[NSString stringWithFormat:@"tel='%@'",textField.text]];
            }
            
            UITextField *address=(UITextField *)[self.view viewWithTag:103];//地址
            NSArray *buyerAddress=[BuyerInfoModel getAllBuyerInfo:where];
            if (buyerAddress.count>0) {
                BuyerInfoModel *model=buyerAddress[0];
                textField.text=model.tel;
                address.text=model.address;
                
                [textField resignFirstResponder];
            }
            else{
                address.text=@"";
                address.placeholder=@"请为新用户输入地址";
                [address becomeFirstResponder];
            }
        }
    }
    else{
        [textField resignFirstResponder];
    }

    return YES;
}

//点餐
-(void)pressOrderBtn:(UIButton *)btn
{
    if (![self isLogin]) {
        QCLeftMenuViewController *leftVC = [[QCLeftMenuViewController alloc]
                                            initWithNibName:@"QCLeftMenuViewController"
                                            bundle:nil];
        
        QCViewController * drawerController = [[QCViewController alloc]
                                                        initWithCenterViewController:leftVC.navSlideSwitchVC
                                                        leftDrawerViewController:nil
                                                        rightDrawerViewController:nil];
        [drawerController setMaximumLeftDrawerWidth:kPublicLeftMenuWidth];
        [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
        [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
        [drawerController setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
            MMDrawerControllerDrawerVisualStateBlock block;
            block = [MMDrawerVisualState parallaxVisualStateBlockWithParallaxFactor:2.0];
            block(drawerController, drawerSide, percentVisible);
        }];
        
        [self.navigationController presentViewController:drawerController animated:YES completion:nil];
    }
}

//设置
-(void)pressSettingBtn:(UIButton *)btn
{
    if (![self isLogin]) {
//        self.tabarHiddien=YES;
        SettingViewController *vc=[[SettingViewController alloc] init];
        vc.title=@"设置";
        [self.navigationController pushViewController:vc animated:YES];
    }
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        OrderDetailInfoModel *model=_orderList[indexPath.row];
        if ([OrderDetailInfoModel deleteAllOrderDetail:[NSString stringWithFormat:@"detail_id='%@'",model.detail_id]]) {
            [self getOrderlist];
            [_orderTableView reloadData];
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([UserData boolForKey:@"islogin"]) {
        [self isLogin];
    }
    
//    if (self.tabarHiddien) {
//        UIImageView *tarbar =(UIImageView *)[self.tabBarController.view viewWithTag:99];
//        tarbar.hidden=NO;
//        self.tabarHiddien=NO;
//    }
    
    [self getOrderlist];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    if (self.tabarHiddien) {
//        UIImageView *tarbar =(UIImageView *)[self.tabBarController.view viewWithTag:99];
//        tarbar.hidden=YES;
//    }
}

//获取点餐订单数据
-(void)getOrderlist
{
    NSString *orderNO=[_userData stringForKey:@"orderno"];
    
    _orderList=[OrderDetailInfoModel getAllOrderDetail:[NSString stringWithFormat:@"order_id='%@'",orderNO]];
    
    _orderSum=0.00;
    if (_orderList.count>0) {
        for (OrderDetailInfoModel *model in _orderList) {
            _orderSum+=[model.total_price floatValue];
        }
    }
    UILabel *lbl=(UILabel *)[self.view viewWithTag:101];
    lbl.text=[NSString stringWithFormat:@"合计 %.2f 元",_orderSum];
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
    _progress.labelText=@"提交成功";
    _progress.mode=MBProgressHUDModeText;
    
    [_progress showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    } completionBlock:^{
        [_progress removeFromSuperview];
        _progress=nil;
    }];
}

//初始化
-(void)reset
{
    UITextField *phone=(UITextField *)[self.view viewWithTag:102];//电话号码
    UITextField *address=(UITextField *)[self.view viewWithTag:103];//地址
    phone.text=@"";
    address.text=@"";
    address.placeholder=@"请输入地址";
    _orderList=[[NSMutableArray alloc] init];
    [_orderTableView reloadData];
    _orderSum=0.00;
    UILabel *lbl=(UILabel *)[self.view viewWithTag:101];
    lbl.text=@"合计 0.00 元";
}

//是否需要登录
-(BOOL)isLogin
{
    if ([[_userData stringForKey:@"sellerId"] isEqualToString:@""] || [_userData stringForKey:@"sellerId"]==nil) {
        LoginViewController *loginView=[[LoginViewController alloc] init];
        [self.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:loginView] animated:YES completion:nil];
        return YES;
    }
    return NO;
}

@end
