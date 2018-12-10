//
//  GGDelegateViewController.m
//  testDemo
//
//  Created by lignpeng on 2017/9/20.
//  Copyright © 2017年 genpeng. All rights reserved.
//

#import "GGDelegateViewController.h"

@interface GGDelegateViewController ()

@end

@implementation GGDelegateViewController

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
}

- (void)action {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    
}

@end
