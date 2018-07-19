//
//  UIButtonView.h
//  testDemo
//
//  Created by lignpeng on 2018/7/11.
//  Copyright © 2018年 genpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LabelModel.h"

@interface UIButtonView : UIView

@property(nonatomic, copy) void (^deleteActionBlock)(NSString *title);

+ (instancetype)buttonViewWithTitle:(NSString *)title;

+ (instancetype)buttonViewViewModel:(LabelModel *)model;
+ (UIView *)buttonViewWithFrame:(CGRect)frame Model:(LabelModel *)model;
@end
