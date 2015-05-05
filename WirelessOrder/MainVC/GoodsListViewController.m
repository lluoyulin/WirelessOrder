//
//  GoodsListViewController.m
//  WirelessOrder
//
//  Created by eteng on 15/1/16.
//  Copyright (c) 2015年 etenginfo. All rights reserved.
//

#import "GoodsListViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "GoodsCellTableViewCell.h"
#import "GoodsInfoModel.h"
#import "GoodsClassInfoModel.h"
#import "AddGoodsViewController.h"

@interface GoodsListViewController ()

@end

@implementation GoodsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化NavigationBar
    [self initNavigationBar];
    
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
    [btnAdd addTarget:self action:@selector(pressBtnEdit:) forControlEvents:UIControlEventTouchUpInside];
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
-(void)pressBtnEdit:(UIButton *)btn
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
        AddGoodsViewController *addGoodsVC=[[AddGoodsViewController alloc] init];
        addGoodsVC.title=[NSString stringWithFormat:@"添加%@",self.title];
        addGoodsVC.goodsclassid=self.goodsclassid;
        [self.navigationController pushViewController:addGoodsVC animated:YES];
    }
}

//初始化表格
-(void)initView
{
    UIView *topView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 54)];
    topView.backgroundColor=kUIColorFromRGB(0xffffff);
    
    UIImageView *topLineImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, topView.frame.size.width, 1)];
    [topLineImage setImage:ImageNamed(@"remarkline")];
    [topView addSubview:topLineImage];
    
    UIImageView *bottomLineImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, topView.frame.size.height-1, topView.frame.size.width, 1)];
    [bottomLineImage setImage:ImageNamed(@"remarkline")];
    [topView addSubview:bottomLineImage];
    
    UIButton *redBorderBtn=[[UIButton alloc] initWithFrame:CGRectMake(15, (topView.frame.size.height-30)/2,topView.frame.size.width-30 , 30)];
    redBorderBtn.tag=2001;
    [redBorderBtn setBackgroundImage:ImageNamed(@"red_ border") forState:UIControlStateNormal];
    [redBorderBtn addTarget:self action:@selector(pressBtnGoodsName:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:redBorderBtn];
    
    UILabel *goodsNameLbl=[[UILabel alloc] initWithFrame:CGRectMake(10, (redBorderBtn.frame.size.height-20)/2, 70, 20)];
    goodsNameLbl.text=@"菜品类目";
    [redBorderBtn addSubview:goodsNameLbl];
    
    UILabel *goodsNameValueLbl=[[UILabel alloc] initWithFrame:CGRectMake(redBorderBtn.frame.size.width-10-70, (redBorderBtn.frame.size.height-20)/2, 70, 20)];
    goodsNameValueLbl.tag=3001;
    goodsNameValueLbl.text=self.title;
    
    CGSize size=[self CalculationSize:goodsNameValueLbl.font text:goodsNameValueLbl.text];
    goodsNameValueLbl.frame=CGRectMake(redBorderBtn.frame.size.width-10-size.width, goodsNameValueLbl.frame.origin.y, size.width, goodsNameValueLbl.frame.size.height);
    
    [redBorderBtn addSubview:goodsNameValueLbl];
    
    [_tableView registerClass:[GoodsCellTableViewCell class] forCellReuseIdentifier:TableViewCellIdentifier];
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-20)];
    _tableView.backgroundColor=kUIColorFromRGB(0xeaeaea);
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView=topView;
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

//点击顶部菜品类目
-(void)pressBtnGoodsName:(UIButton *)btn
{
    KeyboardToolBar *keyboardTopView =[[KeyboardToolBar alloc] init];
    keyboardTopView.delegateKeyboard=self;
    
    UIView *popView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight+10)];
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
    textName.placeholder=self.title;
    textName.clearButtonMode=UITextFieldViewModeWhileEditing;
    textName.borderStyle = UITextBorderStyleRoundedRect;
    textName.inputAccessoryView=keyboardTopView;
    textName.delegate=self;
    [contentImage addSubview:textName];
    
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
        NSDictionary *parm=[[NSDictionary alloc] initWithObjectsAndKeys:self.goodsclassid,@"classId",[textName.text stringByTrimmingCharactersInSet:whitespace],@"className",[UserData stringForKey:@"sellerId"],@"sellerId",nil];
        [httpRequest GET:[HttpUrl stringByAppendingString:@"updateClassNameById"] parameters:parm success:^(AFHTTPRequestOperation *operation,id responseObject){
            
            [_hudProgress hide:YES];
            [_hudProgress removeFromSuperview];
            _hudProgress=nil;
            showNetLogoNO;
            
            NSDictionary *result=(NSDictionary *)responseObject;
            if ([[result objectForKey:@"code"] isEqualToString:@"0"]) {
                [GoodsClassInfoModel updateGoodsClassName:textName.text class_id:self.goodsclassid];
                
                UIView *topView=_tableView.tableHeaderView;
                UIButton *redBorderBtn=(UIButton *)[topView viewWithTag:2001];
                UILabel *goodsNameValueLbl=(UILabel *)[redBorderBtn viewWithTag:3001];
                
                goodsNameValueLbl.text=textName.text;
                CGSize size=[self CalculationSize:goodsNameValueLbl.font text:goodsNameValueLbl.text];
                goodsNameValueLbl.frame=CGRectMake(redBorderBtn.frame.size.width-10-size.width, goodsNameValueLbl.frame.origin.y, size.width, goodsNameValueLbl.frame.size.height);
                
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
            
            [self alertMessage:@"提交失败"];
            NSLog(@"失败：%@",error);
        }];
    }
}

