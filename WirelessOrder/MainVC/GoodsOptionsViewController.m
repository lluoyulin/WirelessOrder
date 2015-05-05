//
//  GoodsOptionsViewController.m
//  WirelessOrder
//
//  Created by eteng on 15/1/20.
//  Copyright (c) 2015年 etenginfo. All rights reserved.
//

#import "GoodsOptionsViewController.h"
#import "GoodsClassInfoModel.h"
#import "GoodsOptionsCellTableViewCell.h"

@interface GoodsOptionsViewController ()

@end

@implementation GoodsOptionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化NavigationBar
    [self initNavigationBar];
    
    _goodsClassList=[GoodsClassInfoModel getAllGoodsClass:[NSString stringWithFormat:@"seller_id='%@'",[UserData stringForKey:@"sellerId"]]];
    
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
    [_tableView registerClass:[GoodsOptionsCellTableViewCell class] forCellReuseIdentifier:TableViewCellIdentifier];
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-20)];
    _tableView.backgroundColor=kUIColorFromRGB(0xeaeaea);
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

#pragma tableview委托
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _goodsClassList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionte
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsOptionsCellTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:TableViewCellIdentifier];
    if (cell==nil) {
        cell=[[GoodsOptionsCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableViewCellIdentifier];
    }
    
    cell.goodsClassModel=_goodsClassList[indexPath.section];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @" ";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

@end
