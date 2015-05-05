//
//  OrderListTableViewCell.m
//  WirelessOrder
//
//  Created by eteng on 14/12/26.
//  Copyright (c) 2014年 etenginfo. All rights reserved.
//

#import "OrderListTableViewCell.h"
#import "OrderDetailInfoModel.h"

@implementation OrderListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
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
    
    _orderLbl=[[UILabel alloc] init];
    [self.contentView addSubview:_orderLbl];
    
    _orderTextLbl=[[UILabel alloc] init];
    [self.contentView addSubview:_orderTextLbl];
    
    _sumLbl=[[UILabel alloc] init];
    [self.contentView addSubview:_sumLbl];
    
    _sumTextLbl=[[UILabel alloc] init];
    [self.contentView addSubview:_sumTextLbl];
    
    _remarkLbl=[[UILabel alloc] init];
    [self.contentView addSubview:_remarkLbl];
    
    _remarkTextLbl=[[UILabel alloc] init];
    [self.contentView addSubview:_remarkTextLbl];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundColor=kUIColorFromRGB(0xeaeaea);
    
    _dotImage.frame=CGRectMake(42, 10, 15, 15);
    [_dotImage setImage:[UIImage imageNamed:@"phone_user_dot"]];
    
    _bottomLineImage.frame=CGRectMake(10, self.frame.size.height-2, ScreenWidth-20, 2);
    [_bottomLineImage setImage:[UIImage imageNamed:@"dottedline"]];
    
    _orderLbl.frame=CGRectMake(_dotImage.frame.size.width+_dotImage.frame.origin.x+10, 10, 50, 15);
    _orderLbl.text=@"配餐 ：";
    _orderLbl.font=[UIFont systemFontOfSize:14.0];
    
    _orderTextLbl.frame=CGRectMake(_orderLbl.frame.size.width+_orderLbl.frame.origin.x, 10, ScreenWidth-(_orderLbl.frame.size.width+_orderLbl.frame.origin.x)-10, 15);
    _orderTextLbl.font=[UIFont systemFontOfSize:14.0];
    _orderTextLbl.numberOfLines=0;
    if ([self.model.goods_attach_name isEqualToString:@""]) {
        _orderTextLbl.text=self.model.goods_name;
    }
    else{
        _orderTextLbl.text=[self.model.goods_name stringByAppendingFormat:@" + %@",[self.model.goods_attach_name stringByReplacingOccurrencesOfString:@"," withString:@" + "]];
    }
    
    //自动调整高度
    NSDictionary *attributes = @{NSFontAttributeName:_orderTextLbl.font};
    
    CGSize fontSize=[_orderTextLbl.text boundingRectWithSize:CGSizeMake(_orderTextLbl.frame.size.width,50) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    _orderTextLbl.frame=CGRectMake(_orderLbl.frame.size.width+_orderLbl.frame.origin.x, 10, fontSize.width, fontSize.height);
    
    
    
    _sumLbl.frame=CGRectMake(_orderLbl.frame.origin.x, _orderTextLbl.frame.size.height+_orderTextLbl.frame.origin.y+10, 50, 15);
    _sumLbl.text=@"小计 ：";
    _sumLbl.font=[UIFont systemFontOfSize:14.0];
    
    _sumTextLbl.frame=CGRectMake(_sumLbl.frame.size.width+_sumLbl.frame.origin.x,_sumLbl.frame.origin.y, ScreenWidth-(_sumLbl.frame.size.width+_sumLbl.frame.origin.x)-10, 15);
    _sumTextLbl.text=[NSString stringWithFormat:@"%@",self.model.total_price];
    _sumTextLbl.font=[UIFont systemFontOfSize:14.0];
    
    _remarkLbl.frame=CGRectMake(_orderLbl.frame.origin.x, _sumTextLbl.frame.size.height+_sumTextLbl.frame.origin.y+10, 50, 15);
    _remarkLbl.text=@"备注 ：";
    _remarkLbl.font=[UIFont systemFontOfSize:14.0];
    
    _remarkTextLbl.frame=CGRectMake(_remarkLbl.frame.size.width+_remarkLbl.frame.origin.x,_remarkLbl.frame.origin.y, ScreenWidth-(_remarkLbl.frame.size.width+_remarkLbl.frame.origin.x)-10, 15);
    _remarkTextLbl.text=self.model.ask_for;
    _remarkTextLbl.font=[UIFont systemFontOfSize:14.0];
}

@end
