//
//  UIURLAlertView.m
//
//  Created by lignpeng on 2018/6/11.
//  Copyright © 2018年 genpeng. All rights reserved.
//

#import "UIURLAlertView.h"

@interface UIURLAlertView ()

@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIView *holdView;
@property (nonatomic, strong) UIView *sepLine;
@property(nonatomic, strong) UILabel *tipLabel;
@property(nonatomic, strong) UIButton *okButton;
@property (nonatomic, assign) CGFloat detailHeight;

@end


@implementation UIURLAlertView

+ (instancetype)urlAlertView {
    UIURLAlertView *view = [[UIURLAlertView alloc] init];
//    [view initView];
    
    return view;
}

+ (instancetype)urlAlertView:(NSString *)fullString urlString:(NSString *)urlStr complish:(void(^)(BOOL flag))complishBlock {
    UIURLAlertView *view = [[UIURLAlertView alloc] init];
        //    [view initView];
    [view urlAlertViewString:fullString urlString:urlStr];
    return view;
}

+ (instancetype)urlAlertView:(NSString *)fullString urlString:(NSString *)urlStr buttonTitle:(NSString *)title complish:(void(^)(BOOL flag))complishBlock {
    UIURLAlertView *view = [[UIURLAlertView alloc] init];
        //    [view initView];
    [view setButtonTitle:title];
    [view urlAlertViewString:fullString urlString:urlStr];
    return view;
}

- (instancetype)init {
    if (self = [super init]) {
        [self initView];
    }
    return self;
}

- (void)initView {
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.frame = [UIScreen mainScreen].bounds;
    self.detailHeight = 40;
    self.holdView.layer.cornerRadius = 14;
    self.holdView.layer.masksToBounds = YES;
//    self.holdView.clipsToBounds = YES;
    [self.holdView addSubview:self.tipLabel];
    [self.holdView addSubview:self.detailLabel];
    [self.holdView addSubview:self.sepLine];
    [self.holdView addSubview:self.okButton];
    
    [self addSubview:self.holdView];
    
    [self show];
}

- (void)setButtonTitle:(NSString *)title {
    [self.okButton setTitle:title forState:UIControlStateNormal];
}

- (void)urlAlertViewString:(NSString *)fullString urlString:(NSString *)urlStr {
    UIFont *font = [UIFont systemFontOfSize:15];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:fullString attributes:@{NSFontAttributeName:font}];
    NSRange range = [[attributeString string] rangeOfString:urlStr];
    
    [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
    [attributeString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:1] range:range];
    [attributeString addAttribute:NSUnderlineColorAttributeName value:[UIColor redColor] range:range];
//
    self.detailLabel.attributedText = attributeString;
    CGSize titleSize = [fullString boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.frame) - 16*4, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    self.detailHeight = titleSize.height;
    [self layoutSubviews];

    
        //获取string的宽度
//    CGSize aaa =[fullString sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    
//    weakState(weakSelf, self);
//    [self.detailLabel addAttributeTapActionWithStrings:@[@"我的会员卡"] tapClicked:^(NSString *string, NSRange range, NSInteger index) {
//        __strong typeof(weakSelf) strongSelf = weakSelf;
//        if (strongSelf.tapClicked) {
//            [strongSelf dismiss];
//            strongSelf.tapClicked();
//        }
//    }];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat margin = 16;
    CGFloat buttonHeight = 44;
    CGFloat labelHeight = 20;
    //16+20++16+20*2+16+1+44
    CGRect frame = (CGRect){0,margin*2,CGRectGetWidth(self.frame)-margin*4,margin+labelHeight+margin+self.detailHeight+margin+1+buttonHeight};
    self.holdView.frame = frame;
    self.holdView.center = self.center;
    
    CGRect lframe = (CGRect){0,margin,CGRectGetWidth(frame),labelHeight};
    self.tipLabel.frame = lframe;
    
    lframe.origin.y += CGRectGetHeight(lframe) + margin;
    lframe.origin.x += margin;
    lframe.size.height = self.detailHeight;
    lframe.size.width -= margin*2;
    self.detailLabel.frame = lframe;
    
    lframe.origin.y += CGRectGetHeight(lframe) + margin;
    lframe.origin.x -= margin;
    lframe.size.height = 1;
    lframe.size.width += margin*2;
    self.sepLine.frame = lframe;
    
    lframe.origin.y += CGRectGetHeight(lframe);
    lframe.size.height = buttonHeight;
    
    self.okButton.frame = lframe;
    
}

- (void)okAction {
    [self dismiss];
}

- (void)show {
//    [self.coverView addSubview:self];
//    [self mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self.coverView).offset(16);
//        make.trailing.equalTo(self.coverView).offset(-16);
//        make.center.equalTo(self.coverView);
//        make.height.mas_equalTo(160);
//    }];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)dismiss {
    if ([[UIApplication sharedApplication].keyWindow.subviews containsObject:self]) {
        [self removeFromSuperview];
    }
}

- (UIView *)holdView {
    if (!_holdView) {
        _holdView = [[UIView alloc] init];
        _holdView.backgroundColor = [UIColor whiteColor];
        _holdView.frame = (CGRect){0,0,120,64};
    }
    return _holdView;
}


- (UIView *)sepLine {
    if (!_sepLine) {
        _sepLine = [UIView new];
        _sepLine.frame = (CGRect){0,0,1,1};
        _sepLine.backgroundColor = [UIColor grayColor];
    }
    return _sepLine;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = [UIFont systemFontOfSize:14];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.textColor = [UIColor blackColor];
        _detailLabel.numberOfLines = 0;
    }
    return _detailLabel;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.font = [UIFont systemFontOfSize:15];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.text = @"提示";
        _tipLabel.textColor = [UIColor blackColor];
//        _tipLabel.backgroundColor = [UIColor yellowColor];
    }
    return _tipLabel;
}

- (UIButton *)okButton {
    if (!_okButton) {
        _okButton = [UIButton new];
//        _okButton.backgroundColor = [UIColor colorWithRed:229.0/255.0 green:0 blue:74.0/255.0 alpha:1];
//        _okButton.backgroundColor = [UIColor blueColor];
        [_okButton setTitle:@"确定" forState:UIControlStateNormal];
        [_okButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _okButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [_okButton addTarget:self action:@selector(okAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _okButton;
}

@end
