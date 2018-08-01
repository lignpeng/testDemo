//
//  UIEditTextFieldView.h
//  testDemo
//
//  Created by lignpeng on 2018/8/1.
//  Copyright © 2018年 genpeng. All rights reserved.
//

/*
 弹出编辑框
 
 */

#import <UIKit/UIKit.h>

@interface UIEditTextFieldView : UIViewController

+ (void)editTextFieldWithTitle:(NSString *) title editStr:(NSString *)editStr complish:(void(^)(NSString *text))complishBlock cancelBlock:(void(^)())cancelBlock;

@end
