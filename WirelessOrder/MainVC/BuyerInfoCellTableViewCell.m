//
//  BuyerInfoCellTableViewCell.m
//  WirelessOrder
//
//  Created by eteng on 15/1/14.
//  Copyright (c) 2015年 etenginfo. All rights reserved.
//

#import "BuyerInfoCellTableViewCell.h"

@implementation BuyerInfoCellTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initCustomCell];
    }
    return self;
}

//初始化单元格
-(void)initCustomCell
{
    _telLbl=[[UILabel alloc] init];
    [self.contentView addSubview:_telLbl];
    
    _tel=[[UILabel alloc] init];
    [self.contentView addSubview:_tel];
    
    _addressLbl=[[UILabel alloc] init];
    [self.contentView addSubview:_addressLbl];
    
    _address=[[UILabel alloc] init];
    [self.contentView addSubview:_address];
    
    _totalNumberLbl=[[UILabel alloc] init];
    [self.contentView addSubview:_totalNumberLbl];
    
    _totalNumber=[[UILabel alloc] init];
    [self.contentView addSubview:_totalNumber];
    
    _totalMoneyLbl=[[UILabel alloc] init];
    [self.contentView addSubview:_totalMoneyLbl];
    
    _totalMoney=[[UILabel alloc] init];
    [self.contentView addSubview:_totalMoney];
    
    _cellLineImage1=[[UIImageView alloc] init];
    [self.contentView addSubview:_cellLineImage1];
    
    _cellLineImage2=[[UIImageView alloc] init];
    [self.contentView addSubview:_cellLineImage2];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    _telLbl.frame=CGRectMake(25, 5, 40, 30);
    _telLbl.text=@"电话";
    _telLbl.textColor=kUIColorFromRGB(0x606366);
    
    _tel.frame=CGRectMake(_telLbl.frame.size.width+_telLbl.frame.origin.x, _telLbl.frame.origin.y, self.frame.size.width-_telLbl.frame.size.width-_telLbl.frame.origin.x-25, _telLbl.frame.size.height);
    _tel.textAlignment=NSTextAlignmentRight;
    _tel.text=self.model.tel;
    _tel.textColor=kUIColorFromRGB(0x606366);
    
    _cellLineImage1.frame=CGRectMake(15, _telLbl.frame.size.height+_telLbl.frame.origin.y, self.frame.size.width-30, 1);
    [_cellLineImage1 setImage:ImageNamed(@"remarkline")];
    
    _addressLbl.frame=CGRectMake(_telLbl.frame.origin.x, _cellLineImage1.frame.origin.y+_cellLineImage1.frame.size.height+5, _telLbl.frame.size.width, _telLbl.frame.size.height);
    _addressLbl.text=@"地址";
    _addressLbl.textColor=kUIColorFromRGB(0x606366);
    
    _address.frame=CGRectMake(_addressLbl.frame.size.width+_addressLbl.frame.origin.x, _addressLbl.frame.origin.y, self.frame.size.width-_addressLbl.frame.size.width-_addressLbl.frame.origin.x-25, _telLbl.frame.size.height);
    _address.textAlignment=NSTextAlignmentRight;
    _address.textColor=kUIColorFromRGB(0x606366);
    _address.text=self.model.address;
    
    _cellLineImage2.frame=CGRectMake(15, _addressLbl.frame.size.height+_addressLbl.frame.origin.y, self.frame.size.width-30, 1);
    [_cellLineImage2 setImage:ImageNamed(@"remarkline")];
    
    _totalNumberLbl.frame=CGRectMake(_telLbl.frame.origin.x, _cellLineImage2.frame.origin.y+_cellLineImage2.frame.size.height+5, _telLbl.frame.size.width, _telLbl.frame.size.height);
    _totalNumberLbl.textColor=kUIColorFromRGB(0x606366);
    _totalNumberLbl.text=@"订单";
    
    _totalNumber.frame=CGRectMake(_totalNumberLbl.frame.size.width+_totalNumberLbl.frame.origin.x, _totalNumberLbl.frame.origin.y,0, _telLbl.frame.size.height);
    _totalNumber.textColor=kUIColorFromRGB(0xf33637);
    _totalNumber.text=[self.model.totalNumber stringByAppendingString:@"单"];

    _totalNumber.frame=CGRectMake(_totalNumber.frame.origin.x, _totalNumber.frame.origin.y, [self CalculationSize:_totalNumber.font text:_totalNumber.text].width, _totalNumber.frame.size.height);
    
    _totalMoneyLbl.frame=CGRectMake(self.frame.size.width/2,_totalNumber.frame.origin.y,_telLbl.frame.size.width,_telLbl.frame.size.height);
    _totalMoneyLbl.textColor=kUIColorFromRGB(0x606366);
    _totalMoneyLbl.text=@"消费";
    
    _totalMoney.frame=CGRectMake(_totalMoneyLbl.frame.size.width+_totalMoneyLbl.frame.origin.x, _totalMoneyLbl.frame.origin.y,0, _telLbl.frame.size.height);
    _totalMoney.textColor=kUIColorFromRGB(0xf33637);
    _totalMoney.text=[self.model.totalMoney stringByAppendingString:@"元"];
    
    _totalMoney.frame=CGRectMake(_totalMoney.frame.origin.x, _totalMoney.frame.origin.y, [self CalculationSize:_totalMoney.font text:_totalMoney.text].width, _totalMoney.frame.size.height);
}

-(CGSize)CalculationSize:(UIFont *)font text:(NSString *)text
{
    //自动调整高度
    NSDictionary *attributes = @{NSFontAttributeName:font};
    
    CGSize lblFontSize=[text boundingRectWithSize:CGSizeMake(100,30) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    return lblFontSize;
}

@end
