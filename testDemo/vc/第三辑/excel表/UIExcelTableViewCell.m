//
//  UIExcelTableViewCell.m
//  testDemo
//
//  Created by lignpeng on 2018/5/11.
//  Copyright © 2018年 genpeng. All rights reserved.
//

#import "UIExcelTableViewCell.h"
#import "UIExcelCollectionCell.h"
#import "ExcelCollectionViewFlowLayout.h"
#define excelcell @"excelcell"

@interface UIExcelTableViewCell()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *contentCollection;
@property (nonatomic, assign) CGFloat squareW; //collectionCell宽
@property (nonatomic, assign) CGFloat squareH; //collectionCell高
@property (nonatomic, strong) NSArray *dataSource;


@end

@implementation UIExcelTableViewCell

+ (instancetype)cellForTableView:(UITableView *)tableView squareW:(CGFloat)squareW squareH:(CGFloat)squareH {
    
    UIExcelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:excelcell];
    
    if (cell == nil) {
        cell = [[UIExcelTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:excelcell];
        cell.squareW = squareW;
        cell.squareH = squareH;
        [cell initView];
    }
    return cell;
}

- (void)initView {
    //设置collectionCell尺寸
    [self addSubview:self.contentCollection];
    [self collectionView:self.contentCollection didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0]];
}

- (void)configData:(NSArray *)dataSource {
    self.dataSource = dataSource;
    [self updateData];
}

- (void)updateData {
    [self.contentCollection reloadData];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = self.dataSource.count * self.squareW;
    self.contentCollection.frame = CGRectMake(0, 0, width, self.squareH);
}

#pragma mark --- UICollectionViewDelegate,UICollectionViewDataSource

- ( CGSize )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:( NSIndexPath *)indexPath {
    return (CGSize){self.squareW, self.squareH};
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UIExcelCollectionCell * cell = [UIExcelCollectionCell cellForCollectionView:collectionView IndexPath:indexPath];
    [cell configTitle:self.dataSource[indexPath.row] select:self.selectedIndex == indexPath.row];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
//    NSLog(@"%@",self.dataSource[indexPath.row]);
    if (self.selectBlock) {
        self.selectBlock(indexPath.row,self.indexPath.row,self.dataSource[indexPath.row]);
    }
}

- (UICollectionView *)contentCollection {
    if (!_contentCollection) {
        ExcelCollectionViewFlowLayout *layout = [[ExcelCollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(self.squareW, self.squareH);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _contentCollection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _contentCollection.bounces = NO;
        _contentCollection.scrollEnabled = NO;
        _contentCollection.showsVerticalScrollIndicator = NO;
        _contentCollection.backgroundColor = [UIColor whiteColor];
        _contentCollection.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _contentCollection.delegate = self;
        _contentCollection.dataSource = self;
        [_contentCollection registerClass:[UIExcelCollectionCell class] forCellWithReuseIdentifier:collectionId];
    }
    return _contentCollection;
}

@end
