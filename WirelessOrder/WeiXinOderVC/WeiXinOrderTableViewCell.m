//
//  WeiXinOrderTableViewCell.m
//  WirelessOrder
//
//  Created by eteng on 15/1/4.
//  Copyright (c) 2015年 etenginfo. All rights reserved.
//

#import "WeiXinOrderTableViewCell.h"

@implementation WeiXinOrderTableViewCell

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
    _dotImage=[[UIImageView alloc] init];
    [self.contentView addSubview:_dotImage];
    
    _bottomLineImage=[[UIImageView alloc] init];
    [self.contentView addSubview:_bottomLineImage];
    
    _phoneLbl=[[UILabel alloc] init];
    [self.contentView addSubview:_phoneLbl];
    
    _addressLbl=[[UILabel alloc] init];
    [self.contentView addSubview:_addressLbl];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundColor=kUIColorFromRGB(0xffffff);
    
    _bottomLineImage.frame=CGRectMake(10, self.frame.size.height-1, ScreenWidth-20, 1);
    [_bottomLineImage setImage:[UIImage imageNamed:@"remarkline"]];
    
    _dotImage.frame=CGRectMake(11, (self.frame.size.height-10)/2, 10, 10);
    [_dotImage setImage:[UIImage imageNamed:@"phone_user_dot"]];
    
    _phoneLbl.frame=CGRectMake(_dotImage.frame.origin.x+_dotImage.frame.size.width+5, (self.frame.size.height-15)/2, 120, 15);
    _phoneLbl.text=self.model.order_tel;
    _phoneLbl.font=[UIFont systemFontOfSize:16.0];
    
    _addressLbl.frame=CGRectMake(_phoneLbl.frame.size.width+_phoneLbl.frame.origin.x, _phoneLbl.frame.origin.y,ScreenWidth-20-_dotImage.frame.size.width-5-_phoneLbl.frame.size.width-20, 15);
    _addressLbl.text=self.model.order_address;
    _addressLbl.font=[UIFont systemFontOfSize:16.0];
}

@end
