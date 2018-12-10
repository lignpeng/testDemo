//
//  CSBrowsingHistoryTypeView.m
//  testDemo
//
//  Created by lignpeng on 2017/11/14.
//  Copyright © 2017年 genpeng. All rights reserved.
//

#import "CSBrowsingHistoryTypeView.h"
#define viewAlpha 0.3
#import "Masonry.h"
#import "HexColor.h"

@interface CSBrowsingHistoryTypeView()

@property(nonatomic, weak) UIViewController *delegate;
@property(nonatomic, strong) UIView *holderView;
@property(nonatomic, strong) UIButton *backButton;
@property(nonatomic, assign) NSInteger selectType;
@property(nonatomic, copy) void (^selectTypeBlock)(BrowsingType type);
@property(nonatomic, copy) void (^dismissBlock)();
@end

@implementation CSBrowsingHistoryTypeView

//弹出选择页
+ (void)showBrowsingHistoryTypeViewWithDelegate:(UIViewController *)delegate Type:(BrowsingType )selectType complishBlock:(void(^)(BrowsingType type))complishBlock dismissBlock:(void(^)())dismissBlock{
    if ([self removeBrowsingHistoryTypeView:delegate]) {
        return;
    }
    CSBrowsingHistoryTypeView *view = [CSBrowsingHistoryTypeView new];
    view.delegate = delegate;
    view.selectType = selectType;
    view.selectTypeBlock = complishBlock;
    view.dismissBlock = dismissBlock;
    [view show];
}

+ (BOOL)isBrowsingHistoryTypeViewShow:(UIViewController *)delegate {
    BOOL hasShow = NO;
    for (UIView *view in delegate.view.subviews) {
        if ([view isKindOfClass:[self class]]) {
            hasShow = YES;
            break;
        }
    }
    return hasShow;
}

+ (BOOL)removeBrowsingHistoryTypeView:(UIViewController *)delegate {
    BOOL hasShow = NO;
    for (UIView *view in delegate.view.subviews) {
        if ([view isKindOfClass:[self class]]) {
            [view removeFromSuperview];
            hasShow = YES;
            break;
        }
    }
    return hasShow;
}

- (void)show {
//    self.delegate.navigationItem.rightBarButtonItem.enabled = NO;
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    [self.delegate.view addSubview:self];
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:viewAlpha];
    }];
    [self initView];
    [self addSubButton];
}

- (void)dismiss {
//    self.delegate.navigationItem.rightBarButtonItem.enabled = YES;
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

- (void)initView {
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    CGRect statusFrame = [[UIApplication sharedApplication] statusBarFrame];
    CGRect navframe = self.delegate.navigationController.navigationBar.frame;
    CGRect sframe = [UIScreen mainScreen].bounds;
    sframe.origin.y += CGRectGetHeight(statusFrame) + CGRectGetHeight(navframe);
    sframe.size.height -= CGRectGetMinY(sframe);
    self.frame = sframe;
    [self addSubview:self.holderView];
    [self.holderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.leading.equalTo(self);
        make.trailing.equalTo(self);
        make.height.mas_equalTo(87);
    }];
    [self addSubview:self.backButton];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.holderView.mas_bottom);
        make.leading.equalTo(self);
        make.trailing.equalTo(self);
        make.bottom.equalTo(self.mas_bottom);
    }];
}

- (void)addSubButton {
    CGFloat margin = 15;
    NSUInteger count = 3;
    CGFloat hight = margin*2 +7;
    CGFloat width = (CGRectGetWidth([UIScreen mainScreen].bounds) - (count + 1)*margin)/count;
    NSArray *titleArray = @[@"全部",@"机票搜索",@"航班动态"];
    CGRect bframe = (CGRect){margin+10,margin+10,width,hight};
    for (int i = 0;i < count; i++) {
        bframe.origin.x += (i == 0 ? 0 : (margin + width));
        UIButton *button = [[UIButton alloc] initWithFrame:bframe];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        if (i == self.selectType) {
            button.backgroundColor = [HXColor colorWith8BitRed:0 green:138 blue:203];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else {
            button.backgroundColor = [HXColor colorWith8BitRed:232 green:236 blue:239];
            button.layer.borderColor = [HXColor colorWith8BitRed:161 green:168 blue:165].CGColor;
            button.layer.borderWidth = 0.5;
            [button setTitleColor:[HXColor colorWith8BitRed:77 green:77 blue:77] forState:UIControlStateNormal];
        }
        button.layer.cornerRadius = hight * 0.5;
        button.clipsToBounds = YES;
        button.tag = i;
        [button addTarget:self action:@selector(selectTypeAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.holderView addSubview:button];
    }
}

- (void)selectTypeAction:(UIButton *)button {
    if (self.selectTypeBlock) {
        self.selectTypeBlock(button.tag);
    }
    [self dismiss];
}


- (UIView *)holderView {
    if (!_holderView) {
        _holderView = [UIView new];
        _holderView.backgroundColor = [UIColor whiteColor];
    }
    return _holderView;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [[UIButton alloc] initWithFrame:CGRectZero];
        _backButton.backgroundColor = [UIColor clearColor];
        [_backButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

@end









