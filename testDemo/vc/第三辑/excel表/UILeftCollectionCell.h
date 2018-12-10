//
//  UILeftCollectionCell.h
//  testDemo
//
//  Created by lignpeng on 2018/5/11.
//  Copyright © 2018年 genpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#define leftcollectionId @"UILeftCollectionCell"

@interface UILeftCollectionCell : UICollectionViewCell

+ (instancetype)cellForCollectionView:(UICollectionView *)collectionView IndexPath:(NSIndexPath *)indexPath;

- (void)configTitle:(NSString *)title;

@end
