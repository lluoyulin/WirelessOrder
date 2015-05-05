//
//  testViewController.m
//  WirelessOrder
//
//  Created by eteng on 14/12/19.
//  Copyright (c) 2014年 etenginfo. All rights reserved.
//

#import "ReservationViewController.h"
#import "PhoneOrderViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "UIImageView+WebCache.h"
#import "AFHTTPRequestOperationManager.h"
#import "GoodsInfoModel.h"
#import "SellerOptionsInfoModel.h"
#import "MainOrderInfoModel.h"
#import "OrderDetailInfoModel.h"
#import "CartAnimationView.h"
#import "QCSlideViewController.h"
#import "UIImage+GIF.h"
#import <QuartzCore/QuartzCore.h>

@interface ReservationViewController ()

@end

@implementation ReservationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=kUIColorFromRGB(0xeaeaea);
    
    //初始化数据
    [self initData];

    //创建菜单表格
    [self initFocusView];
    
    //创建底部操作栏
    [self initSelfTarbar];
    
    //加载菜品数据
    [self loadData:self.GoodsClassId];
}

//初始化数据
-(void)initData
{
    _orderDetailList=[[NSMutableArray alloc] init];
    _goodsRemarkList=[[NSMutableArray alloc] init];
    
    NSUserDefaults *userData=[NSUserDefaults standardUserDefaults];
    _orderNO=[userData stringForKey:@"orderno"];
}

//创建底部操作栏
-(void)initSelfTarbar
{
    UIView *viewTarbar=[[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-44-44-20-100, ScreenWidth, 100)];
    viewTarbar.backgroundColor=kUIColorFromRGB(0xeaeaea);
    viewTarbar.tag=1000;
    [self.view addSubview:viewTarbar];
    
    UIImageView *topLine=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    [topLine setImage:[UIImage imageNamed:@"remarkline"]];
    [viewTarbar addSubview:topLine];
    
    UIImageView *remarkView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, ScreenWidth-20, 30)];
    [remarkView setImage:[UIImage imageNamed:@"remarkbg"]];
    remarkView.userInteractionEnabled=YES;
    remarkView.tag=1001;
    [viewTarbar addSubview:remarkView];
    
    UIImageView *bottomLine=[[UIImageView alloc] initWithFrame:CGRectMake(0, 50, ScreenWidth, 1)];
    [bottomLine setImage:[UIImage imageNamed:@"remarkline"]];
    [viewTarbar addSubview:bottomLine];
    
    UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake((ScreenWidth-120)/2, 51+(100-51-35)/2, 120, 35)];
    [btn setBackgroundImage:[UIImage imageNamed:@"btnbg"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"btnbg_select"] forState:UIControlStateHighlighted];
    [btn setTitle:@"确认" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
    [viewTarbar addSubview:btn];
    
    NSUserDefaults *userData=[NSUserDefaults standardUserDefaults];
    NSArray *arrOptions=[SellerOptionsInfoModel getAllSellerOptions:[NSString stringWithFormat:@"seller_id='%@' and class_id='%@'",[userData stringForKey:@"sellerId"],self.GoodsClassId]];//获取菜品备注
    NSUInteger optionsCount=arrOptions.count;
    
    if (optionsCount==0) {
        UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, remarkView.frame.size.width-10, 10)];
        lbl.text=@"该菜品暂无备注";
        [remarkView addSubview:lbl];
    }
    else{
        if (optionsCount>6) {
            optionsCount=6;
        }
        for (int i=0; i<optionsCount; i++) {
            SellerOptionsInfoModel *model=arrOptions[i];
            UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(remarkView.frame.size.width/6*i, 0, remarkView.frame.size.width/6, 30)];
            if (i==0) {
                [btn setBackgroundImage:[UIImage imageNamed:@"remarkleft_select"] forState:UIControlStateSelected];
            }
            else if(i==5){
                [btn setBackgroundImage:[UIImage imageNamed:@"remarkright_select"] forState:UIControlStateSelected];
            }
            else{
                [btn setBackgroundImage:[UIImage imageNamed:@"remark_select"] forState:UIControlStateSelected];
            }
            [btn setTitleColor:kUIColorFromRGB(0x504f4f) forState:UIControlStateNormal];
            [btn setTitleColor:kUIColorFromRGB(0xffffff) forState:UIControlStateSelected];
            [btn setTitle:model.option_name forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(pressRemarkBtn:) forControlEvents:UIControlEventTouchUpInside];
            [remarkView addSubview:btn];
            
            if (i!=optionsCount-1 || i!=5) {
                UIImageView *image=[[UIImageView alloc] initWithFrame:CGRectMake(btn.frame.size.width*(i+1), 0, 1, 30)];
                [image setImage:[UIImage imageNamed:@"verticalline"]];
                [remarkView addSubview:image];
            }
        }
    }
}

