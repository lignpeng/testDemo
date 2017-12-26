//
//  CSBrowsingHistoryTypeView.h
//  testDemo
//
//  Created by lignpeng on 2017/11/14.
//  Copyright © 2017年 genpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSBrowingHistoryMarco.h"

@interface CSBrowsingHistoryTypeView : UIView

//弹出选择页
+ (void)showBrowsingHistoryTypeViewWithDelegate:(UIViewController *)delegate Type:(BrowsingType )selectType complishBlock:(void(^)(BrowsingType type))complishBlock dismissBlock:(void(^)())dismissBlock;

//是否已经弹出
+ (BOOL)isBrowsingHistoryTypeViewShow:(UIViewController *)delegate;

@end
