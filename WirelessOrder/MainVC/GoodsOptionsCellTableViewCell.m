//
//  GoodsOptionsCellTableViewCell.m
//  WirelessOrder
//
//  Created by eteng on 15/1/20.
//  Copyright (c) 2015年 etenginfo. All rights reserved.
//

#import "GoodsOptionsCellTableViewCell.h"
#import "SellerOptionsInfoModel.h"
#import "AFHTTPRequestOperationManager.h"


@implementation GoodsOptionsCellTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initCustomCell];
    }
    return self;
}

-(void)initCustomCell
{
    _bottomLineImage=[[UIImageView alloc] init];
    [self.contentView addSubview:_bottomLineImage];
    
    _goodsClassLbl=[[UILabel alloc] init];
    [self.contentView addSubview:_goodsClassLbl];
    
    _options1=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_options1];
    
    _options2=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_options2];
    
    _options3=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_options3];
    
    _options4=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_options4];
    
    _options5=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_options5];
    
    _options6=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_options6];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundColor=kUIColorFromRGB(0xffffff);
    
    _optionsList=[SellerOptionsInfoModel getAllSellerOptions:[NSString stringWithFormat:@"class_id='%@'",self.goodsClassModel.class_id]];
    
    _bottomLineImage.frame=CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1);
    [_bottomLineImage setImage:ImageNamed(@"remarkline")];
    
    _goodsClassLbl.frame=CGRectMake(20, 8, 150, 30);
    _goodsClassLbl.text=self.goodsClassModel.class_name;
    _goodsClassLbl.textColor=kUIColorFromRGB(0xf33637);
    _goodsClassLbl.font=[UIFont systemFontOfSize:20.0];
    
    _options1.frame=CGRectMake(10, _goodsClassLbl.frame.size.height+_goodsClassLbl.frame.origin.y+7, (self.frame.size.width-20-50)/6.0, 25);
    [_options1 setTitleColor:kUIColorFromRGB(0x504f4f) forState:UIControlStateNormal];
    [_options1 setTitle:@"" forState:UIControlStateNormal];
    [_options1 setAccessibilityValue:@"999"];
    [_options1 setBackgroundImage:ImageNamed(@"options_bg") forState:UIControlStateNormal];
    [_options1 addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    _options2.frame=CGRectMake(_options1.frame.origin.x+_options1.frame.size.width+10, _options1.frame.origin.y, _options1.frame.size.width, 25);
    [_options2 setTitleColor:kUIColorFromRGB(0x504f4f) forState:UIControlStateNormal];
    [_options2 setTitle:@"" forState:UIControlStateNormal];
     [_options2 setAccessibilityValue:@"999"];
    [_options2 setBackgroundImage:ImageNamed(@"options_bg") forState:UIControlStateNormal];
    [_options2 addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    _options3.frame=CGRectMake(_options2.frame.origin.x+_options2.frame.size.width+10, _options1.frame.origin.y, _options1.frame.size.width, 25);
    [_options3 setTitleColor:kUIColorFromRGB(0x504f4f) forState:UIControlStateNormal];
    [_options3 setAccessibilityValue:@"999"];
    [_options3 setTitle:@"" forState:UIControlStateNormal];
    [_options3 setBackgroundImage:ImageNamed(@"options_bg") forState:UIControlStateNormal];
    [_options3 addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    _options4.frame=CGRectMake(_options3.frame.origin.x+_options3.frame.size.width+10, _options1.frame.origin.y, _options1.frame.size.width, 25);
    [_options4 setTitleColor:kUIColorFromRGB(0x504f4f) forState:UIControlStateNormal];
    [_options4 setAccessibilityValue:@"999"];
    [_options4 setBackgroundImage:ImageNamed(@"options_bg") forState:UIControlStateNormal];
    [_options4 setTitle:@"" forState:UIControlStateNormal];
    [_options4 addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    _options5.frame=CGRectMake(_options4.frame.origin.x+_options4.frame.size.width+10, _options1.frame.origin.y, _options1.frame.size.width, 25);
    [_options5 setTitleColor:kUIColorFromRGB(0x504f4f) forState:UIControlStateNormal];
    [_options5 setTitle:@"" forState:UIControlStateNormal];
    [_options5 setAccessibilityValue:@"999"];
    [_options5 setBackgroundImage:ImageNamed(@"options_bg") forState:UIControlStateNormal];
    [_options5 addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    _options6.frame=CGRectMake(_options5.frame.origin.x+_options5.frame.size.width+10, _options1.frame.origin.y, _options1.frame.size.width, 25);
    [_options6 setTitleColor:kUIColorFromRGB(0x504f4f) forState:UIControlStateNormal];
    [_options6 setTitle:@"" forState:UIControlStateNormal];
    [_options6 setAccessibilityValue:@"999"];
    [_options6 setBackgroundImage:ImageNamed(@"options_bg") forState:UIControlStateNormal];
    [_options6 addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    for (int index=0; index<_optionsList.count; index++) {
        SellerOptionsInfoModel *model=_optionsList[index];
        switch (index) {
            case 0:
                [_options1 setTitle:model.option_name forState:UIControlStateNormal];
                [_options1 setAccessibilityValue:[NSString stringWithFormat:@"%d",index]];
                break;
            case 1:
                [_options2 setTitle:model.option_name forState:UIControlStateNormal];
                [_options2 setAccessibilityValue:[NSString stringWithFormat:@"%d",index]];
                break;
            case 2:
                [_options3 setTitle:model.option_name forState:UIControlStateNormal];
                [_options3 setAccessibilityValue:[NSString stringWithFormat:@"%d",index]];
                break;
            case 3:
                [_options4 setTitle:model.option_name forState:UIControlStateNormal];
                [_options4 setAccessibilityValue:[NSString stringWithFormat:@"%d",index]];
                break;
            case 4:
                [_options5 setTitle:model.option_name forState:UIControlStateNormal];
                [_options5 setAccessibilityValue:[NSString stringWithFormat:@"%d",index]];
                break;
            case 5:
                [_options6 setTitle:model.option_name forState:UIControlStateNormal];
                [_options6 setAccessibilityValue:[NSString stringWithFormat:@"%d",index]];
                break;
        }
    }
}

-(void)pressBtn:(UIButton *)btn
{
    KeyboardToolBar *keyboard =[[KeyboardToolBar alloc] init];
    keyboard.delegateKeyboard=self;
    
    UIView *popView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight+10)];
    popView.tag=101;
    popView.backgroundColor=[[UIColor alloc] initWithPatternImage:ImageNamed(@"pop_bg")];
    [self.superview.superview addSubview:popView];
    
    UIImageView *contentImage=[[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-240)/2, 90, 240, 127)];
    contentImage.tag=201;
    contentImage.userInteractionEnabled=YES;
    [contentImage setImage:ImageNamed(@"pop_content_bg")];
    [popView addSubview:contentImage];
    
    UILabel *titleLbl=[[UILabel alloc] initWithFrame:CGRectMake((contentImage.frame.size.width-140)/2, 10, 140, 30)];
    titleLbl.text=[NSString stringWithFormat:@"%@备注",self.goodsClassModel.class_name];
    [contentImage addSubview:titleLbl];
    
    CGSize size=[self CalculationSize:titleLbl.font text:titleLbl.text];
    titleLbl.frame=CGRectMake((contentImage.frame.size.width-size.width)/2, titleLbl.frame.origin.y, size.width, titleLbl.frame.size.height);
    
    UIImageView *lineImage1=[[UIImageView alloc] initWithFrame:CGRectMake(0, titleLbl.frame.origin.y+titleLbl.frame.size.height, contentImage.frame.size.width, 1)];
    [lineImage1 setImage:ImageNamed(@"remarkline")];
    [contentImage addSubview:lineImage1];
    
    SellerOptionsInfoModel *model=[[SellerOptionsInfoModel alloc] init];
    
    UITextField *textName=[[UITextField alloc] initWithFrame:CGRectMake((contentImage.frame.size.width-210)/2, lineImage1.frame.origin.y+lineImage1.frame.size.height+10, 210, 30)];
    textName.tag=301;
    if ([btn.accessibilityValue isEqualToString:@"999"]) {
        textName.placeholder=@"输入备注";
    }
    else{
        if ([btn.accessibilityValue intValue]<_optionsList.count) {
            model=_optionsList[[btn.accessibilityValue intValue]];
            textName.placeholder=model.option_name;
        }
        else{
            textName.placeholder=@"为空代表删除";
        }
    }
    textName.clearButtonMode=UITextFieldViewModeWhileEditing;
    textName.borderStyle = UITextBorderStyleRoundedRect;
    textName.inputAccessoryView=keyboard;
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
    [cancelBtn addTarget:self action:@selector(pressPopBtn:) forControlEvents:UIControlEventTouchUpInside];
    [contentImage addSubview:cancelBtn];
    
    UIImageView *lineImage3=[[UIImageView alloc] initWithFrame:CGRectMake(cancelBtn.frame.size.width,cancelBtn.frame.origin.y,1,35)];
    [lineImage3 setImage:ImageNamed(@"pop_line")];
    [contentImage addSubview:lineImage3];
    
    UIButton *submitBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame=CGRectMake(contentImage.frame.size.width/2+0.5, lineImage2.frame.origin.y+lineImage2.frame.size.height, contentImage.frame.size.width/2-0.5, 35);
    submitBtn.tag=303;
    if (model.op_id==nil) {
        [submitBtn setAccessibilityValue:@"00"];
    }
    else{
          [submitBtn setAccessibilityValue:model.op_id];
    }
    [submitBtn setTitle:@"确定" forState:UIControlStateNormal];
    [submitBtn setTitleColor:kUIColorFromRGB(0xf33737) forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:ImageNamed(@"pop_right_select") forState:UIControlStateHighlighted];
    [submitBtn addTarget:self action:@selector(pressPopBtn:) forControlEvents:UIControlEventTouchUpInside];
    [contentImage addSubview:submitBtn];

    popView.transform=CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.4 animations:^{
        popView.transform=CGAffineTransformMakeScale(1.0, 1.0);
    }];
}

-(CGSize)CalculationSize:(UIFont *)font text:(NSString *)text
{
    //自动调整高度
    NSDictionary *attributes = @{NSFontAttributeName:font};
    
    CGSize lblFontSize=[text boundingRectWithSize:CGSizeMake(200,30) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    return lblFontSize;
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
    _hudShowMsg=[[MBProgressHUD alloc] initWithView:[self.superview superview]];
    [[self.superview superview] addSubview:_hudShowMsg];
    
    _hudShowMsg.labelText=msg;
    _hudShowMsg.mode=MBProgressHUDModeText;
    
    [_hudShowMsg showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    } completionBlock:^{
        [_hudShowMsg removeFromSuperview];
        _hudShowMsg=nil;
    }];
}

//关闭键盘
- (void)resignKeyboard
{
    UIView *popView=(UIView *)[self.superview.superview viewWithTag:101];
    UIImageView *contentImage=(UIImageView *)[popView viewWithTag:201];
    UITextField *textName=(UITextField *)[contentImage viewWithTag:301];
    [textName resignFirstResponder];
    
    CGRect rect = CGRectMake((ScreenWidth-240)/2, 90, contentImage.frame.size.width, contentImage.frame.size.height);
    contentImage.frame = rect;
}

//pop里button点击
-(void)pressPopBtn:(UIButton *)btn
{
    UIView *popView=(UIView *)[self.superview.superview viewWithTag:101];
    
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
        
        if ([btn.accessibilityValue isEqualToString:@"00"]) {
            if ([[textName.text stringByTrimmingCharactersInSet:whitespace] isEqualToString:@""]) {
                textName.text=@"";
                textName.placeholder=@"输入备注";
                [textName becomeFirstResponder];
                return;
            }
        }
        
        if (textName.text.length>2) {
            textName.text=@"";
            textName.placeholder=@"只能输入两个字";
            [textName becomeFirstResponder];
            return;
        }
        
        _hudProgress=[[MBProgressHUD alloc] initWithView:self.superview.superview];
        [self.superview.superview addSubview:_hudProgress];
        _hudProgress.labelText=@"正在提交数据...";
        [_hudProgress show:YES];
        showNetLogoYES;
        
        if ([btn.accessibilityValue isEqualToString:@"00"]) {//新增
            AFHTTPRequestOperationManager *httpRequest=[AFHTTPRequestOperationManager manager];
            NSDictionary *parm=[[NSDictionary alloc] initWithObjectsAndKeys:[textName.text stringByTrimmingCharactersInSet:whitespace],@"optionName",[UserData stringForKey:@"sellerId"],@"sellerId",self.goodsClassModel.class_id,@"classId",nil];
            [httpRequest POST:[HttpUrl stringByAppendingString:@"addClassOption"] parameters:parm success:^(AFHTTPRequestOperation *operation,id responseObject){
                
                [_hudProgress hide:YES];
                [_hudProgress removeFromSuperview];
                _hudProgress=nil;
                showNetLogoNO;
                
                NSDictionary *result=(NSDictionary *)responseObject;
                if ([[result objectForKey:@"code"] isEqualToString:@"0"]) {
                    [SellerOptionsInfoModel saveSellerOptions:[SellerOptionsInfoModel SellerOptionsInfoModelFromDictionary:[result objectForKey:@"options"]]];
                    
                    [self layoutSubviews];
                    
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
        else{//修改或删除
            AFHTTPRequestOperationManager *httpRequest=[AFHTTPRequestOperationManager manager];
            NSDictionary *parm=[[NSDictionary alloc] initWithObjectsAndKeys:[textName.text stringByTrimmingCharactersInSet:whitespace],@"optionName",btn.accessibilityValue,@"id",[UserData stringForKey:@"sellerId"],@"sellerId",self.goodsClassModel.class_id,@"classId",nil];
            [httpRequest GET:[HttpUrl stringByAppendingString:@"updateOrDeleteOptions"] parameters:parm success:^(AFHTTPRequestOperation *operation,id responseObject){
                
                [_hudProgress hide:YES];
                [_hudProgress removeFromSuperview];
                _hudProgress=nil;
                showNetLogoNO;
                
                NSDictionary *result=(NSDictionary *)responseObject;
                if ([[result objectForKey:@"code"] isEqualToString:@"0"]) {
                    [SellerOptionsInfoModel deleteAllSellerOptions:[NSString stringWithFormat:@"op_id='%@'",btn.accessibilityValue]];
                    if (![[textName.text stringByTrimmingCharactersInSet:whitespace] isEqualToString:@""]) {
                          [SellerOptionsInfoModel saveSellerOptions:[SellerOptionsInfoModel SellerOptionsInfoModelFromDictionary:[result objectForKey:@"options"]]];
                    }
                    
                    [self layoutSubviews];
                    [popView removeFromSuperview];
                    
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
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIView *popView=(UIView *)[self.superview.superview viewWithTag:101];
    UIImageView *contentImage=(UIImageView *)[popView viewWithTag:201];
    CGRect frame = textField.frame;
    
    CGFloat keybordToView=popView.frame.size.height-256.0;
    CGFloat textToView=contentImage.frame.origin.y+frame.origin.y+frame.size.height+frame.origin.y+frame.size.height;
    
    if (textToView>=keybordToView) {
        contentImage.frame=CGRectMake(contentImage.frame.origin.x, textToView-keybordToView, contentImage.frame.size.width, contentImage.frame.size.height);
    }
}

@end