//确认点菜
-(void)pressBtn:(UIButton *)btn
{
    if ([self.IsNoodle isEqualToString:@"1"]) {//粉面类
        if (_isMainFood) {//已点主食
            NSMutableString *attach_name=[[NSMutableString alloc] init];//附加菜
            float attach_price=0.0;//附加菜金额
            NSMutableString *ask_for=[[NSMutableString alloc] init];//特殊要求
            
            OrderDetailInfoModel *order=[[OrderDetailInfoModel alloc] init];
            for (GoodsInfoModel *goods in _goodsList) {//添加菜品到已点菜集合里
                if ([_orderDetailList containsObject:goods.goods_id]) {
                    if ([goods.goods_type isEqualToString:@"1"]) {//主食
                        order.goods_id=goods.goods_id;
                        order.goods_name=goods.goods_name;
                        order.goods_single_price=goods.goods_price;
                        order.goods_discount_price=goods.discount_price;
                        _goodsImagePath=goods.goods_img_path;
                    }
                    else{//非主食
                        [attach_name appendFormat:@"%@,",goods.goods_name];
                        attach_price+=[goods.discount_price floatValue];
                    }
                }
            }
            
            for (NSString *remark in _goodsRemarkList) {//粉面的特殊要求
                [ask_for appendFormat:@"%@,",remark];
            }
            
            NSDateFormatter *detail_id=[[NSDateFormatter alloc] init];
            [detail_id setDateFormat:@"yyyyMMddHHMMssSSS"];
            
            order.detail_id=[detail_id stringFromDate:[NSDate date]];
            order.order_id=_orderNO;
            order.goods_number=@"1";
            if (attach_name.length>0) {
                order.goods_attach_name=[attach_name substringToIndex:attach_name.length-1];
            }
            else{
                order.goods_attach_name=attach_name;
            }
            if (ask_for.length>0) {
                order.ask_for=[ask_for substringToIndex:ask_for.length-1];
            }
            else{
                order.ask_for=ask_for;
            }
            order.goods_attach_price=[NSString stringWithFormat:@"%.2f",attach_price];
            order.total_price=[NSString stringWithFormat:@"%.2f",attach_price+[order.goods_discount_price floatValue]*[order.goods_number intValue]];
            order.create_time=@"";
            order.create_person=@"";
            [OrderDetailInfoModel saveOrderDetail:order];
            
            _goodsCount=1;
            [self.addCartdelegate AddCart:_goodsImagePath GoodsCount:_goodsCount];
            [self showMessage];
        }
        else{//未点主食
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"主食每次必须点一份" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    else{//非粉面类
        if (_orderDetailList.count>0) {
            OrderDetailInfoModel *order;
            NSDateFormatter *detail_id;
            for (GoodsInfoModel *goods in _goodsList) {
                if ([_orderDetailList containsObject:goods.goods_id]) {//添加菜品到已点菜集合里
                    order=[[OrderDetailInfoModel alloc] init];
                    detail_id=[[NSDateFormatter alloc] init];
                    [detail_id setDateFormat:@"yyyyMMddHHMMssSSS"];
                    
                    order.detail_id=[detail_id stringFromDate:[NSDate date]];
                    order.order_id=_orderNO;
                    order.goods_id=goods.goods_id;
                    order.goods_name=goods.goods_name;
                    order.goods_single_price=goods.goods_price;
                    order.goods_discount_price=goods.discount_price;
                    order.goods_number=@"1";
                    order.goods_attach_name=@"";
                    order.goods_attach_price=@"";
                    order.ask_for=@"";
                    order.total_price=[NSString stringWithFormat:@"%.2f",[order.goods_discount_price floatValue]*[order.goods_number intValue]];
                    order.create_time=@"";
                    order.create_person=@"";
                    [OrderDetailInfoModel saveOrderDetail:order];
                    
                    _goodsImagePath=goods.goods_img_path;
                    _goodsCount+=1;
                }
            }
            [self.addCartdelegate AddCart:_goodsImagePath GoodsCount:_goodsCount];
            [self showMessage];
        }
        else{
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请至少选择一份菜品" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

//备注选中
-(void)pressRemarkBtn:(UIButton *)btn
{
    if (btn.selected) {
        btn.selected=NO;
        [_goodsRemarkList removeObject:btn.currentTitle];
    }
    else{
        btn.selected=YES;
        [_goodsRemarkList addObject:btn.currentTitle];
    }
}

//提示信息
-(void)showMessage
{
    _orderDetailList=[[NSMutableArray alloc] init];
    _goodsRemarkList=[[NSMutableArray alloc] init];
    _isMainFood=NO;
    _goodsCount=0;
    _goodsImagePath=@"";
    
    UIView *view=(UIView *)[self.view viewWithTag:1000];
    UIImageView *image=(UIImageView *)[view viewWithTag:1001];
    NSArray *subView=[image subviews];
    for (int i=0; i<subView.count; i++) {
        if ([subView[i] isKindOfClass:[UIButton class]]) {
            UIButton *btn=(UIButton *)subView[i];
            btn.selected=NO;
        }
    }
    
    [_focusGridView reloadData];
    
//    _hudProgress=[[MBProgressHUD alloc] initWithView:self.view];
//    [self.view addSubview:_hudProgress];
//    _hudProgress.labelText=@"添加成功";
//    _hudProgress.mode=MBProgressHUDModeText;
//    
//    [_hudProgress showAnimated:YES whileExecutingBlock:^{
//        sleep(1);
//    } completionBlock:^{
//        [_hudProgress removeFromSuperview];
//        _hudProgress=nil;
//    }];
}

//加载菜品数据
-(void)loadData:(NSString *)goodsClass
{
    _goodsList=[GoodsInfoModel getAllGoods:[NSString stringWithFormat:@"goods_class='%@' and goods_status='1'",goodsClass]];
    [_focusGridView reloadData];
}

//创建菜单表格
- (void)initFocusView
{
    //初始化
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    _focusGridView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-44-44-20-100) collectionViewLayout:flowLayout];
    _focusGridView.dataSource=self;
    _focusGridView.delegate=self;
    _focusGridView.backgroundView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"phoneorderbg"]];
    // 注册cell
    [_focusGridView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"GradientCell"];
    //注册cell底部
    [_focusGridView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    _focusGridView.delaysContentTouches=NO;
    [self.view addSubview:_focusGridView];
}

#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section==_sumSectionCount-1 && _goodsList.count % 3!=0) {
        return _goodsList.count % 3;
    }
    return 3;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    _sumSectionCount=_goodsList.count/3.0;
    if (_goodsList.count % 3 !=0) {
        _sumSectionCount++;
    }
    return _sumSectionCount;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"GradientCell";
    
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if ([cell.contentView subviews].count==0) {
        UIImageView *image=[[UIImageView alloc] initWithFrame:CGRectMake((cell.frame.size.width-100.45)/2, 5, 100.45, 64.09)];
        image.tag=1;
        image.layer.masksToBounds=YES;
        image.layer.cornerRadius=5.0;
        [cell.contentView addSubview:image];
        
        UIImageView *imageSelect=[[UIImageView alloc] initWithFrame:image.frame];
        imageSelect.tag=4;
        imageSelect.layer.masksToBounds=YES;
        imageSelect.layer.cornerRadius=5.0;
        [cell.contentView addSubview:imageSelect];
        
        UILabel *lblName=[[UILabel alloc] init];
        lblName.tag=2;
        [lblName setNumberOfLines:0];
        lblName.font=[UIFont systemFontOfSize:12.0];
        [cell.contentView addSubview:lblName];
        
        UILabel *lblPrict=[[UILabel alloc] init];
        lblPrict.tag=3;
        [lblPrict setNumberOfLines:0];
        lblPrict.textColor=kUIColorFromRGB(0xf33637);
        lblPrict.font=[UIFont systemFontOfSize:12.0];
        [cell.contentView addSubview:lblPrict];
    }
    
    int listIndex=0;
    switch (indexPath.row) {
        case 0:
            listIndex=indexPath.section*3.0+0;
            break;
        case 1:
            listIndex=indexPath.section*3.0+1;
            break;
        case 2:
            listIndex=indexPath.section*3.0+2;
            break;
    }
    
    GoodsInfoModel *model=_goodsList[listIndex];
    
    UIImageView *image=(UIImageView *)[cell.contentView viewWithTag:1];
    UIImageView *imageSelect=(UIImageView *)[cell.contentView viewWithTag:4];
//    [image sd_setImageWithURL:[NSURL URLWithString:model.goods_img_path] placeholderImage:[UIImage imageNamed:@"cpdefult"]];
    [image sd_setImageWithURL:[NSURL URLWithString:model.goods_img_path] placeholderImage:[UIImage sd_animatedGIFNamed:@"download_image"]];
    [imageSelect setImage:[UIImage imageNamed:@"goods_select"]];
    imageSelect.hidden=NO;
    
    UILabel *lblName=(UILabel *)[cell.contentView viewWithTag:2];
    lblName.text=model.goods_name;
    
    //自动调整高度
    NSDictionary *attributes = @{NSFontAttributeName:lblName.font};
    
    CGSize lblNameFontSize=[lblName.text boundingRectWithSize:CGSizeMake(image.frame.size.width,100) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    lblName.frame=CGRectMake((cell.frame.size.width-lblNameFontSize.width)/2, image.frame.size.height+image.frame.origin.y+2, lblNameFontSize.width, lblNameFontSize.height);
    
    UILabel *lblPrict=(UILabel *)[cell.contentView viewWithTag:3];
    lblPrict.text=[NSString stringWithFormat:@"￥%@元",model.goods_price];
    
    CGSize lblPrictFontSize=[lblPrict.text boundingRectWithSize:CGSizeMake(image.frame.size.width,100) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    lblPrict.frame=CGRectMake((cell.frame.size.width-lblPrictFontSize.width)/2, lblName.frame.size.height+lblName.frame.origin.y+2, lblPrictFontSize.width, lblPrictFontSize.height);
    
    return cell;
}

//初始化每个section页头，页脚
- (UICollectionReusableView *)collectionView:(UICollectionView *)theCollectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)theIndexPath
{
    
    UICollectionReusableView *theView;
    
    if(kind == UICollectionElementKindSectionHeader)
    {
        theView = [theCollectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:theIndexPath];
    } else {
        theView = [theCollectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:theIndexPath];
        
        UIImageView *image=[[UIImageView alloc] initWithFrame:CGRectMake(5, 0, ScreenWidth-10, 2)];
        [image setImage:[UIImage imageNamed:@"dottedline"]];
        
        [theView addSubview:image];
    }
    
    return theView;
}

//每个section页脚的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(ScreenWidth, 10);
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((ScreenWidth-90)/3, 100);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 15, 5, 15);
}

