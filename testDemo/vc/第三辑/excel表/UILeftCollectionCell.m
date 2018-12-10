//
//  UILeftCollectionCell.m
//  testDemo
//
//  Created by lignpeng on 2018/5/11.
//  Copyright © 2018年 genpeng. All rights reserved.
//

#import "UILeftCollectionCell.h"
#import "Masonry.h"

@interface UILeftCollectionCell()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIView *bottomline;
@property (nonatomic, strong) UIView *rightline;
@property(nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation UILeftCollectionCell

+ (instancetype)cellForCollectionView:(UICollectionView *)collectionView IndexPath:(NSIndexPath *)indexPath {
    UILeftCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:leftcollectionId forIndexPath:indexPath];
    cell.indexPath = indexPath;
    return cell;
}

- (void)configTitle:(NSString *)title {
    self.label.text = title;
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
    self.backgroundColor = [UIColor lightTextColor];
    [self addSubview:self.label];
    [self addSubview:self.bottomline];
    [self addSubview:self.rightline];
//    CGFloat margin = 0.5;
//    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self);
//        make.leading.equalTo(self);
//        make.bottom.equalTo(self.mas_bottom).offset(margin);
//        make.trailing.equalTo(self);
//    }];
//    [self.bottomline mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.label);
//        make.leading.equalTo(self);
//        make.bottom.equalTo(self.mas_bottom);
//        make.trailing.equalTo(self);
//    }];
//    [self layoutIfNeeded];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat margin = 0.5;
    self.label.frame = (CGRect){0,0,CGRectGetWidth(self.frame),CGRectGetHeight(self.frame)-margin};
    self.bottomline.frame = (CGRect){0,CGRectGetMinY(self.label.frame)+CGRectGetHeight(self.label.frame),CGRectGetWidth(self.frame),margin};
    self.rightline.frame = (CGRect){CGRectGetWidth(self.bounds) - margin,0,margin,CGRectGetHeight(self.bounds)};
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
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
