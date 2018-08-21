//
//  UIHud.m
//  testDemo
//
//  Created by lignpeng on 2018/8/21.
//  Copyright © 2018年 genpeng. All rights reserved.
//

#import "UIHUD.h"
#import "MBProgressHUD.h"


@implementation UIHUD

+ (void)showHUD {
    [self removeHUD];
    UIWindow *windowView = [[UIApplication sharedApplication] keyWindow];
    [MBProgressHUD showHUDAddedTo:windowView animated:YES];
}

+ (void)dismissHUD {
    UIWindow *windowView = [[UIApplication sharedApplication] keyWindow];
    for (UIView *subView in windowView.subviews) {
        if ([subView isMemberOfClass:[MBProgressHUD class]]) {
            [(MBProgressHUD *)subView hideAnimated:YES];
        }
    }
}

+ (void)removeHUD {
    UIWindow *windowView = [[UIApplication sharedApplication] keyWindow];
    for (UIView *subView in windowView.subviews) {
        if ([subView isMemberOfClass:[MBProgressHUD class]]) {
            [(MBProgressHUD *)subView removeFromSuperview];
        }
    }
}

@end
