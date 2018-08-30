//
//  UIImageViewController.m
//  testDemo
//
//  Created by lignpeng on 2018/8/29.
//  Copyright © 2018年 genpeng. All rights reserved.
//

#import "UIImageViewController.h"
#import "GPTools.h"

@interface UIImageViewController ()

@end

@implementation UIImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:imageView];
    imageView.image = self.image;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self initView];
}

- (void)initView {
    UIButton *button = [GPTools createButton:@"确定" titleFont:nil corner:0 target:self action:@selector(okAction)];

    [self.view addSubview:button];
    
    CGRect vframe = self.view.bounds;
    CGFloat height = 48;
    CGFloat width = 80;
    button.frame = (CGRect){CGRectGetWidth(vframe)-width,CGRectGetHeight(vframe)-height,width,height};
}

- (void)okAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
