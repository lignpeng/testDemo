//
//  GGWebMenuViewCell.m
//  testDemo
//
//  Created by lignpeng on 2019/1/18.
//  Copyright © 2019年 genpeng. All rights reserved.
//

#import "GGWebMenuViewCell.h"
#import "Masonry.h"

@interface GGWebMenuViewCell()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIView *holderView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property(nonatomic, strong) GGWebMenuModel *model;

@end

@implementation GGWebMenuViewCell

+ (instancetype)cellForCollectionView:(UICollectionView *)collectionView IndexPath:(NSIndexPath *)indexPath {
    GGWebMenuViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:webMenuViewCellId forIndexPath:indexPath];
    cell.indexPath = indexPath;
    return cell;
}

- (void)configCell:(GGWebMenuModel *)model {
    self.model = model;
    self.label.text = model.title;
    self.imageView.image = [UIImage imageNamed:model.image];
}

- (GGWebMenuModel *)getWebMenuModel {
    return self.model;
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
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.label];
    [self addSubview:self.holderView];
    [self.holderView addSubview:self.imageView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat margin = 2;
    CGRect frame = self.bounds;
    CGFloat width = CGRectGetWidth(frame) - 2*margin;
    CGRect hframe = (CGRect){margin,margin,width,width};
    self.holderView.frame = hframe;
    CGFloat imargin = 8;
    self.imageView.frame = (CGRect){imargin,imargin,width-imargin,width-imargin};
    
    CGFloat y = CGRectGetMinY(hframe)+width+margin;
    self.label.frame = (CGRect){margin, y, width, CGRectGetHeight(frame) - y - margin};
}

- (UIView *)holderView {
    if (!_holderView) {
        _holderView = [UIView new];
        _holderView.backgroundColor = [UIColor whiteColor];
        _holderView.clipsToBounds = YES;
        _holderView.layer.cornerRadius = 3;
    }
    return _holderView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.frame = CGRectZero;
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:12];
        _label.textColor = [UIColor darkTextColor];
        _label.numberOfLines = 0;
    }
    return _label;
}


@end
