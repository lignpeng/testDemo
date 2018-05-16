//
//  UIExcelTableViewCell.h
//  testDemo
//
//  Created by lignpeng on 2018/5/11.
//  Copyright © 2018年 genpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIExcelTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) NSInteger selectedIndex;

@property(nonatomic, copy) void(^selectBlock)(NSUInteger colunm,NSUInteger row,id value);
@property(nonatomic, strong) NSIndexPath *indexPath;

+ (instancetype)cellForTableView:(UITableView *)tableView squareW:(CGFloat)squareW squareH:(CGFloat)squareH;
- (void)configData:(NSArray *)dataSource;

@end


