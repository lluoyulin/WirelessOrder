//
//  GoodsCellTableViewCell.m
//  WirelessOrder
//
//  Created by eteng on 15/1/16.
//  Copyright (c) 2015年 etenginfo. All rights reserved.
//

#import "GoodsCellTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "AFHTTPRequestOperationManager.h"
#import "GoodsInfoModel.h"
#import "UIImage+GIF.h"
#import <QuartzCore/QuartzCore.h>

@implementation GoodsCellTableViewCell

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
    _goodsImage=[[UIImageView alloc] init];
    [self.contentView addSubview:_goodsImage];
    
    _cellLineImage=[[UIImageView alloc] init];
    [self.contentView addSubview:_cellLineImage];
    
    _goodsNameLbl=[[UILabel alloc] init];
    [self.contentView addSubview:_goodsNameLbl];
    
    _goodsPriceLbl=[[UILabel alloc] init];
    [self.contentView addSubview:_goodsPriceLbl];
    
    _goodsUpBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_goodsUpBtn];
    
    _goodsDownBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_goodsDownBtn];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundColor=kUIColorFromRGB(0xeaeaea);
    
    //    NSLog(@"%@",self.model.goods_img_path);
    _goodsImage.frame=CGRectMake(12, 10, 100.45, 64.09);
    _goodsImage.layer.masksToBounds=YES;
    _goodsImage.layer.cornerRadius=5.0;
    //[_goodsImage sd_setImageWithURL:[NSURL URLWithString:self.model.goods_img_path] placeholderImage:ImageNamed(@"cpdefult")];download_image
    [_goodsImage sd_setImageWithURL:[NSURL URLWithString:self.model.goods_img_path]  placeholderImage:[UIImage sd_animatedGIFNamed:@"download_image"]];
    
    _cellLineImage.frame=CGRectMake(10, _goodsImage.frame.origin.y+_goodsImage.frame.size.height+7, self.frame.size.width-20, 1);
    [_cellLineImage setImage:ImageNamed(@"dottedline")];
    
    _goodsNameLbl.frame=CGRectMake(_goodsImage.frame.size.width+_goodsImage.frame.origin.x+7, _goodsImage.frame.origin.y+5, self.frame.size.width-_goodsImage.frame.size.width-_goodsImage.frame.origin.x-12-7, 20);
    _goodsNameLbl.textAlignment=NSTextAlignmentLeft;
    _goodsNameLbl.font=[UIFont systemFontOfSize:14.0];
    _goodsNameLbl.text=self.model.goods_name;
    
    _goodsPriceLbl.frame=CGRectMake(_goodsNameLbl.frame.origin.x+15, _goodsNameLbl.frame.origin.y+_goodsNameLbl.frame.size.height, _goodsNameLbl.frame.size.width-10, 20);
    _goodsPriceLbl.textAlignment=NSTextAlignmentLeft;
    _goodsPriceLbl.font=[UIFont systemFontOfSize:14.0];
    _goodsPriceLbl.textColor=kUIColorFromRGB(0xf33737);
    _goodsPriceLbl.text=[self.model.goods_price stringByAppendingString:@"元"];

    _goodsDownBtn.frame=CGRectMake(_cellLineImage.frame.size.width-50, _cellLineImage.frame.origin.y-27, 50, 20);
    _goodsUpBtn.frame=CGRectMake(_goodsDownBtn.frame.origin.x-10-_goodsDownBtn.frame.size.width, _goodsDownBtn.frame.origin.y, _goodsDownBtn.frame.size.width, _goodsDownBtn.frame.size.height);
    
    if (self.isEditing) {//编辑模式
        _goodsUpBtn.frame=CGRectMake(_goodsNameLbl.frame.origin.x, _cellLineImage.frame.origin.y-27, 50, 20);
        _goodsDownBtn.frame=CGRectMake(_goodsUpBtn.frame.origin.x+_goodsUpBtn.frame.size.width+10, _goodsUpBtn.frame.origin.y, _goodsUpBtn.frame.size.width, _goodsUpBtn.frame.size.height);
    }
    
    _goodsDownBtn.titleLabel.font=[UIFont systemFontOfSize:12.0];
    [_goodsDownBtn setTitle:@"下架" forState:UIControlStateNormal];
    [_goodsDownBtn setBackgroundImage:ImageNamed(@"btn_bg_gray") forState:UIControlStateNormal];
    [_goodsDownBtn setBackgroundImage:ImageNamed(@"btnbg") forState:UIControlStateDisabled];
    [_goodsDownBtn addTarget:self action:@selector(pressBtnDown:) forControlEvents:UIControlEventTouchUpInside];
    
    _goodsUpBtn.titleLabel.font=[UIFont systemFontOfSize:12.0];
    [_goodsUpBtn setTitle:@"上架" forState:UIControlStateNormal];
    [_goodsUpBtn setBackgroundImage:ImageNamed(@"btn_bg_gray") forState:UIControlStateNormal];
    [_goodsUpBtn setBackgroundImage:ImageNamed(@"btnbg") forState:UIControlStateDisabled];
    [_goodsUpBtn addTarget:self action:@selector(pressBtnUp:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([self.model.goods_status isEqualToString:@"1"]) {//上架
        [_goodsDownBtn setEnabled:YES];
        [_goodsUpBtn setEnabled:NO];
    }
    else{
        [_goodsDownBtn setEnabled:NO];
        [_goodsUpBtn setEnabled:YES];
    }
}

-(void)pressBtnUp:(UIButton *)btn
{
    _hudProgress=[[MBProgressHUD alloc] initWithView:self.superview.superview];
    [self.superview.superview addSubview:_hudProgress];

    _hudProgress.labelText=@"正在提交数据...";
    [_hudProgress show:YES];
    showNetLogoYES;
    
    AFHTTPRequestOperationManager *httpRequest=[AFHTTPRequestOperationManager manager];
    NSDictionary *parm=[[NSDictionary alloc] initWithObjectsAndKeys:[UserData stringForKey:@"sellerId"],@"sellerId",@"1",@"type",self.model.goods_id,@"goodsId",@"1",@"status",nil];
    [httpRequest GET:[HttpUrl stringByAppendingString:@"changeObjectState"] parameters:parm success:^(AFHTTPRequestOperation *operation,id responseObject){
        
        [_hudProgress hide:YES];
        [_hudProgress removeFromSuperview];
        _hudProgress=nil;
        showNetLogoNO;
        
        NSDictionary *result=(NSDictionary *)responseObject;
        if ([[result objectForKey:@"code"] isEqualToString:@"0"]) {
            [GoodsInfoModel updateGoodsStatus:@"1" goods_id:self.model.goods_id];
            
            self.model=[GoodsInfoModel getAllGoods:[NSString stringWithFormat:@"goods_id='%@'",self.model.goods_id]][0];
            
            [_goodsDownBtn setEnabled:YES];
            [_goodsUpBtn setEnabled:NO];
            
            [self showMsg:@"上架成功"];
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

-(void)pressBtnDown:(UIButton *)btn
{
    _hudProgress=[[MBProgressHUD alloc] initWithView:self.superview.superview];
    [self.superview.superview addSubview:_hudProgress];
    
    _hudProgress.labelText=@"正在提交数据...";
    [_hudProgress show:YES];
    showNetLogoYES;
    
    AFHTTPRequestOperationManager *httpRequest=[AFHTTPRequestOperationManager manager];
    NSDictionary *parm=[[NSDictionary alloc] initWithObjectsAndKeys:[UserData stringForKey:@"sellerId"],@"sellerId",@"1",@"type",self.model.goods_id,@"goodsId",@"2",@"status",nil];
    [httpRequest GET:[HttpUrl stringByAppendingString:@"changeObjectState"] parameters:parm success:^(AFHTTPRequestOperation *operation,id responseObject){
        
        [_hudProgress hide:YES];
        [_hudProgress removeFromSuperview];
        _hudProgress=nil;
        showNetLogoNO;
        
        NSDictionary *result=(NSDictionary *)responseObject;
        if ([[result objectForKey:@"code"] isEqualToString:@"0"]) {
            [GoodsInfoModel updateGoodsStatus:@"2" goods_id:self.model.goods_id];
            
            self.model=[GoodsInfoModel getAllGoods:[NSString stringWithFormat:@"goods_id='%@'",self.model.goods_id]][0];
            
            [_goodsDownBtn setEnabled:NO];
            [_goodsUpBtn setEnabled:YES];
            
            [self showMsg:@"下架成功"];
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

//弹出系统提示框
-(void)alertMessage:(NSString *)msg
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

//提示语
-(void)showMsg:(NSString *)msg
{
    _hudShowMsg=[[MBProgressHUD alloc] initWithView:self.superview.superview];
    [self.superview.superview addSubview:_hudShowMsg];
    
    _hudShowMsg.labelText=msg;
    _hudShowMsg.mode=MBProgressHUDModeText;
    
    [_hudShowMsg showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    } completionBlock:^{
        [_hudShowMsg removeFromSuperview];
        _hudShowMsg=nil;
    }];
}

@end
