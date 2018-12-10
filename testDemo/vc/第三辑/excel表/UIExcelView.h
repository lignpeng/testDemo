//
//  UIExcelView.h
//  testDemo
//
//  Created by lignpeng on 2018/5/11.
//  Copyright © 2018年 genpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIExcelView : UIView

@property(nonatomic, assign) int row;//屏幕上的行数，用于规划布局
@property(nonatomic, assign) int colunm;//屏幕上的列数


//左边数据：[1,2,3,4,5,6]，有序的一维数组
@property(nonatomic, strong) NSMutableArray *leftDataSource;
//顶部数据：[1,2,3,4,5,6]，有序的一维数组
@property(nonatomic, strong) NSMutableArray *topDataSource;
//主表数据：[[1,2],[3,4],[5,6]]，有序的二维数组
@property(nonatomic, strong) NSMutableArray *tableViewDataSource;


- (void)updateData;
- (void)updataView;
- (void)show;
@end
