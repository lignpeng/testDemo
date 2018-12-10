//
//  UIExcelCollectionCell.h
//  testDemo
//
//  Created by lignpeng on 2018/5/11.
//  Copyright © 2018年 genpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#define collectionId @"UIExcelCollectionCell"

@interface UIExcelCollectionCell : UICollectionViewCell

+ (instancetype)cellForCollectionView:(UICollectionView *)collectionView IndexPath:(NSIndexPath *)indexPath;

- (void)configTitle:(NSString *)title select:(BOOL)isSelected;

@end
