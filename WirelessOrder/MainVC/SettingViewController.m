//
//  SettingViewController.m
//  WirelessOrder
//
//  Created by eteng on 15/1/14.
//  Copyright (c) 2015年 etenginfo. All rights reserved.
//

#import "SettingViewController.h"
#import "BlueToothViewController.h"
#import "BTServer.h"
#import "LoginViewController.h"
#import "SellerOptionsInfoModel.h"
#import "AFHTTPRequestOperationManager.h"
#import "MyInfoViewController.h"
#import "SellerModel.h"
#import "GoodsInfoModel.h"
#import "GoodsClassInfoModel.h"
#import "SellerOptionsInfoModel.h"
#import "BuyerInfoModel.h"
#import "BuyerInfoViewController.h"
#import "GoodsClassListViewController.h"
#import "GoodsOptionsViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化NavigationBar
    [self initNavigationBar];
    
    //初始化设置表格
    [self initView];
    
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
    
    UIButton *btnBack=[UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame=CGRectMake(0, (44-36)/2, 50.25, 36);
    [btnBack setBackgroundImage:[UIImage imageNamed:@"bluetooth_back"] forState:UIControlStateNormal];
    [btnBack setBackgroundImage:[UIImage imageNamed:@"bluetooth_back_select"] forState:UIControlStateHighlighted];
    [btnBack addTarget:self action:@selector(pressBtnBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton=[[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem=leftBarButton;
    
    UIButton *btnAdd=[UIButton buttonWithType:UIButtonTypeCustom];
    btnAdd.frame=CGRectMake(0, (44-36)/2, 50.25, 36);
    [btnAdd setTitle:@"编辑" forState:UIControlStateNormal];
    [btnAdd setAccessibilityValue:@"编辑"];
    [btnAdd addTarget:self action:@selector(pressBtnAdd:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton=[[UIBarButtonItem alloc] initWithCustomView:btnAdd];
    self.navigationItem.rightBarButtonItem=rightBarButton;
}

//编辑
-(void)pressBtnAdd:(UIButton *)btn
{
    if ([btn.accessibilityValue isEqualToString:@"编辑"]) {
        [btn setTitle:@"完成" forState:UIControlStateNormal];
        [btn setAccessibilityValue:@"完成"];
        [_tableView setEditing:YES animated:YES];
    }
    else{
        [btn setTitle:@"编辑" forState:UIControlStateNormal];
        [btn setAccessibilityValue:@"编辑"];
        [_tableView setEditing:NO animated:NO];
    }
}

//返回
-(void)pressBtnBack:(UIButton *)btn
{
    [_tableView setEditing:NO animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

//初始化设置表格
-(void)initView
{
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-44)];
    _tableView.backgroundColor=kUIColorFromRGB(0xeaeaea);
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
}

//打印按钮
-(void)pressSwitch:(UISwitch *)switchPrint
{
    NSUserDefaults *userData=[NSUserDefaults standardUserDefaults];
    [userData setObject:@"0" forKey:@"printstate"];
    [userData synchronize];
    
    if ([switchPrint isOn]) {
        BlueToothViewController *blueVC=[[BlueToothViewController alloc] init];
        blueVC.title=@"蓝牙打印机";
        [self.navigationController pushViewController:blueVC animated:YES];
    }
    else{
        BTServer *defaultBTServer=[BTServer defaultBTServer];
        [defaultBTServer disConnect];
    }
}

//弹出系统提示框
-(void)alertMessage:(NSString *)msg
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

//是否需要登录
-(BOOL)isLogin
{
    if ([[UserData stringForKey:@"sellerId"] isEqualToString:@""] || [UserData stringForKey:@"sellerId"]==nil) {
        LoginViewController *loginView=[[LoginViewController alloc] init];
        [self.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:loginView] animated:YES completion:nil];
        return YES;
    }
    return NO;
}

//提示语
-(void)showMsg:(NSString *)msg
{
    _hudShowMsg=[[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_hudShowMsg];
    
    _hudShowMsg.labelText=msg;
    _hudShowMsg.mode=MBProgressHUDModeText;
    
    [_hudShowMsg showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    } completionBlock:^{
        [_hudShowMsg removeFromSuperview];
        _hudShowMsg=nil;
    }];
}

//获取卖家信息
-(void)getSellerModel
{
    _hudProgress.labelText=@"正在获取我的资料...";
    [_hudProgress show:YES];
    showNetLogoYES;
    
    AFHTTPRequestOperationManager *httpRequest=[AFHTTPRequestOperationManager manager];
    NSDictionary *parm=[[NSDictionary alloc] initWithObjectsAndKeys:[UserData stringForKey:@"sellerId"],@"sellerId",nil];
    [httpRequest GET:[HttpUrl stringByAppendingString:@"querySellerById"] parameters:parm success:^(AFHTTPRequestOperation *operation,id responseObject){
        
        _hudProgress.labelText=@"正在同步我的资料...";
        showNetLogoNO;
        
        NSDictionary *result=(NSDictionary *)responseObject;
        if ([[result objectForKey:@"code"] isEqualToString:@"0"]) {
            SellerModel *model=[SellerModel SellerModelFromDictionary:[result objectForKey:@"seller"]];
            [SellerModel deleteSeller];
            [SellerModel saveSeller:model];
            
            [_hudProgress hide:YES];
            [self showMsg:@"同步成功"];
        }
        else{
            [_hudProgress hide:YES];
            [self alertMessage:[result objectForKey:@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [_hudProgress hide:YES];
        showNetLogoNO;
        
        [self alertMessage:@"同步失败"];
        NSLog(@"失败：%@",error);
    }];
}

//获取卖家菜单信息
-(void)getGoodsModel
{
    _hudProgress.labelText=@"正在获取菜单信息...";
    [_hudProgress show:YES];
    showNetLogoYES;
    
    AFHTTPRequestOperationManager *httpRequest=[AFHTTPRequestOperationManager manager];
    NSDictionary *parm=[[NSDictionary alloc] initWithObjectsAndKeys:[UserData stringForKey:@"sellerId"],@"sellerId",nil];
    [httpRequest GET:[HttpUrl stringByAppendingString:@"querySellerMealById"] parameters:parm success:^(AFHTTPRequestOperation *operation,id responseObject){
        
        _hudProgress.labelText=@"正在同步菜单信息...";
        showNetLogoNO;
        
        NSDictionary *result=(NSDictionary *)responseObject;
        if ([[result objectForKey:@"code"] isEqualToString:@"0"]) {
            [GoodsInfoModel deleteAllGoods:nil];
            [GoodsClassInfoModel deleteAllGoodsClass:nil];
            for (NSDictionary *dic in [result objectForKey:@"cAgModelList"]) {
                for (NSDictionary *dicGoods in [dic objectForKey:@"goodsList"]) {
                    GoodsInfoModel *model=[GoodsInfoModel GoodsModelFromDictionary:dicGoods];
                    [GoodsInfoModel saveGoods:model];
                }
                GoodsClassInfoModel *model=[GoodsClassInfoModel GoodsClassModelFromDictionary:[dic objectForKey:@"gClass"]];
                [GoodsClassInfoModel saveGoodsClass:model];
            }
            
            [_hudProgress hide:YES];
            [self showMsg:@"同步成功"];
        }
        else{
            [_hudProgress hide:YES];
            [self alertMessage:[result objectForKey:@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [_hudProgress hide:YES];
        showNetLogoNO;
        
        [self alertMessage:@"同步失败"];
        NSLog(@"失败：%@",error);
    }];
}

//获取卖家备注信息
-(void)getSellerOptionsInfoModel
{
    _hudProgress.labelText=@"正在获取备注信息...";
    [_hudProgress show:YES];
    showNetLogoYES;
    
    AFHTTPRequestOperationManager *httpRequest=[AFHTTPRequestOperationManager manager];
    NSDictionary *parm=[[NSDictionary alloc] initWithObjectsAndKeys:[UserData stringForKey:@"sellerId"],@"sellerId",nil];
    [httpRequest GET:[HttpUrl stringByAppendingString:@"querySellerOptionsById"] parameters:parm success:^(AFHTTPRequestOperation *operation,id responseObject){
        
        _hudProgress.labelText=@"正在同步备注信息...";
        showNetLogoNO;
        
        NSDictionary *result=(NSDictionary *)responseObject;
        if ([[result objectForKey:@"code"] isEqualToString:@"0"]) {
            [SellerOptionsInfoModel deleteAllSellerOptions:nil];
            [GoodsClassInfoModel deleteAllGoodsClass:nil];
            for (NSDictionary *dic in [result objectForKey:@"cAoModelList"]) {
                for (NSDictionary *dicGoods in [dic objectForKey:@"optionsList"]) {
                    SellerOptionsInfoModel *model=[SellerOptionsInfoModel SellerOptionsInfoModelFromDictionary:dicGoods];
                    [SellerOptionsInfoModel saveSellerOptions:model];
                }
                GoodsClassInfoModel *model=[GoodsClassInfoModel GoodsClassModelFromDictionary:[dic objectForKey:@"gClass"]];
                [GoodsClassInfoModel saveGoodsClass:model];
            }
            
            [_hudProgress hide:YES];
            [self showMsg:@"同步成功"];
        }
        else{
            [_hudProgress hide:YES];
            [self alertMessage:[result objectForKey:@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [_hudProgress hide:YES];
        showNetLogoNO;
        
        [self alertMessage:@"同步失败"];
        NSLog(@"失败：%@",error);
    }];
}

//获取客户信息
-(void)getBuyerAddressInfoModel
{
    _hudProgress.labelText=@"正在获取客户信息...";
    [_hudProgress show:YES];
    showNetLogoYES;
    
    AFHTTPRequestOperationManager *httpRequest=[AFHTTPRequestOperationManager manager];
    NSDictionary *parm=[[NSDictionary alloc] initWithObjectsAndKeys:[UserData stringForKey:@"sellerId"],@"sellerId",nil];
    [httpRequest GET:[HttpUrl stringByAppendingString:@"querySellerCustomerById"] parameters:parm success:^(AFHTTPRequestOperation *operation,id responseObject){
        
        _hudProgress.labelText=@"正在同步客户信息...";
        showNetLogoNO;
        
        NSDictionary *result=(NSDictionary *)responseObject;
        if ([[result objectForKey:@"code"] isEqualToString:@"0"]) {
            [BuyerInfoModel deleteAllBuyerInfo:nil];
            for (NSDictionary *dic in [result objectForKey:@"customerList"]) {
                [BuyerInfoModel saveBuyerInfo:[BuyerInfoModel BuyerInfoModelFromDictionary:dic]];
            }
            [_hudProgress hide:YES];
            [self showMsg:@"同步成功"];
        }
        else{
            [_hudProgress hide:YES];
            [self alertMessage:[result objectForKey:@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [_hudProgress hide:YES];
        showNetLogoNO;
        
        [self alertMessage:@"同步失败"];
        NSLog(@"失败：%@",error);
    }];
}

#pragma 重写系统api
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_tableView reloadData];
}

-(void)viewDidLayoutSubviews
{
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

#pragma tableview数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count=1;
    switch (section) {
        case 0:
            count=1;
            break;
        case 1:
            count=4;
            break;
        case 2:
            count=2;
            break;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:TableViewCellIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableViewCellIdentifier];
        
        if (indexPath.section==0) {
            UILabel *printLbl=[[UILabel alloc] initWithFrame:CGRectMake(40, (cell.frame.size.height-30)/2, 70, 30)];
            printLbl.tag=201;
            [cell.contentView addSubview:printLbl];
            
            UISwitch *switchPrint=[[UISwitch alloc] initWithFrame:CGRectMake(ScreenWidth-76, (cell.frame.size.height-34)/2, 0, 0)];
            switchPrint.tag=210;
            [cell.contentView addSubview:switchPrint];
        }
        else if(indexPath.section==1){
            UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(20,(cell.frame.size.height-22.57)/2 , 22.57, 22.57)];
            imageView.tag=202;
            [cell.contentView addSubview:imageView];
            
            UILabel *textLbl=[[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x+imageView.frame.size.width+10, imageView.frame.origin.y,80,imageView.frame.size.height)];
            textLbl.tag=203;
            [cell.contentView addSubview:textLbl];
        }
        else if (indexPath.section==2)
        {
            if (indexPath.row==0) {
                UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(20,(cell.frame.size.height-22.57)/2 , 22.57, 22.57)];
                imageView.tag=204;
                [cell.contentView addSubview:imageView];
                
                UILabel *textLbl=[[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x+imageView.frame.size.width+10, imageView.frame.origin.y,80,imageView.frame.size.height)];
                textLbl.tag=205;
                [cell.contentView addSubview:textLbl];
            }
            else if (indexPath.row==1){
                UILabel *loginOutLbl=[[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-40)/2,(cell.frame.size.height-35)/2,40,35)];
                loginOutLbl.tag=206;
                [cell.contentView addSubview:loginOutLbl];
            }
        }
    }
    
    if (indexPath.section==0) {
        UILabel *printLbl=(UILabel *)[cell.contentView viewWithTag:201];
        printLbl.text=@"打印机";
        
        UISwitch *switchPrint=(UISwitch *)[cell.contentView viewWithTag:210];
        switchPrint.onTintColor=kUIColorFromRGB(0xf33637);
        switchPrint.tintColor=kUIColorFromRGB(0xaeaeae);
        [switchPrint addTarget:self action:@selector(pressSwitch:) forControlEvents:UIControlEventValueChanged];
        
        NSUserDefaults *userData=[NSUserDefaults standardUserDefaults];
        if ([[userData stringForKey:@"printstate"] isEqualToString:@"1"]) {
            [switchPrint setOn:YES animated:YES];
        }
        else{
            [switchPrint setOn:NO animated:YES];
        }
    }
    else if (indexPath.section==1){
        UIImageView *imageView=(UIImageView *)[cell.contentView viewWithTag:202];
        UILabel *textLbl=(UILabel *)[cell.contentView viewWithTag:203];
        switch (indexPath.row) {
            case 0:
                textLbl.text=@"我的资料";
                [imageView setImage:[UIImage imageNamed:@"myinfo"]];
                break;
            case 1:
                textLbl.text=@"菜单信息";
                [imageView setImage:[UIImage imageNamed:@"dishes_upload"]];
                break;
            case 2:
                textLbl.text=@"备注信息";
                [imageView setImage:[UIImage imageNamed:@"remarkinfo"]];
                break;
            case 3:
                textLbl.text=@"客户信息";
                [imageView setImage:[UIImage imageNamed:@"sellerinfo"]];
                break;
        }
    }
    else if (indexPath.section==2){
        if (indexPath.row==0) {
            UIImageView *imageView=(UIImageView *)[cell.contentView viewWithTag:204];
            UILabel *textLbl=(UILabel *)[cell.contentView viewWithTag:205];
            textLbl.text=@"帮助";
            [imageView setImage:[UIImage imageNamed:@"help"]];
        }
        else if (indexPath.row==1){
            UILabel *loginOutLbl=(UILabel *)[cell.contentView viewWithTag:206];
            if ([[UserData stringForKey:@"sellerId"] isEqualToString:@""] || [UserData stringForKey:@"sellerId"]==nil) {
                loginOutLbl.text=@"登 录";
            }
            else{
                loginOutLbl.text=@"退 出";
            }
        }
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @" ";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self isLogin]) {
        if (indexPath.section==0) {
            
        }
        else if (indexPath.section==1){
            if (indexPath.row==0) {//我的资料
                MyInfoViewController *myInfoVC=[[MyInfoViewController alloc] init];
                myInfoVC.title=@"我的资料";
                [self.navigationController pushViewController:myInfoVC animated:YES];
            }
            else if (indexPath.row==1){//菜单信息
                GoodsClassListViewController *goodsClassListVC=[[GoodsClassListViewController alloc] init];
                goodsClassListVC.title=@"菜品类目";
                [self.navigationController pushViewController:goodsClassListVC animated:YES];
            }
            else if (indexPath.row==2){//备注信息
                GoodsOptionsViewController *goodsOptionsVC=[[GoodsOptionsViewController alloc] init];
                goodsOptionsVC.title=@"备注信息";
                [self.navigationController pushViewController:goodsOptionsVC animated:YES];
            }
            else if (indexPath.row==3){//客户信息
                BuyerInfoViewController *buyerInfoVC=[[BuyerInfoViewController alloc] init];
                buyerInfoVC.title=@"客户信息";
                [self.navigationController pushViewController:buyerInfoVC animated:YES];
            }
        }
        else if (indexPath.section==2){
            if (indexPath.row==0) {
                
            }
            else if (indexPath.row==1){
                [UserData setObject:@"" forKey:@"sellerId"];
                
                [self showMsg:@"退出成功"];
                
                [_tableView reloadData];
            }
        }
    }
    
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return NO;
    }
    else if (indexPath.section==2)
    {
        return NO;
    }
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete) {//同步
        if (![self isLogin]) {
            if (indexPath.section==1) {
                if (indexPath.row==0) {//我的资料
                    [self getSellerModel];
                }
                else if (indexPath.row==1){//菜单信息
                    [self getGoodsModel];
                }
                else if (indexPath.row==2){//备注信息
                    [self getSellerOptionsInfoModel];
                }
                else if (indexPath.row==3){//客户信息
                    [self getBuyerAddressInfoModel];
                }
                [_tableView reloadData];
            }
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"同步";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

@end
