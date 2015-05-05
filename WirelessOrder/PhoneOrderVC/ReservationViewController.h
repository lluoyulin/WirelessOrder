//
//  testViewController.h
//  WirelessOrder
//
//  Created by eteng on 14/12/19.
//  Copyright (c) 2014年 etenginfo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMDrawerController.h"
#import "MMDrawerController+Subclass.h"
#import "MBProgressHUD.h"

@protocol AddGoodsDelegate <NSObject>

-(void)AddCart:(NSString *)imagePath GoodsCount:(NSInteger)count;

@end

@interface ReservationViewController : MMDrawerController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
@private
    UICollectionView *_focusGridView;//菜品集合视图
    NSMutableArray *_goodsList;//菜品集合
    int _sumSectionCount;//section数量
    NSMutableArray *_orderDetailList;//已点菜品
    NSMutableArray *_goodsRemarkList;//已点备注（只适合粉面类）
    BOOL _isMainFood;//是否已点主食（只适合粉面类）
    NSString *_orderNO;//订单号
    MBProgressHUD *_hudProgress;//提示框
    NSString *_goodsImagePath;//菜品对应图片路径
    NSInteger _goodsCount;//每次点餐数量
}

@property(nonatomic,retain) NSString *GoodsClassId;//对应菜单类型id
@property(nonatomic,retain) NSString *IsNoodle;//对应菜单类型是否粉面

@property(nonatomic,weak)id<AddGoodsDelegate> addCartdelegate;

@end
