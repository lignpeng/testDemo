//
//  UIInputPassWordView.h

//
//  Created by lignpeng on 2018/12/12.
//  Copyright © 2018年 genpeng. All rights reserved.
//

/*
 
 绘制密码框
 
 */

#import <UIKit/UIKit.h>

@interface UIInputPassWordView : UIView

+ (instancetype)inputPasswordView:(NSUInteger)passwordNum;

- (void)updateView:(NSInteger)wordLength isError:(BOOL)isError;

@end
