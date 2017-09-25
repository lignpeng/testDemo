//
//  CSAirNameListView.h
//  testDemo
//
//  Created by lignpeng on 2017/7/27.
//  Copyright © 2017年 genpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AirNameListBlock)(NSInteger index, NSString *name);

@interface CSAirNameListView : UIView

@property(nonatomic, copy) AirNameListBlock complishBlock;

@property (nonatomic, assign) NSInteger selectRow;

+ (instancetype)airNameListView;

+ (instancetype)airNameListView:(void(^)(NSInteger index, NSString *name))complishBlock;

+ (instancetype)airNameListView:(NSArray *)dataSource complish:(void(^)(NSInteger index, NSString *name))complishBlock;

+ (instancetype)airNameListView:(NSArray *)dataSource selectedIndex:(NSInteger )selectedIndex complish:(void(^)(NSInteger index, NSString *name))complishBlock;

+ (void)dissmiss;

@end
