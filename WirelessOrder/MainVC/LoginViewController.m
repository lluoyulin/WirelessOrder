//
//  LoginViewController.m
//  WirelessOrder
//
//  Created by eteng on 15/1/8.
//  Copyright (c) 2015年 etenginfo. All rights reserved.
//

#import "LoginViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "SellerModel.h"
#import "MainViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=kUIColorFromRGB(0xeaeaea);
    self.navigationController.navigationBarHidden=YES;
    
    UIImageView *logoImageView=[[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-61.42)/2, 60, 61.42, 60.85)];
    [logoImageView setImage:[UIImage imageNamed:@"login_logo"]];
    [self.view addSubview:logoImageView];
    
    UITextField *userNameText=[[UITextField alloc] initWithFrame:CGRectMake((ScreenWidth-220)/2, logoImageView.frame.origin.y+logoImageView.frame.size.height+30,220, 40)];
    userNameText.tag=101;
    userNameText.delegate=self;
    userNameText.placeholder=@"账号";
    userNameText.background=[UIImage imageNamed:@"pwd_bg"];
    
    UIImageView *userNameLeftImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35.75, 23.85)];
    [userNameLeftImage setImage:[UIImage imageNamed:@"username_left_bg"]];
    
    userNameText.leftView=userNameLeftImage;
    userNameText.leftViewMode=UITextFieldViewModeAlways;
    userNameText.clearButtonMode=UITextFieldViewModeWhileEditing;
    userNameText.keyboardType=UIKeyboardTypeNamePhonePad;
    [self.view addSubview:userNameText];
    
    UITextField *pwdText=[[UITextField alloc] initWithFrame:CGRectMake(userNameText.frame.origin.x, userNameText.frame.origin.y+userNameText.frame.size.height+10,220, 40)];
    pwdText.tag=102;
    pwdText.placeholder=@"密码";
    pwdText.delegate=self;
    pwdText.background=[UIImage imageNamed:@"pwd_bg"];
    
    UIImageView *pwdLeftImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35.75, 23.85)];
    [pwdLeftImage setImage:[UIImage imageNamed:@"pwd_left_bg"]];
    
    pwdText.leftView=pwdLeftImage;
    pwdText.leftViewMode=UITextFieldViewModeAlways;
    pwdText.clearButtonMode=UITextFieldViewModeWhileEditing;
    pwdText.secureTextEntry=YES;
    [self.view addSubview:pwdText];
    
    UIButton *rememberPwdBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rememberPwdBtn.frame=CGRectMake(pwdText.frame.origin.x+3, pwdText.frame.origin.y+pwdText.frame.size.height+10, 23, 23);
    rememberPwdBtn.tag=103;
    [rememberPwdBtn setImage:[UIImage imageNamed:@"remember_no"] forState:UIControlStateNormal];
    [rememberPwdBtn setImage:[UIImage imageNamed:@"remember_yes"] forState:UIControlStateSelected];
    [rememberPwdBtn addTarget:self action:@selector(pressRememberPwd:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rememberPwdBtn];
    
    UILabel *rememberPwdLbl=[[UILabel alloc] initWithFrame:CGRectMake(rememberPwdBtn.frame.origin.x+rememberPwdBtn.frame.size.width+5, rememberPwdBtn.frame.origin.y, 60, 23)];
    rememberPwdLbl.text=@"记住密码";
    rememberPwdLbl.font=[UIFont systemFontOfSize:14.0];
    [self.view addSubview:rememberPwdLbl];
    
    UIButton *loginBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame=CGRectMake(pwdText.frame.origin.x, rememberPwdBtn.frame.origin.y+rememberPwdBtn.frame.size.height+30, 220, 40);
    [loginBtn setTitle:@"登 录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:kUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"login_bg"] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(pressLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    UILabel *companyNameLbl=[[UILabel alloc] initWithFrame:CGRectMake(loginBtn.frame.origin.x, ScreenHeight-75, 220, 10)];
    companyNameLbl.text=@"贵阳翼腾信息技术有限责任公司";
    companyNameLbl.textAlignment=NSTextAlignmentCenter;
    companyNameLbl.font=[UIFont systemFontOfSize:12.0];
    [self.view addSubview:companyNameLbl];
    
    UILabel *companyNameLbl1=[[UILabel alloc] initWithFrame:CGRectMake(companyNameLbl.frame.origin.x, companyNameLbl.frame.origin.y+companyNameLbl.frame.size.height+5, 220, 10)];
    companyNameLbl1.text=@"版权所有";
    companyNameLbl1.textAlignment=NSTextAlignmentCenter;
    companyNameLbl1.font=[UIFont systemFontOfSize:12.0];
    [self.view addSubview:companyNameLbl1];
    
    UILabel *copyrightLbl=[[UILabel alloc] initWithFrame:CGRectMake(companyNameLbl1.frame.origin.x, companyNameLbl1.frame.origin.y+companyNameLbl1.frame.size.height+10, 220, 18)];
    copyrightLbl.text=@"Copyright 2010-2013";
    copyrightLbl.textAlignment=NSTextAlignmentCenter;
    copyrightLbl.font=[UIFont systemFontOfSize:12.0];
    [self.view addSubview:copyrightLbl];
    
    _progress=[[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_progress];
    _progress.labelText=@"正在登录...";
    
    _userData=[NSUserDefaults standardUserDefaults];
    userNameText.text=[_userData stringForKey:@"username"];
    if (![[_userData stringForKey:@"pwd"] isEqualToString:@""] && [_userData stringForKey:@"pwd"]!=nil) {
        pwdText.text=[_userData stringForKey:@"pwd"];
        rememberPwdBtn.selected=YES;
    }
}

//记住密码
-(void)pressRememberPwd:(UIButton *)btn
{
    if (btn.selected) {
        btn.selected=NO;
    }
    else{
        btn.selected=YES;
    }
}

//登录
-(void)pressLogin:(UIButton *)btn
{
    UITextField *userName=(UITextField *)[self.view viewWithTag:101];
    UITextField *pwd=(UITextField *)[self.view viewWithTag:102];
    
    if ([userName.text isEqualToString:@""]) {
        userName.placeholder=@"账号不能为空";
        [userName becomeFirstResponder];
        return;
    }
    if([pwd.text isEqualToString:@""])
    {
        pwd.placeholder=@"密码不能为空";
        [pwd becomeFirstResponder];
        return;
    }
    [pwd resignFirstResponder];
    
    [_progress show:YES];
    showNetLogoYES;
    AFHTTPRequestOperationManager *httpRequest=[AFHTTPRequestOperationManager manager];
    NSCharacterSet *whitespace =[NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSDictionary *parm=[[NSDictionary alloc] initWithObjectsAndKeys:[userName.text stringByTrimmingCharactersInSet:whitespace],@"account",pwd.text,@"pwd",nil];
    [httpRequest GET:[HttpUrl stringByAppendingString:@"login"] parameters:parm success:^(AFHTTPRequestOperation *operation,id responseObject){
        showNetLogoNO;
        [_progress hide:YES];
        
        NSDictionary *result=(NSDictionary *)responseObject;
        if ([[result objectForKey:@"code"] isEqualToString:@"0"]) {
            SellerModel *model=[SellerModel SellerModelFromDictionary:[result objectForKey:@"seller"]];
//            [SellerModel deleteSeller];
//            [SellerModel saveSeller:model];
            
            [_userData setObject:model.seller_id forKey:@"sellerId"];
            [_userData setObject:userName.text forKey:@"username"];
            
            UIButton *rememberBtn=(UIButton *)[self.view viewWithTag:103];
            if (rememberBtn.selected) {
                [_userData setObject:pwd.text forKey:@"pwd"];
            }
            else{
                [_userData setObject:@"" forKey:@"pwd"];
            }
            
            [_userData synchronize];
            
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            [self showMessage:[result objectForKey:@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        showNetLogoNO;
        [_progress hide:YES];
        [self showMessage:@"登录失败"];
        
        NSLog(@"失败：%@",error);
    }];
}

//提示信息
-(void)showMessage:(NSString *)msg
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self backgroundTap];
}

//轻触背景关闭键盘
-(void)backgroundTap
{
    UITextField *userName=(UITextField *)[self.view viewWithTag:101];
    UITextField *pwd=(UITextField *)[self.view viewWithTag:102];
    
    [userName resignFirstResponder];
    [pwd resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
