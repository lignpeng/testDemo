//
//  GPOperationTableViewCell.h
//  testDemo
//
//  Created by lignpeng on 17/3/22.
//  Copyright © 2017年 genpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GPOperationTableViewCell;
typedef void (^CellActionCallBackBlock)(BOOL status,GPOperationTableViewCell *cell);

@interface GPOperationTableViewCell : UITableViewCell


@property(nonatomic, copy) CellActionCallBackBlock cellActionCallBackBlock;

- (void)configCellInfo:(NSString *)string;

@end
