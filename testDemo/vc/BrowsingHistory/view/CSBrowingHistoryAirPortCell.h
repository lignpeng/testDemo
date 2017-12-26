//
//  CSBrowingHistoryAirPortCell.h
//  testDemo
//
//  Created by lignpeng on 2017/11/15.
//  Copyright © 2017年 genpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCSBrowingHistoryAirPortCell @"CSBrowingHistoryAirPortCell"

@class CSBrowingHistoryModel;
@interface CSBrowingHistoryAirPortCell : UITableViewCell

+ (instancetype)browingHistoryAirPortCellWithTableView:(UITableView *)tableView;

- (void)setupBrowingHistoryCellWithModel:(CSBrowingHistoryModel *)model;
- (void)hiddenSeparatorView:(BOOL)hidden;

@end
