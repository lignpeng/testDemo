//
//  UISelectCollectionViewCell.h
//  testDemo
//
//  Created by lignpeng on 2018/7/11.
//  Copyright © 2018年 genpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LabelModel.h"
#define identifyCell @"UISelectCollectionViewCell"

@interface UISelectCollectionViewCell : UICollectionViewCell

@property(nonatomic, copy) void (^deleteActionBlock)(NSIndexPath *indexPath);

+ (instancetype)buttonViewWithTitle:(NSString *)title;
+ (instancetype)selectCollectionViewCell:(UICollectionView *)colletionview indexPath:(NSIndexPath *)indexPath model:(LabelModel *)model;

@end
