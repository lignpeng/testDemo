//
//  CSVIPDayADsView.m
//  testDemo
//
//  Created by lignpeng on 2017/8/30.
//  Copyright © 2017年 genpeng. All rights reserved.
//

#import "CSVIPDayADsView.h"
#import "Masonry.h"
#import "GGDateViewController.h"
#import "GPTools.h"

#define viewWidth 280.0f
#define margin 16.0f

@interface CSVIPDayADsView()

@property(nonatomic, strong) UIView *holderView;
@property(nonatomic, strong) UIImageView *vipDayImageView;
@property(nonatomic, strong) UILabel *infoLabel;
@property(nonatomic, strong) UIButton *authButton;
@property(nonatomic, strong) UIButton *cancelButton;

@end

@implementation CSVIPDayADsView

+ (void)showVIPDayADs {
    CSVIPDayADsView *view = [CSVIPDayADsView new];
    [view show];
}

- (instancetype)init {
    if (self = [super init]) {
        [self initView];
    }
    return self;
}

- (void)show {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    [window addSubview:self];
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    }];
}

- (void)dismiss {
    
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)initView {
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    self.frame = [UIScreen mainScreen].bounds;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self addGestureRecognizer:gesture];
    //1、holderview
    [self addSubview:self.holderView];
    CGFloat vheight = CGRectGetHeight([UIScreen mainScreen].bounds);
    vheight -= CGRectGetHeight(self.holderView.frame);
    vheight -= 44;
    vheight -= CGRectGetHeight(self.cancelButton.frame);
    [self.holderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(vheight * 0.5);
        make.width.mas_equalTo(CGRectGetWidth(self.holderView.frame));
        make.height.mas_equalTo(CGRectGetHeight(self.holderView.frame));
    }];
    //2、图片
    [self.holderView addSubview:self.vipDayImageView];
    [self.vipDayImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.holderView);
        make.trailing.equalTo(self.holderView);
        make.leading.equalTo(self.holderView);
        make.height.mas_equalTo(CGRectGetHeight(self.vipDayImageView.frame));
    }];
    //3、提示语
    [self.holderView addSubview:self.infoLabel];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.vipDayImageView.mas_bottom).offset(24);
        make.centerX.equalTo(self.holderView);
        make.width.mas_equalTo(CGRectGetWidth(self.infoLabel.frame));
        make.height.mas_equalTo(CGRectGetHeight(self.infoLabel.frame));
    }];
    //4、认证按钮
    [self.holderView addSubview:self.authButton];
    [self.authButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infoLabel.mas_bottom).offset(22);
        make.centerX.equalTo(self.holderView);
        make.width.mas_equalTo(CGRectGetWidth(self.authButton.frame));
        make.height.mas_equalTo(CGRectGetHeight(self.authButton.frame));
    }];
    //5、取消按钮
    [self addSubview:self.cancelButton];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.holderView.mas_bottom).offset(44);
        make.centerX.equalTo(self);
        make.width.mas_equalTo(CGRectGetWidth(self.cancelButton.frame));
        make.height.mas_equalTo(CGRectGetHeight(self.cancelButton.frame));
    }];
}

- (void)authAction {
    GGDateViewController *vv = [GGDateViewController new];
    UIViewController *vc = [GPTools getCurrentViewController];
    if ([vc isKindOfClass:[UINavigationController class]]) {
        [(UINavigationController *)vc pushViewController:vv animated:YES];
    }else {
        [vc.navigationController pushViewController:vv animated:YES];
    }
    
    [self dismiss];
}

- (CGSize)caculateSize {
    CGSize size = CGSizeZero;
    size.width = viewWidth;
    size.height += CGRectGetHeight(self.vipDayImageView.frame);
    size.height += 24;
    size.height += CGRectGetHeight(self.infoLabel.frame);
    size.height += 22;
    size.height += CGRectGetHeight(self.authButton.frame);
    size.height += 36;
    return size;
}

- (UIView *)holderView {
    if (!_holderView) {
        _holderView = [UIView new];
        _holderView.clipsToBounds = YES;
        _holderView.layer.cornerRadius = 15;
        _holderView.backgroundColor = [UIColor whiteColor];
        CGRect frame = CGRectZero;
        frame.size = [self caculateSize];
        _holderView.frame = frame;
    }
    return _holderView;
}

- (UIImageView *)vipDayImageView {
    if (!_vipDayImageView) {
        _vipDayImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vipDay"]];
        CGRect frame = CGRectZero;
        frame.size = CGSizeMake(viewWidth, viewWidth * 9.0 / 16.0);
        _vipDayImageView.frame = frame;
    }
    return _vipDayImageView;
}

- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [UILabel new];
        _infoLabel.font = [UIFont systemFontOfSize:16];
        _infoLabel.textColor = [UIColor colorWithRed:0 green:35.0/255.0 blue:78.0/255.0 alpha:1];
        _infoLabel.text = @"每月28日南航会员日，会员专属优惠机票等您来抢！提前完成实名认证，机票抢先购！";
        _infoLabel.numberOfLines = 0;
        CGRect frame = CGRectZero;
        frame.size = [CSVIPDayADsView boundingALLRectWithSize:_infoLabel.text Font:_infoLabel.font Size:CGSizeMake(viewWidth - margin * 2, CGFLOAT_MAX)];
        _infoLabel.frame = frame;
    }
    return _infoLabel;
}

- (UIButton *)authButton {
    if (!_authButton) {
        _authButton = [UIButton new];
        _authButton.backgroundColor = [UIColor colorWithRed:229.0/255.0 green:0 blue:74.0/255.0 alpha:1];
        [_authButton setTitle:@"实名认证" forState:UIControlStateNormal];
        [_authButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _authButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [_authButton addTarget:self action:@selector(authAction) forControlEvents:UIControlEventTouchUpInside];
        CGRect frame = CGRectZero;
        frame.size = CGSizeMake(viewWidth - margin * 2, 36);
        _authButton.frame = frame;
        _authButton.clipsToBounds = YES;
        _authButton.layer.cornerRadius = frame.size.height * 0.5;
    }
    return _authButton;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton new];
        _cancelButton.layer.borderWidth = 1.5;
        _cancelButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _cancelButton.backgroundColor = [UIColor clearColor];
        [_cancelButton setTitle:@"残忍拒绝" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        CGRect frame = CGRectZero;
        frame.size = CGSizeMake(100, 30);
        _cancelButton.frame = frame;
        _cancelButton.clipsToBounds = YES;
        _cancelButton.layer.cornerRadius = frame.size.height * 0.5;
    }
    return _cancelButton;
}

+ (CGSize)boundingALLRectWithSize:(NSString*)txt Font:(UIFont*)font Size:(CGSize)size {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:txt];
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    [style setLineSpacing:2.0f];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, [txt length])];
    CGRect textRect = [txt boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:style} context:nil];
    CGSize realSize = CGSizeZero;
    realSize = textRect.size;
    realSize.width = ceilf(realSize.width);
    realSize.height = ceilf(realSize.height);
    return realSize;
}

@end
