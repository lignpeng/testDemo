//
//  CSBrowingHistoryBlankView.h
//  testDemo
//
//  Created by lignpeng on 2017/11/16.
//  Copyright © 2017年 genpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSBrowingHistoryBlankView : UIView

+ (void)showWithTitle:(NSString *)title delegate:(UIViewController *)delegate;
+ (void)dismissWithDelegate:(UIViewController *)delegate;

@end
