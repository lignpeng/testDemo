//
//  CSBrowingHistoryBlankView.m
//  testDemo
//
//  Created by lignpeng on 2017/11/16.
//  Copyright © 2017年 genpeng. All rights reserved.
//

#import "CSBrowingHistoryBlankView.h"
#import "Masonry.h"
#import "HexColor.h"

@interface CSBrowingHistoryBlankView()

@property(nonatomic, strong) UIImageView *blankInfoImageView;
@property(nonatomic, strong) UIImage *infoImage;
@property(nonatomic, strong) UILabel *infoLabel;
@property(nonatomic, weak) UIViewController *delegate;

@end

@implementation CSBrowingHistoryBlankView

+ (void)showWithTitle:(NSString *)title delegate:(UIViewController *)delegate {
    [self dismissWithDelegate:delegate];
    CSBrowingHistoryBlankView *view = [CSBrowingHistoryBlankView new];
    view.delegate = delegate;
    view.infoLabel.text = title;
    [view show];
}
+ (void)dismissWithDelegate:(UIViewController *)delegate {
    for (UIView *view in delegate.view.subviews) {
        if ([view isKindOfClass:[self class]]) {
            [view removeFromSuperview];
            break;
        }
    }
}

- (void)show {
    [self.delegate.view addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.delegate.view);
        make.leading.equalTo(self.delegate.view);
        make.trailing.equalTo(self.delegate.view);
        make.bottom.equalTo(self.delegate.view.mas_bottom);
    }];
}

- (instancetype)init {
    if (self = [super init]) {
        [self initView];
    }
    return self;
}

- (void)initView {
    self.backgroundColor = [HXColor colorWith8BitRed:239 green:242 blue:245];
    self.frame = [UIScreen mainScreen].bounds;
    [self addSubview:self.blankInfoImageView];
    [self.blankInfoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(195);
        make.width.mas_equalTo(self.infoImage.size.width);
        make.height.mas_equalTo(self.infoImage.size.width);
    }];
    [self addSubview:self.infoLabel];
    CGFloat margin = 16;
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.blankInfoImageView.mas_bottom).offset(margin);
        make.trailing.equalTo(self).offset(-margin);
        make.leading.equalTo(self).offset(margin);
        make.height.mas_equalTo(20);
    }];
}

- (UIView *)blankInfoImageView {
    if (!_blankInfoImageView) {
        _blankInfoImageView = [[UIImageView alloc] initWithImage:self.infoImage];
    }
    return _blankInfoImageView;
}

- (UIImage *)infoImage {
    if (!_infoImage) {
        _infoImage = [UIImage imageNamed:@"icon_qs"];
    }
    return _infoImage;
}

- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _infoLabel.backgroundColor = [UIColor clearColor];
        _infoLabel.font = [UIFont systemFontOfSize:14];
        _infoLabel.textColor = [UIColor colorWithRed:77.0/255 green:77.0/255 blue:77.0/255 alpha:1];
        _infoLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _infoLabel;
}

@end
