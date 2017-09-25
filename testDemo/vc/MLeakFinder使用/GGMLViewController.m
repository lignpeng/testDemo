//
//  GGMLViewController.m
//  testDemo
//
//  Created by lignpeng on 2017/9/19.
//  Copyright © 2017年 genpeng. All rights reserved.
//

#import "GGMLViewController.h"

@interface GGMLViewController ()

@end

@implementation GGMLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat margin = 32;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(margin, margin * 3, CGRectGetWidth([UIScreen mainScreen].bounds) - margin * 2, 42)];
    [button addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"action" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorWithRed:3/255.0 green:223/255.0 blue:71/255.0 alpha:1];
    button.layer.cornerRadius = 5;
    button.clipsToBounds = YES;
    [self.view addSubview:button];
    self.actionBlock = ^(){
        [self ddd];
    };
}

- (void)action {
    if (self.actionBlock) {
        self.actionBlock();
    }
}

- (void)ddd {
    NSLog(@"**********");
}

@end