#pragma mark --UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    int listIndex=0;
    switch (indexPath.row) {
        case 0:
            listIndex=indexPath.section*3.0+0;
            break;
        case 1:
            listIndex=indexPath.section*3.0+1;
            break;
        case 2:
            listIndex=indexPath.section*3.0+2;
            break;
    }
    
    GoodsInfoModel *model=_goodsList[listIndex];
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    UIImageView *imageSelect=(UIImageView *)[cell.contentView viewWithTag:4];
    [imageSelect setImage:[UIImage imageNamed:@"goods_select"]];
    if (imageSelect.hidden) {//取消点菜
        imageSelect.hidden=NO;
        if ([model.goods_type isEqualToString:@"1"] && [self.IsNoodle isEqualToString:@"1"]) {
            _isMainFood=NO;
        }
        [_orderDetailList removeObject:model.goods_id];
    }
    else{//点菜
        imageSelect.hidden=YES;
        
        if ([self.IsNoodle isEqualToString:@"1"]) {//粉面类
            if ([model.goods_type isEqualToString:@"1"]) {//主食
                if (_isMainFood) {//已被点
                    imageSelect.hidden=NO;
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"主食每次只能点一份" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                }
                else{//未被点
                    _isMainFood=YES;
                    [_orderDetailList addObject:model.goods_id];
                }
            }
            else{//非主食
                [_orderDetailList addObject:model.goods_id];
            }
        }
        else{//非粉面类
            [_orderDetailList addObject:model.goods_id];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
