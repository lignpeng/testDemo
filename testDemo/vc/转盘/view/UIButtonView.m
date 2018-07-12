//
//  UIButtonView.m
//  testDemo
//
//  Created by lignpeng on 2018/7/11.
//  Copyright © 2018年 genpeng. All rights reserved.
//

#import "UIButtonView.h"
#import "Masonry.h"

@interface UIButtonView()

@property(nonatomic, strong) UILabel *namelabel;
@property(nonatomic, strong) UIButton *deletButton;
@property(nonatomic, assign) BOOL status;//YES:显示删除按钮

@end

@implementation UIButtonView


+ (instancetype)buttonViewWithTitle:(NSString *)title {
    UIButtonView *view = [[UIButtonView alloc] init];
    view.namelabel.text = title;
    return view;
}

- (instancetype)init {
    if (self = [super init]) {
        [self initView];
    }
    return self;
}

- (void)initView {
    CGFloat commom = 64;
    self.backgroundColor = [UIColor clearColor];
    self.frame = (CGRect){0,0,commom,commom};
    [self addSubview:self.namelabel];
    [self.namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    [self addSubview:self.deletButton];
    [self.deletButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.right.equalTo(self.mas_right);
        make.width.height.mas_equalTo(20);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.namelabel.layer.cornerRadius = CGRectGetWidth(self.bounds);
}

- (void)tapAction {
    self.deletButton.hidden = !self.status;
    self.status = !self.status;
}

- (void)deletaction {
    if (self.deleteActionBlock) {
        self.deleteActionBlock(self.namelabel.text);
    }
}

- (UILabel *)namelabel {
    if (!_namelabel) {
        _namelabel = [UILabel new];
        _namelabel.textColor = [UIColor darkTextColor];
        _namelabel.textAlignment = NSTextAlignmentCenter;
        _namelabel.font = [UIFont systemFontOfSize:14];
        _namelabel.clipsToBounds = YES;
        _namelabel.layer.borderWidth = 1;
        _namelabel.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        tap.numberOfTapsRequired = 2;
        [_namelabel addGestureRecognizer:tap];
    }
    return _namelabel;
}

- (UIButton *)deletButton {
    if (!_deletButton) {
        _deletButton = [[UIButton alloc] init];
        [_deletButton setImage:[UIImage imageNamed:@"blue_delete"] forState:UIControlStateNormal];
        [_deletButton addTarget:self action:@selector(deletaction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deletButton;
}

@end
