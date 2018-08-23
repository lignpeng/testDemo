//
//  UINameListPickerView.h
//  testDemo
//
//  Created by lignpeng on 2017/7/27.
//  Copyright © 2017年 genpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^nameListPickerBlock)(NSInteger index, NSString *name);

@interface UINameListPickerView : UIView

@property(nonatomic, copy) nameListPickerBlock complishBlock;

@property (nonatomic, assign) NSInteger selectRow;

+ (instancetype)nameListPickerView;

+ (instancetype)nameListPickerView:(void(^)(NSInteger index, NSString *name))complishBlock;

+ (instancetype)nameListPickerView:(NSArray *)dataSource complish:(void(^)(NSInteger index, NSString *name))complishBlock;

+ (instancetype)nameListPickerView:(NSArray *)dataSource selectedIndex:(NSInteger )selectedIndex complish:(void(^)(NSInteger index, NSString *name))complishBlock;

+ (void)dissmiss;

@end
