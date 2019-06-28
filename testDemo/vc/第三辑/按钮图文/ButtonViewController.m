//
//  ButtonViewController.m
//  testDemo
//
//  Created by lignpeng on 2019/6/27.
//  Copyright © 2019 genpeng. All rights reserved.
//

#import "ButtonViewController.h"
#import "DataTools.h"
#import "HexColor.h"


typedef NS_ENUM(NSInteger, ButtonType) {
    ButtonTypeleft,//文字左
    ButtonTypeRight,//文字右
    ButtonTypeTop,//文字上
    ButtonTypeBottom//底部
};

@interface ButtonViewController ()

@property(nonatomic, strong) UITextView *textView;

@end

@implementation ButtonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat margin = 32;
    CGRect sframe = [UIScreen mainScreen].bounds;
    CGRect bframe = CGRectMake(margin, margin * 3, CGRectGetWidth(sframe) - margin * 2, 100);
    UIButton *button = [self createButton:bframe];
    [self.view addSubview:button];
    [self ddbutton:button type:ButtonTypeleft];
    CGFloat y = CGRectGetHeight(bframe) + CGRectGetMinY(bframe) + margin * 0.25;
    bframe.origin.y = y;
    UIButton *leftButton = [self createButton:bframe];
    [self.view addSubview:leftButton];
    [self ddbutton:leftButton type:ButtonTypeRight];
    
    y = CGRectGetHeight(bframe) + CGRectGetMinY(bframe) + margin * 0.25;
    bframe.origin.y = y;
    UIButton *topButton = [self createButton:bframe];
    [self.view addSubview:topButton];
    [self ddbutton:topButton type:ButtonTypeBottom];
    
    y = CGRectGetHeight(bframe) + CGRectGetMinY(bframe) + margin * 0.25;
    bframe.origin.y = y;
    UIButton *bottomButton = [self createButton:bframe];
    [self.view addSubview:bottomButton];
    [self ddbutton:bottomButton type:ButtonTypeTop];
}

- (UIButton *)createButton:(CGRect)frame {
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"action" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorWith8BitRed:arc4random()%256 green:arc4random()%256 blue:arc4random()%256];
    button.layer.cornerRadius = 5;
    button.clipsToBounds = YES;
    [button setImage:[UIImage imageNamed:@"dropbox_r"] forState:0];
    
    return button;
}

- (void)ddbutton:(UIButton *)btn type:(ButtonType)type {
    //间距
    CGFloat space = 20;
    //得到图片和标题的宽高
    CGFloat imageWidth = CGRectGetWidth(btn.imageView.frame);
    CGFloat imageHeight = CGRectGetHeight(btn.imageView.frame);
    CGFloat titleWidth = CGRectGetWidth(btn.titleLabel.frame);
    CGFloat titleHeight = CGRectGetHeight(btn.titleLabel.frame);
    switch (type) {
        case ButtonTypeleft:{//文字左边
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0 + (titleWidth + space / 2), 0, 0 - (titleWidth + space / 2));
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0 - (imageWidth + space / 2), 0, 0 + (imageWidth + space / 2));
        }break;
        case ButtonTypeRight:{//文字右边
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0 - space / 2, 0, 0 + space / 2);
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0 + space / 2, 0, 0 - space / 2);
        }break;
        case ButtonTypeTop:{//文字顶部
            btn.imageEdgeInsets = UIEdgeInsetsMake(0 + (titleHeight / 2.0 + space / 2), 0 + (imageWidth + titleWidth) / 4.0, 0 - (titleHeight / 2.0 + space / 2), 0 - (imageWidth + titleWidth) / 4.0);
            btn.titleEdgeInsets = UIEdgeInsetsMake(0 - (imageHeight / 2.0 + space / 2), 0 - (imageWidth + titleWidth) / 4.0, 0 + (imageHeight / 2.0 + space / 2), 0 + (imageWidth + titleWidth) / 4.0);
        }break;
        case ButtonTypeBottom:{//文字底部
            btn.imageEdgeInsets = UIEdgeInsetsMake(0 - (titleHeight / 2.0 + space / 2), 0 + (imageWidth + titleWidth) / 4.0, 0 + (titleHeight / 2.0 + space / 2), 0 - (imageWidth + titleWidth) / 4.0);
            btn.titleEdgeInsets = UIEdgeInsetsMake(0 + (imageHeight / 2.0 + space / 2), 0 - (imageWidth + titleWidth) / 4.0, 0 - (imageHeight / 2.0 + space / 2), 0 + (imageWidth + titleWidth) / 4.0);
        }break;
        default:
            break;
    }
}


- (void)action {
    //    do something.
}

- (void)showString:(NSArray *)array {
    NSString *str = @"";
    for (NSString *string in array) {
        str = [str stringByAppendingFormat:@"\n%@",string];
    }
    self.textView.text = str;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [UITextView new];
        _textView.font = [UIFont systemFontOfSize:14];
        _textView.showsHorizontalScrollIndicator = NO;
        _textView.editable = NO;
        _textView.textAlignment = NSTextAlignmentLeft;
    }
    return _textView;
}

@end
