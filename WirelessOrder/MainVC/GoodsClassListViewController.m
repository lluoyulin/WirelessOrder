//
//  GoodsClassListViewController.m
//  WirelessOrder
//
//  Created by eteng on 15/1/15.
//  Copyright (c) 2015年 etenginfo. All rights reserved.
//

#import "GoodsClassListViewController.h"
#import "GoodsClassInfoModel.h"
#import "GoodsInfoModel.h"
#import "AFHTTPRequestOperationManager.h"
#import "GoodsListViewController.h"

@interface GoodsClassListViewController ()

@end

@implementation GoodsClassListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化NavigationBar
    [self initNavigationBar];
    
    _isShowPopView=NO;
    
    //初始化表格
    [self initView];
}

//初始化NavigationBar
-(void)initNavigationBar
{
    self.view.backgroundColor=kUIColorFromRGB(0xeaeaea);
    
    UIButton *btnBack=[UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame=CGRectMake(0, (44-36)/2, 50.25, 36);
    [btnBack setAccessibilityValue:@"返回"];
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

//返回
-(void)pressBtnBack:(UIButton *)btn
{
    [_tableView setEditing:NO animated:YES];
    if ([btn.accessibilityValue isEqualToString:@"返回"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [btn setTitle:nil forState:UIControlStateNormal];
        [btn setAccessibilityValue:@"返回"];
        [btn setBackgroundImage:[UIImage imageNamed:@"bluetooth_back"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"bluetooth_back_select"] forState:UIControlStateHighlighted];
        
        UIBarButtonItem *barbtn=self.navigationItem.rightBarButtonItem;
        UIButton *btnAdd=(UIButton *)barbtn.customView;
        [btnAdd setTitle:@"编辑" forState:UIControlStateNormal];
        [btnAdd setAccessibilityValue:@"编辑"];
    }
}

//编辑
-(void)pressBtnAdd:(UIButton *)btn
{
    if ([btn.accessibilityValue isEqualToString:@"编辑"]) {
        [btn setTitle:@"新增" forState:UIControlStateNormal];
        [btn setAccessibilityValue:@"新增"];
        
        UIBarButtonItem *barbtn=self.navigationItem.leftBarButtonItem;
        UIButton *btnBack=(UIButton *)barbtn.customView;
        [btnBack setTitle:@"完成" forState:UIControlStateNormal];
        [btnBack setAccessibilityValue:@"完成"];
        [btnBack setBackgroundImage:nil forState:UIControlStateNormal];
        [btnBack setBackgroundImage:nil forState:UIControlStateHighlighted];
        
        [_tableView setEditing:YES animated:YES];
    }
    else{
        if(_isShowPopView)
        {
            return;
        }
        
        _isShowPopView=YES;
        
        KeyboardToolBar *keyboard =[[KeyboardToolBar alloc] init];
        keyboard.delegateKeyboard=self;
        
        UIView *popView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        popView.tag=101;
        popView.backgroundColor=[[UIColor alloc] initWithPatternImage:ImageNamed(@"pop_bg")];
        [self.view addSubview:popView];
        
        UIImageView *contentImage=[[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-240)/2, 90, 240, 127)];
        contentImage.tag=201;
        contentImage.userInteractionEnabled=YES;
        [contentImage setImage:ImageNamed(@"pop_content_bg")];
        [popView addSubview:contentImage];
        
        UILabel *titleLbl=[[UILabel alloc] initWithFrame:CGRectMake((contentImage.frame.size.width-140)/2, 10, 140, 30)];
        titleLbl.text=@"输入菜品种类名称";
        [contentImage addSubview:titleLbl];
        
        UIImageView *lineImage1=[[UIImageView alloc] initWithFrame:CGRectMake(0, titleLbl.frame.origin.y+titleLbl.frame.size.height, contentImage.frame.size.width, 1)];
        [lineImage1 setImage:ImageNamed(@"remarkline")];
        [contentImage addSubview:lineImage1];
        
        UITextField *textName=[[UITextField alloc] initWithFrame:CGRectMake((contentImage.frame.size.width-210)/2, lineImage1.frame.origin.y+lineImage1.frame.size.height+10, 210, 30)];
        textName.tag=301;
        textName.placeholder=@"种类名称";
        textName.clearButtonMode=UITextFieldViewModeWhileEditing;
        textName.borderStyle = UITextBorderStyleRoundedRect;
        textName.inputAccessoryView=keyboard;
        textName.delegate=self;
        [contentImage addSubview:textName];
        
//        UISwitch *switchPrint=[[UISwitch alloc] initWithFrame:CGRectMake(0,0, 0, 0)];
//        switchPrint.onTintColor=kUIColorFromRGB(0xf33637);
//        switchPrint.tintColor=kUIColorFromRGB(0xaeaeae);
//        [switchPrint addTarget:self action:@selector(pressSwitch:) forControlEvents:UIControlEventValueChanged];
        
        UIImageView *lineImage2=[[UIImageView alloc] initWithFrame:CGRectMake(0, textName.frame.origin.y+textName.frame.size.height+10, contentImage.frame.size.width, 1)];
        [lineImage2 setImage:ImageNamed(@"remarkline")];
        [contentImage addSubview:lineImage2];
        
        UIButton *cancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame=CGRectMake(0, lineImage2.frame.origin.y+lineImage2.frame.size.height, contentImage.frame.size.width/2-0.5, 35);
        cancelBtn.tag=302;
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [cancelBtn setBackgroundImage:ImageNamed(@"pop_left_select") forState:UIControlStateHighlighted];
        [cancelBtn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
        [contentImage addSubview:cancelBtn];
        
        UIImageView *lineImage3=[[UIImageView alloc] initWithFrame:CGRectMake(cancelBtn.frame.size.width,cancelBtn.frame.origin.y,1,35)];
        [lineImage3 setImage:ImageNamed(@"pop_line")];
        [contentImage addSubview:lineImage3];
        
        UIButton *submitBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        submitBtn.frame=CGRectMake(contentImage.frame.size.width/2+0.5, lineImage2.frame.origin.y+lineImage2.frame.size.height, contentImage.frame.size.width/2-0.5, 35);
        submitBtn.tag=303;
        [submitBtn setTitle:@"确定" forState:UIControlStateNormal];
        [submitBtn setTitleColor:kUIColorFromRGB(0xf33737) forState:UIControlStateNormal];
        [submitBtn setBackgroundImage:ImageNamed(@"pop_right_select") forState:UIControlStateHighlighted];
        [submitBtn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
        [contentImage addSubview:submitBtn];
        
        popView.transform=CGAffineTransformMakeScale(0.01, 0.01);
        [UIView animateWithDuration:0.4 animations:^{
            popView.transform=CGAffineTransformMakeScale(1.0, 1.0);
        }];
    }
}

//初始化表格
-(void)initView
{
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-20-44)];
    _tableView.backgroundColor=kUIColorFromRGB(0xeaeaea);
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
}

//关闭键盘
- (void)resignKeyboard
{
    UIView *popView=(UIView *)[self.view viewWithTag:101];
    UIImageView *contentImage=(UIImageView *)[popView viewWithTag:201];
    UITextField *textName=(UITextField *)[contentImage viewWithTag:301];
    [textName resignFirstResponder];
    
    CGRect rect = CGRectMake((ScreenWidth-240)/2, 90, contentImage.frame.size.width, contentImage.frame.size.height);
    contentImage.frame = rect;
}

//是否粉面按钮
-(void)pressSwitch:(UISwitch *)switchPrint
{
    if ([switchPrint isOn]) {
        
    }
    else{
        
    }
}

//pop里button点击
-(void)pressBtn:(UIButton *)btn
{
    UIView *popView=(UIView *)[self.view viewWithTag:101];

    if (btn.tag==302) {//取消
        [UIView animateWithDuration:0.4 animations:^{
            popView.transform=CGAffineTransformMakeScale(0.01, 0.01);
        } completion:^(BOOL finished){
            if (finished) {
                [popView removeFromSuperview];
                _isShowPopView=NO;
            }
        }];
    }
    else{
        UIImageView *contentImage=(UIImageView *)[popView viewWithTag:201];
        UITextField *textName=(UITextField *)[contentImage viewWithTag:301];
        NSCharacterSet *whitespace =[NSCharacterSet whitespaceAndNewlineCharacterSet];
        
        if ([[textName.text stringByTrimmingCharactersInSet:whitespace] isEqualToString:@""]) {
            textName.placeholder=@"不能为空";
            [textName becomeFirstResponder];
            return;
        }
        
        _hudProgress=[[MBProgressHUD alloc] initWithView:popView];
        [popView addSubview:_hudProgress];
        _hudProgress.labelText=@"正在提交菜品类目...";
        [_hudProgress show:YES];
        showNetLogoYES;
        
        AFHTTPRequestOperationManager *httpRequest=[AFHTTPRequestOperationManager manager];
        NSDictionary *parm=[[NSDictionary alloc] initWithObjectsAndKeys:[UserData stringForKey:@"sellerId"],@"sellerId",[textName.text stringByTrimmingCharactersInSet:whitespace],@"className",nil];
        [httpRequest POST:[HttpUrl stringByAppendingString:@"addClassBySellerId"] parameters:parm success:^(AFHTTPRequestOperation *operation,id responseObject){
            
            [_hudProgress hide:YES];
            [_hudProgress removeFromSuperview];
            _hudProgress=nil;
            showNetLogoNO;
            _isShowPopView=NO;
            
            NSDictionary *result=(NSDictionary *)responseObject;
            if ([[result objectForKey:@"code"] isEqualToString:@"0"]) {
                GoodsClassInfoModel *model=[GoodsClassInfoModel GoodsClassModelFromDictionary:[result objectForKey:@"goodsClass"]];
                [GoodsClassInfoModel saveGoodsClass:model];
                [_goodsClassList addObject:model];
                [_tableView reloadData];
                
                [UIView animateWithDuration:0.4 animations:^{
                    popView.transform=CGAffineTransformMakeScale(0.01, 0.01);
                } completion:^(BOOL finished){
                    if (finished) {
                        [popView removeFromSuperview];
                    }
                }];
                
                [self showMsg:@"提交成功"];
            }
            else{
                [self alertMessage:[result objectForKey:@"msg"]];
            }
        } failure:^(AFHTTPRequestOperation *operation,NSError *error){
            [_hudProgress hide:YES];
            [_hudProgress removeFromSuperview];
            _hudProgress=nil;
            showNetLogoNO;
            _isShowPopView=NO;
            
            [self alertMessage:@"提交失败"];
            NSLog(@"失败：%@",error);
        }];
    }
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _goodsClassList=[GoodsClassInfoModel getAllGoodsClass:nil];
    [_tableView reloadData];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIView *popView=(UIView *)[self.view viewWithTag:101];
    UIImageView *contentImage=(UIImageView *)[popView viewWithTag:201];
    CGRect frame = textField.frame;
    
//    CGFloat textToView=popView.frame.size.height-contentImage.frame.size.height-frame.origin.y-frame.size.height;
    CGFloat textToView=contentImage.frame.origin.y+frame.origin.y+frame.size.height+frame.origin.y+frame.size.height;
    CGFloat keybordToView=popView.frame.size.height-256.0;
    
    if (textToView>=keybordToView) {
        contentImage.frame=CGRectMake(contentImage.frame.origin.x, textToView-keybordToView, contentImage.frame.size.width, contentImage.frame.size.height);
    }
}

#pragma tableview委托
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionte
{
    return _goodsClassList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:TableViewCellIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableViewCellIdentifier];
    }
    
    GoodsClassInfoModel *model=_goodsClassList[indexPath.row];
    cell.textLabel.text=model.class_name;
    cell.backgroundColor=kUIColorFromRGB(0xeaeaea);
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsClassInfoModel *model=_goodsClassList[indexPath.row];
    GoodsListViewController *goodsListVC=[[GoodsListViewController alloc] init];
    goodsListVC.title=model.class_name;
    goodsListVC.goodsclassid=model.class_id;
    [self.navigationController pushViewController:goodsListVC animated:YES];
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete) {//上、下架
        int state=1;//上架
        GoodsClassInfoModel *model=_goodsClassList[indexPath.row];
        if ([model.class_status isEqualToString:@"1"]) {//下架
            state=0;
        }
    
        _hudProgress=[[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_hudProgress];
        
        _hudProgress.labelText=@"正在提交数据...";
        [_hudProgress show:YES];
        showNetLogoYES;
        
        AFHTTPRequestOperationManager *httpRequest=[AFHTTPRequestOperationManager manager];
        NSDictionary *parm=[[NSDictionary alloc] initWithObjectsAndKeys:[UserData stringForKey:@"sellerId"],@"sellerId",@"2",@"type",model.class_id,@"classId",[NSString stringWithFormat:@"%d",state],@"status",nil];
        [httpRequest GET:[HttpUrl stringByAppendingString:@"changeObjectState"] parameters:parm success:^(AFHTTPRequestOperation *operation,id responseObject){
            
            [_hudProgress hide:YES];
            [_hudProgress removeFromSuperview];
            _hudProgress=nil;
            showNetLogoNO;
            
            NSDictionary *result=(NSDictionary *)responseObject;
            if ([[result objectForKey:@"code"] isEqualToString:@"0"]) {
                [GoodsClassInfoModel updateGoodsClassStatus:[NSString stringWithFormat:@"%d",state] class_id:model.class_id];
                if (state==1) {//上架
                    [self showMsg:@"上架成功"];
                }
                else{//下架
                    [self showMsg:@"下架成功"];
                }
                _goodsClassList=[GoodsClassInfoModel getAllGoodsClass:nil];
                [_tableView reloadData];
            }
            else{
                [self alertMessage:[result objectForKey:@"msg"]];
            }
        } failure:^(AFHTTPRequestOperation *operation,NSError *error){
            [_hudProgress hide:YES];
            [_hudProgress removeFromSuperview];
            _hudProgress=nil;
            showNetLogoNO;
            
            [self alertMessage:@"提交失败"];
            NSLog(@"失败：%@",error);
        }];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsClassInfoModel *model=_goodsClassList[indexPath.row];
    if ([model.class_status isEqualToString:@"1"]) {
        return @"下架";
    }
    else
    {
        return @"上架";
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    GoodsClassInfoModel *fromModel=_goodsClassList[sourceIndexPath.row];
    GoodsClassInfoModel *toModel=_goodsClassList[destinationIndexPath.row];
    
    if ([fromModel.class_id isEqualToString:toModel.class_id]) {
        return;
    }
    
    _hudProgress=[[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_hudProgress];
    
    _hudProgress.labelText=@"正在提交数据...";
    [_hudProgress show:YES];
    showNetLogoYES;
    
    AFHTTPRequestOperationManager *httpRequest=[AFHTTPRequestOperationManager manager];
    NSDictionary *parm=[[NSDictionary alloc] initWithObjectsAndKeys:fromModel.class_id,@"downClassId",fromModel.class_sort,@"downClassOrder",toModel.class_id,@"upClassId",toModel.class_sort,@"upClassOrder",nil];
    [httpRequest GET:[HttpUrl stringByAppendingString:@"changeClassOrder"] parameters:parm success:^(AFHTTPRequestOperation *operation,id responseObject){
        
        [_hudProgress hide:YES];
        [_hudProgress removeFromSuperview];
        _hudProgress=nil;
        showNetLogoNO;
        
        NSDictionary *result=(NSDictionary *)responseObject;
        if ([[result objectForKey:@"code"] isEqualToString:@"0"]) {
            [GoodsClassInfoModel updateGoodsClassSort:fromModel.class_sort class_id:toModel.class_id];
            [GoodsClassInfoModel updateGoodsClassSort:toModel.class_sort class_id:fromModel.class_id];
            
            _goodsClassList=[GoodsClassInfoModel getAllGoodsClass:nil];
            [_tableView reloadData];
            
            [self showMsg:@"排序成功"];
        }
        else{
            [self alertMessage:[result objectForKey:@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [_hudProgress hide:YES];
        [_hudProgress removeFromSuperview];
        _hudProgress=nil;
        showNetLogoNO;
        
        [self alertMessage:@"提交失败"];
        NSLog(@"失败：%@",error);
    }];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

@end
