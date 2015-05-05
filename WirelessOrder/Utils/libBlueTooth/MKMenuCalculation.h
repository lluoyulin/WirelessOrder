
//
//  Created by Leven on 14-10-11.
//  Copyright (c) 2014年 Leven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MKMenuCalculation : NSObject

@property (strong,nonatomic)NSMutableArray *menus;

+(MKMenuCalculation *)defaultMKMenuCalculation;

+ (NSMutableString *)menu:(NSString *)str;

@end
