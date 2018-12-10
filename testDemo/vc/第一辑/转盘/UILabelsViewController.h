//
//  UILabelsViewController.h
//  testDemo
//
//  Created by lignpeng on 2018/7/11.
//  Copyright © 2018年 genpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabelsViewController : UIViewController

@property(nonatomic, copy) void (^actionBlock)(NSArray *array);

+ (instancetype)labelsViewControllerWith:(NSArray *)items complishBlock:(void(^)(NSArray *items))complishBlock;

@end
