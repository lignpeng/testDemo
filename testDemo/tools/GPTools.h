//
//  GPTools.h
//  testDemo
//
//  Created by lignpeng on 17/3/24.
//  Copyright © 2017年 genpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef void(^AlertViewHandler)();
typedef void(^AlertViewClickedIndex)(NSInteger clickedIndex);

@interface GPTools : NSObject

//获取当前控制器
+ (UIViewController *)getCurrentVC;
+ (UIViewController *)getCurrentViewController;

+ (void)ShowAlert:(NSString *)message;
+ (void)ShowAlertView:(NSString *)message alertHandler:(AlertViewHandler)handle;
+ (void)ShowAlertViewWithoutCancelAction:(NSString *)title message:(NSString *)message handler:(AlertViewHandler) handle;
+ (void)ShowAlertViewWithCustomAction:(NSString *)title message: (NSString *)message cancleActionTitle: (NSString *)cancleActionTitle OKActionTitle: (NSString *)OKActionTitle cancelAction: (AlertViewHandler)cancelAction OKAction:(AlertViewHandler)OKAction;
+ (void)ShowAlertView:(NSString *)title message:(NSString *)message clickedIndex:(AlertViewClickedIndex) clickedIndex cancelButtonTitle:(NSString *)cancelButtonTitle otherButtons:(NSArray <NSString*>*)otherButtons;

@end
