//
//  UIButtonView.m
//  testDemo
//
//  Created by lignpeng on 2018/7/11.
//  Copyright © 2018年 genpeng. All rights reserved.
//

#import "UIButtonView.h"
#import "Masonry.h"
#import "HexColor.h"

@interface UIButtonView()

@property(nonatomic, strong) UILabel *namelabel;
@property(nonatomic, strong) UIButton *deletButton;
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, assign) BOOL status;//YES:显示删除按钮

@end

@implementation UIButtonView

+ (instancetype)buttonViewViewModel:(LabelModel *)model{
    UIButtonView *view = [UIButtonView new];
    [view initView];
    [view configCell:model];
    return view;
}

+ (UIView *)buttonViewWithFrame:(CGRect)frame Model:(LabelModel *)model {

    UIView *view = [UIView new];
    view.frame = frame;

    UILabel *label = [self namelabel];
    label.text = model.name;
    label.frame = view.bounds;
    label.layer.cornerRadius = CGRectGetWidth(frame) * 0.5;
    label.backgroundColor = [UIColor colorWith8BitRedN:arc4random()%256 green:arc4random()%256 blue:arc4random()%256 alpha:0.45];
    if (model.isImage) {
        UIImageView *imageView = [self imageView];
        imageView.image = [[UIImage alloc] initWithContentsOfFile:model.path];
        imageView.frame = view.bounds;
        imageView.layer.cornerRadius = CGRectGetWidth(frame) * 0.5;
        [view addSubview:imageView];
        label.backgroundColor = [UIColor clearColor];
    }
    
    [view addSubview:label];
    return view;
}

+ (instancetype)buttonViewWithTitle:(NSString *)title {
    UIButtonView *view = [[UIButtonView alloc] init];
    view.namelabel.text = title;
    return view;
}

- (void)configCell:(LabelModel *)model {
    self.imageView.hidden = !model.isImage;
    self.namelabel.hidden = model.isImage;
    self.deletButton.hidden = !model.isShowDelete;
    if (model.isImage) {
        self.imageView.image = [[UIImage alloc] initWithContentsOfFile:model.path];
    }else {
        self.namelabel.text = model.name;
    }
}

- (void)initView {
    self.clipsToBounds = YES;
    CGFloat commom = 64;
    self.backgroundColor = [UIColor clearColor];
    self.frame = (CGRect){0,0,commom,commom};
    [self addSubview:self.namelabel];
//    [self.namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self);
//        make.left.equalTo(self.mas_left);
//        make.right.equalTo(self.mas_right);
//        make.bottom.equalTo(self.mas_bottom);
//    }];
    
    [self addSubview:self.imageView];
//    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self);
//        make.left.equalTo(self.mas_left);
//        make.right.equalTo(self.mas_right);
//        make.bottom.equalTo(self.mas_bottom);
//    }];
    
//    [self addSubview:self.deletButton];
//    [self.deletButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.mas_top);
//        make.right.equalTo(self.mas_right);
//        make.width.height.mas_equalTo(20);
//    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.namelabel.frame = self.bounds;
    self.imageView.frame = self.bounds;
//    self.namelabel.layer.cornerRadius = CGRectGetWidth(self.bounds) *0.5;
//    self.imageView.layer.cornerRadius = CGRectGetWidth(self.bounds) *0.5;
}

- (void)updateFrame {
    self.layer.cornerRadius = CGRectGetWidth(self.bounds) *0.5;
//    self.namelabel.layer.cornerRadius = CGRectGetWidth(self.bounds) *0.5;
//    self.imageView.layer.cornerRadius = CGRectGetWidth(self.bounds) *0.5;
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

+ (UILabel *)namelabel {
    UILabel *_namelabel = [UILabel new];
//    _namelabel.textColor = [UIColor darkTextColor];
    _namelabel.textColor = [UIColor colorWith8BitRedN:arc4random()%256 green:arc4random()%256 blue:arc4random()%256];
    _namelabel.backgroundColor = [UIColor whiteColor];
    _namelabel.textAlignment = NSTextAlignmentCenter;
    _namelabel.font = [UIFont systemFontOfSize:14];
    _namelabel.clipsToBounds = YES;
    _namelabel.layer.borderWidth = 1;
    _namelabel.layer.borderColor = [[UIColor colorWith8BitRedN:arc4random()%256 green:arc4random()%256 blue:arc4random()%256] CGColor];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
//    tap.numberOfTapsRequired = 2;
//    [_namelabel addGestureRecognizer:tap];
    return _namelabel;
}

+ (UIImageView *)imageView {
    UIImageView *_imageView = [[UIImageView alloc] init];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.clipsToBounds = YES;
    _imageView.layer.borderWidth = 1;
    _imageView.layer.borderColor = [[UIColor colorWith8BitRedN:arc4random()%256 green:arc4random()%256 blue:arc4random()%256] CGColor];
    return _imageView;
}

- (UILabel *)namelabel {
    if (!_namelabel) {
        _namelabel = [UILabel new];
//        _namelabel.textColor = [UIColor darkTextColor];
        _namelabel.textColor = [UIColor colorWith8BitRedN:arc4random()%256 green:arc4random()%256 blue:arc4random()%256];
        _namelabel.backgroundColor = [UIColor whiteColor];
        _namelabel.textAlignment = NSTextAlignmentCenter;
        _namelabel.font = [UIFont systemFontOfSize:14];
        _namelabel.clipsToBounds = YES;
        _namelabel.layer.borderWidth = 1;
        _namelabel.layer.borderColor = [[UIColor colorWith8BitRedN:arc4random()%256 green:arc4random()%256 blue:arc4random()%256] CGColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        tap.numberOfTapsRequired = 2;
        [_namelabel addGestureRecognizer:tap];
    }
    return _namelabel;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.clipsToBounds = YES;
        _imageView.layer.borderWidth = 1;
        _imageView.layer.borderColor = [[UIColor colorWith8BitRedN:arc4random()%256 green:arc4random()%256 blue:arc4random()%256] CGColor];
    }
    return _imageView;
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