-(CGSize)CalculationSize:(UIFont *)font text:(NSString *)text
{
    //自动调整高度
    NSDictionary *attributes = @{NSFontAttributeName:font};
    
    CGSize lblFontSize=[text boundingRectWithSize:CGSizeMake(200,30) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    return lblFontSize;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _goodsList=[GoodsInfoModel getAllGoods:[NSString stringWithFormat:@"goods_class='%@'",self.goodsclassid]];
    [_tableView reloadData];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIView *popView=(UIView *)[self.view viewWithTag:101];
    UIImageView *contentImage=(UIImageView *)[popView viewWithTag:201];
    CGRect frame = textField.frame;
    
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
    return _goodsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsCellTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:TableViewCellIdentifier];
    if (cell==nil) {
        cell=[[GoodsCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableViewCellIdentifier];
    }
    
    cell.model=_goodsList[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete) {//删除
        GoodsInfoModel *model=_goodsList[indexPath.row];
        
        _hudProgress=[[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_hudProgress];
        _hudProgress.labelText=@"正在提交数据...";
        [_hudProgress show:YES];
        showNetLogoYES;
        
        AFHTTPRequestOperationManager *httpRequest=[AFHTTPRequestOperationManager manager];
        NSDictionary *parm=[[NSDictionary alloc] initWithObjectsAndKeys:model.goods_id,@"goodsId",nil];
        [httpRequest GET:[HttpUrl stringByAppendingString:@"deleteGoods"] parameters:parm success:^(AFHTTPRequestOperation *operation,id responseObject){
            
            [_hudProgress hide:YES];
            [_hudProgress removeFromSuperview];
            _hudProgress=nil;
            showNetLogoNO;
            
            NSDictionary *result=(NSDictionary *)responseObject;
            if ([[result objectForKey:@"code"] isEqualToString:@"0"]) {
                [GoodsInfoModel deleteAllGoods:[NSString stringWithFormat:@"goods_id='%@'",model.goods_id]];
                
                _goodsList=[GoodsInfoModel getAllGoods:[NSString stringWithFormat:@"goods_class='%@'",self.goodsclassid]];
                [_tableView reloadData];
                
                [self showMsg:@"删除成功"];
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
    return @"删除";
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    GoodsInfoModel *fromModel=_goodsList[sourceIndexPath.row];
    GoodsInfoModel *toModel=_goodsList[destinationIndexPath.row];
    
    if ([fromModel.goods_id isEqualToString:toModel.goods_id]) {
        return;
    }
    
    _hudProgress=[[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_hudProgress];
    
    _hudProgress.labelText=@"正在提交数据...";
    [_hudProgress show:YES];
    showNetLogoYES;
    
    AFHTTPRequestOperationManager *httpRequest=[AFHTTPRequestOperationManager manager];
    NSDictionary *parm=[[NSDictionary alloc] initWithObjectsAndKeys:fromModel.goods_id,@"downGoodsId",fromModel.goods_sort,@"downGoodsOrder",toModel.goods_id,@"upGoodsId",toModel.goods_sort,@"upGoodsOrder",nil];
    [httpRequest GET:[HttpUrl stringByAppendingString:@"changeGoodsOrder"] parameters:parm success:^(AFHTTPRequestOperation *operation,id responseObject){
        
        [_hudProgress hide:YES];
        [_hudProgress removeFromSuperview];
        _hudProgress=nil;
        showNetLogoNO;
        
        NSDictionary *result=(NSDictionary *)responseObject;
        if ([[result objectForKey:@"code"] isEqualToString:@"0"]) {
            [GoodsInfoModel updateGoodsSort:toModel.goods_sort goods_id:fromModel.goods_id];
            [GoodsInfoModel updateGoodsSort:fromModel.goods_sort goods_id:toModel.goods_id];
            
            _goodsList=[GoodsInfoModel getAllGoods:[NSString stringWithFormat:@"goods_class='%@'",self.goodsclassid]];
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
