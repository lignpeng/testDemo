//
//  GGWebMenuViewCell.h
//  testDemo
//
//  Created by lignpeng on 2019/1/18.
//  Copyright © 2019年 genpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGWebMenuModel.h"
#define webMenuViewCellId @"GGWebMenuViewCell"

@interface GGWebMenuViewCell : UICollectionViewCell



+ (instancetype)cellForCollectionView:(UICollectionView *)collectionView IndexPath:(NSIndexPath *)indexPath;

- (void)configCell:(GGWebMenuModel *)model;

- (GGWebMenuModel *)getWebMenuModel;

@end

