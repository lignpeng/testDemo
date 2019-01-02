//
//  UISelectListView.h
//  testDemo
//
//  Created by lignpeng on 2017/9/5.
//  Copyright © 2017年 genpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISelectListView : UIView

@property(nonatomic, copy) void (^actionBlock)(NSString *str);

+ (void)showSelectListViewWithSourceRect:(CGRect )sourceRect;

+ (void)showSelectListViewWithSourceRect:(CGRect)sourceRect delegate:(UIViewController *)delegate complishBlock:(void(^)(NSString *str))complishBlock;
+ (void)showSelectListViewWithDataSoucre:(NSArray *)dataSource SourceRect:(CGRect)sourceRect delegate:(UIViewController *)delegate complishBlock:(void(^)(NSString *str))complishBlock;

+ (void)removeSelectListView:(UIViewController *)delegate;

+ (void)dismissSelectListView;

@end
