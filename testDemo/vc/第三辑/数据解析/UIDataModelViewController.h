//
//  UIDataModelViewController.h
//  testDemo
//
//  Created by lignpeng on 2018/12/27.
//  Copyright © 2018年 genpeng. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIDataModelViewController : UIViewController

+ (instancetype)create;
- (void)action;

+ (NSString *)fun:(NSString *)name;

+ (NSString *)add:(NSString *)str1 with:(NSString *)str2;

@end

