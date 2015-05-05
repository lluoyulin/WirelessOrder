//
//  MyInfoViewController.m
//  WirelessOrder
//
//  Created by eteng on 15/1/13.
//  Copyright (c) 2015年 etenginfo. All rights reserved.
//

#import "MyInfoViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "SellerModel.h"

@interface MyInfoViewController ()

@end

@implementation MyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化NavigationBar
    [self initNavigationBar];

    //初始化数据
    [self initData];
    
    //初始化视图
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

//初始化数据
-(void)initData
{
    _namelist=@[@"店名：",@"电话：",@"简介：",@"范围：",@"地址："];
    _imageList=@[@"seller_name",@"seller_link_tel",@"seller_detail",@"seller_circle",@"seller_address"];
    
    _hudProgress=[[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_hudProgress];
    
    _myInfoList=[SellerModel getSeller];
}

//初始化视图
-(void)initView
{
    SellerModel *model=[[SellerModel alloc] init];
    if (_myInfoList.count>0) {
        model=_myInfoList[0];
    }
    
    KeyboardToolBar *keyboardTopView =[[KeyboardToolBar alloc] init];
    keyboardTopView.delegateKeyboard=self;
    
    int lefiimageY=40;
    for (int index=0; index<5; index++) {
        UIImageView *leftImage=[[UIImageView alloc] initWithFrame:CGRectMake(35, lefiimageY, 22.57, 22.57)];
        [self.view addSubview:leftImage];
        
        UILabel *leftName=[[UILabel alloc] initWithFrame:CGRectMake(leftImage.frame.size.width+leftImage.frame.origin.x+10, leftImage.frame.origin.y-5, 55, 30)];
        [self.view addSubview:leftName];
        
        UITextView *text=[[UITextView alloc] initWithFrame:CGRectMake(leftName.frame.size.width+leftName.frame.origin.x-10, leftName.frame.origin.y, ScreenWidth-leftName.frame.origin.x-leftName.frame.size.width-20, 30)];
        text.backgroundColor=kUIColorFromRGB(0xeaeaea);
        text.delegate=self;
        text.tag=index+1;
        text.font=[UIFont systemFontOfSize:12.0];
        text.contentInset=UIEdgeInsetsMake(0, 0, 0, 0);
        text.scrollEnabled=YES;
        [text setInputAccessoryView:keyboardTopView];
        if (index==1) {
            text.keyboardType=UIKeyboardTypePhonePad;
        }
        [self.view addSubview:text];
        
        UIImageView *bottomLineImage=[[UIImageView alloc] initWithFrame:CGRectMake(leftName.frame.origin.x-3, text.frame.origin.y+text.frame.size.height+10, ScreenWidth-40-leftName.frame.origin.x, 1)];
        [self.view addSubview:bottomLineImage];
        
        [leftImage setImage:ImageNamed(_imageList[index])];
        leftName.text=_namelist[index];
        [bottomLineImage setImage:ImageNamed(@"remarkline")];
        
        switch (index) {
            case 0:
                text.text=model.seller_name;
                break;
            case 1:
                text.text=model.link_tel;
                break;
            case 2:
                text.text=model.seller_detail;
                break;
            case 3:
                text.text=model.seller_circle;
                break;
            case 4:
                text.text=model.address;
                break;
        }
        
        //自动调整高度
        NSDictionary *attributes = @{NSFontAttributeName:text.font};
        CGSize lblNameFontSize=[text.text boundingRectWithSize:CGSizeMake(text.frame.size.width-10,45) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        
        text.frame=CGRectMake(text.frame.origin.x, text.frame.origin.y, text.frame.size.width, lblNameFontSize.height+10);
        bottomLineImage.frame=CGRectMake(bottomLineImage.frame.origin.x,text.frame.origin.y+text.frame.size.height+10 , bottomLineImage.frame.size.width, bottomLineImage.frame.size.height);
        
        lefiimageY=bottomLineImage.frame.origin.y+20;
    }
    
    UITextView *text=(UITextView *)[self.view viewWithTag:5];
    
    UIButton *btnSave=[[UIButton alloc] initWithFrame:CGRectMake((ScreenWidth-text.frame.size.width)/2, text.frame.size.height+text.frame.origin.y+45, text.frame.size.width, 40)];
    [btnSave setTitle:@"保存" forState:UIControlStateNormal];
    [btnSave setBackgroundImage:ImageNamed(@"btnbg") forState:UIControlStateNormal];
    [btnSave addTarget:self action:@selector(saveSellerInfo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSave];
}

//关闭键盘
- (void)resignKeyboard
{
    for (int index=0; index<5; index++) {
        UITextView *text=(UITextView *)[self.view viewWithTag:index+1];
        [text resignFirstResponder];
    }
    
    self.view.frame=CGRectMake(self.view.frame.origin.x, 64, self.view.frame.size.width, self.view.frame.size.height);
}

//保存我的资料
-(void)saveSellerInfo:(UIButton *) btn
{
    UITextView *text1=(UITextView *)[self.view viewWithTag:1];
    if ([text1.text isEqualToString:@""]) {
        [self alertMessage:@"店名不能为空"];
        return;
    }
    UITextView *text2=(UITextView *)[self.view viewWithTag:2];
    if ([text2.text isEqualToString:@""]) {
        [self alertMessage:@"电话不能为空"];
        return;
    }
    UITextView *text3=(UITextView *)[self.view viewWithTag:3];
    if ([text3.text isEqualToString:@""]) {
        [self alertMessage:@"简介不能为空"];
        return;
    }
    UITextView *text4=(UITextView *)[self.view viewWithTag:4];
    if ([text4.text isEqualToString:@""]) {
        [self alertMessage:@"范围不能为空"];
        return;
    }
    UITextView *text5=(UITextView *)[self.view viewWithTag:5];
    if ([text5.text isEqualToString:@""]) {
        [self alertMessage:@"地址不能为空"];
        return;
    }
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    
    MBProgressHUD *progress=[[MBProgressHUD alloc] initWithView:view];
    [view addSubview:progress];
    progress.labelText=@"正在保存信息...";
    [progress show:YES];
    [self.view addSubview:view];
    
//    _hudProgress.labelText=@"正在保存信息...";
//    [_hudProgress show:YES];
    showNetLogoYES;
    
    AFHTTPRequestOperationManager *httpRequest=[AFHTTPRequestOperationManager manager];
    NSDictionary *parm=[[NSDictionary alloc] initWithObjectsAndKeys:[UserData stringForKey:@"sellerId"],@"sellerId",text1.text,@"sellerName",text2.text,@"linkTel",text3.text,@"sellerDetail",text4.text,@"sellerCircle",text5.text,@"address",nil];
    [httpRequest POST:[HttpUrl stringByAppendingString:@"editSellerInfo"] parameters:parm success:^(AFHTTPRequestOperation *operation,id responseObject){
        
//        [_hudProgress hide:YES];
        [progress hide:YES];
        [view removeFromSuperview];
        showNetLogoNO;
        
        NSDictionary *result=(NSDictionary *)responseObject;
        if ([[result objectForKey:@"code"] isEqualToString:@"0"]) {
            SellerModel *model=[SellerModel SellerModelFromDictionary:[result objectForKey:@"seller"]];
            [SellerModel deleteSeller];
            [SellerModel saveSeller:model];
            
            [self showMsg:@"保存成功"];
        }
        else{
            [self alertMessage:[result objectForKey:@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
//        [_hudProgress hide:YES];
        [progress hide:YES];
        [view removeFromSuperview];
        showNetLogoNO;
        
        [self alertMessage:@"保存失败"];
        NSLog(@"失败：%@",error);
    }];
}

//弹出系统提示框
-(void)alertMessage:(NSString *)msg
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
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

#pragma textview委托
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    CGRect frame = textView.frame;
    
    CGFloat textToView=frame.origin.y+frame.size.height;
    CGFloat keybordToView=self.view.frame.size.height-256.0;
    
    if (textToView>=keybordToView) {
        self.view.frame=CGRectMake(self.view.frame.origin.x, keybordToView-textToView, self.view.frame.size.width, self.view.frame.size.height);
    }

    return YES;
}

@end
