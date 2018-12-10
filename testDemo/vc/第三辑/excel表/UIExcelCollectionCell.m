//
//  UIExcelCollectionCell.m
//  testDemo
//
//  Created by lignpeng on 2018/5/11.
//  Copyright © 2018年 genpeng. All rights reserved.
//

#import "UIExcelCollectionCell.h"
#import "Masonry.h"

@interface UIExcelCollectionCell()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIView *bottomline;
@property (nonatomic, strong) UIView *rightline;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation UIExcelCollectionCell

+ (instancetype)cellForCollectionView:(UICollectionView *)collectionView IndexPath:(NSIndexPath *)indexPath {
    UIExcelCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionId forIndexPath:indexPath];
    cell.indexPath = indexPath;
    return cell;
}

- (void)configTitle:(NSString *)title  select:(BOOL)isSelected {
    self.label.text = title;
    if (isSelected) {
        self.backgroundColor = [UIColor lightGrayColor];
    }else {
        self.backgroundColor = [UIColor whiteColor];
    }
}

//系统会自动调用这个方法
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.label];
    [self addSubview:self.bottomline];
    [self addSubview:self.rightline];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat margin = 0.5;
    self.label.frame = (CGRect){0,0,CGRectGetWidth(self.bounds) - margin,CGRectGetHeight(self.bounds)-margin};
    self.bottomline.frame = (CGRect){0,CGRectGetMinY(self.label.frame)+CGRectGetHeight(self.label.frame),CGRectGetWidth(self.bounds),margin};
    self.rightline.frame = (CGRect){CGRectGetWidth(self.bounds) - margin,0,margin,CGRectGetHeight(self.bounds)};
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.frame = CGRectZero;
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:14];
        _label.textColor = [UIColor darkTextColor];
    }
    return _label;
}

- (UIView *)bottomline {
    if (!_bottomline) {
        _bottomline = [UIView new];
        _bottomline.backgroundColor = [UIColor darkTextColor];
        _bottomline.frame = CGRectZero;
    }
    return _bottomline;
}

- (UIView *)rightline {
    if (!_rightline) {
        _rightline = [UIView new];
        _rightline.backgroundColor = [UIColor darkTextColor];
        _rightline.frame = CGRectZero;
    }
    return _rightline;
}

@end
