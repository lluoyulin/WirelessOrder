//
//  QCSlideViewController.h
//  QCSliderTableView
//
//  Created by “ 邵鹏 on 14-4-16.
//  Copyright (c) 2014年 Scasy. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "QCSlideSwitchView.h"
#import "QCListViewController.h"
#import "QCViewController.h"
#import "ReservationViewController.h"

@interface QCSlideViewController : UIViewController<QCSlideSwitchViewDelegate,AddGoodsDelegate>
{
@private
    QCSlideSwitchView *_slideSwitchView;
    NSMutableArray *_viewArray;
    NSMutableArray *_goodsClassList;
    int _goodsCount;
}

@end

