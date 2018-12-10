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

+ (UIView *)buttonViewWithFrame:(CGRect)frame Model:(LabelModel *)model {

    UIView *view = [UIView new];
    view.frame = frame;

    UILabel *label = [self namelabel];
    label.text = model.name;
    label.frame = view.bounds;
    label.layer.cornerRadius = CGRectGetWidth(frame) * 0.5;
    label.backgroundColor = [UIColor colorWith8BitRed:arc4random()%256 green:arc4random()%256 blue:arc4random()%256 alpha:0.45];
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

+ (UILabel *)namelabel {
    UILabel *_namelabel = [UILabel new];
    _namelabel.textColor = [UIColor colorWith8BitRed:arc4random()%256 green:arc4random()%256 blue:arc4random()%256];
    _namelabel.backgroundColor = [UIColor whiteColor];
    _namelabel.textAlignment = NSTextAlignmentCenter;
    _namelabel.font = [UIFont systemFontOfSize:14];
    _namelabel.numberOfLines = 0;
    _namelabel.clipsToBounds = YES;
    _namelabel.layer.borderWidth = 1;
    _namelabel.layer.borderColor = [[UIColor colorWith8BitRed:arc4random()%256 green:arc4random()%256 blue:arc4random()%256] CGColor];
    return _namelabel;
}

+ (UIImageView *)imageView {
    UIImageView *_imageView = [[UIImageView alloc] init];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.clipsToBounds = YES;
    _imageView.layer.borderWidth = 1;
    _imageView.layer.borderColor = [[UIColor colorWith8BitRed:arc4random()%256 green:arc4random()%256 blue:arc4random()%256] CGColor];
    return _imageView;
}

@end
