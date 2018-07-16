//
//  RiseupCalcHeaderView.h
//  testDemo
//
//  Created by lignpeng on 2018/7/10.
//  Copyright © 2018年 genpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RiseupCalcHeaderView : UIView

@property(nonatomic, copy) void (^editBlock)(NSString *sumStr,NSString *riseStr,NSString *numStr,BOOL flag);
@property(nonatomic, copy) void (^copyActionBlock)();

+ (instancetype)riseupCalcHeaderView;

@end
