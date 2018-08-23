//
//  GPTools.h
//  testDemo
//
//  Created by lignpeng on 17/3/24.
//  Copyright © 2017年 genpeng. All rights reserved.
//
/*
 关于界面、视图方面的操作
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef void(^AlertViewHandler)();
typedef void(^AlertViewClickedIndex)(NSInteger clickedIndex);

@interface GPTools : NSObject

//获取当前控制器
//+ (UIViewController *)getCurrentVC;
+ (UIViewController *)getCurrentViewController;

+ (void)ShowAlert:(NSString *)message;
+ (void)ShowAlertView:(NSString *)message alertHandler:(AlertViewHandler)handle;
+ (void)ShowAlertViewWithoutCancelActionTitle:(NSString *)title message:(NSString *)message handler:(AlertViewHandler) handle;
+ (void)ShowAlertViewWithCustomAction:(NSString *)title message: (NSString *)message cancleActionTitle: (NSString *)cancleActionTitle OKActionTitle: (NSString *)OKActionTitle cancelAction: (AlertViewHandler)cancelAction OKAction:(AlertViewHandler)OKAction;
+ (void)ShowAlertView:(NSString *)title message:(NSString *)message clickedIndex:(AlertViewClickedIndex) clickedIndex cancelButtonTitle:(NSString *)cancelButtonTitle otherButtons:(NSArray <NSString*>*)otherButtons;
//延时自动消失，无按钮
+ (void)ShowInfoTitle:(NSString *)title message:(NSString *)message delayTime:(float)time;
//获取指定区域的图片
+ (UIImage *)clipImageOrignImage:(UIImage *)orignImage WithRect:(CGRect)aRect;

//创建按钮
+ (UIButton *)createButton:(NSString *)title titleFont:(UIFont *)titleFont corner:(CGFloat)radius target:(nullable id)target action:(SEL _Nonnull )selector;
+ (UIButton *)colorButton:(NSString *)title titleFont:(UIFont *)titleFont isColor:(BOOL)isColor corner:(CGFloat)radius target:(nullable id)target action:(SEL _Nonnull )selector;

@end
