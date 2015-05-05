//
//  BuyerInfoViewController.m
//  WirelessOrder
//
//  Created by eteng on 15/1/14.
//  Copyright (c) 2015年 etenginfo. All rights reserved.
//

#import "BuyerInfoViewController.h"
#import "BuyerInfoModel.h"
#import "BuyerInfoCellTableViewCell.h"

@interface BuyerInfoViewController ()

@end

@implementation BuyerInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化NavigationBar
    [self initNavigationBar];
    
    _buyerInfoList=[BuyerInfoModel getAllBuyerInfo:nil];
    
    //初始化表格
    [self initView];
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
}

//返回
-(void)pressBtnBack:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

//初始化表格
-(void)initView
{
    [_tableView registerClass:[BuyerInfoCellTableViewCell class] forCellReuseIdentifier:TableViewCellIdentifier];
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-20)];
    _tableView.backgroundColor=kUIColorFromRGB(0xeaeaea);
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
}

#pragma tableview委托
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _buyerInfoList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BuyerInfoCellTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:TableViewCellIdentifier];
    if (cell==nil) {
        cell=[[BuyerInfoCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableViewCellIdentifier];
    }
    
    cell.model=_buyerInfoList[indexPath.section];
    
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
    return 110;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
