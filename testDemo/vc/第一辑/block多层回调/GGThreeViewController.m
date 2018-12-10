//
//  GGThreeViewController.m
//  testDemo
//
//  Created by lignpeng on 2017/8/30.
//  Copyright © 2017年 genpeng. All rights reserved.
//

#import "GGThreeViewController.h"

@interface GGThreeViewController ()

@end

@implementation GGThreeViewController

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
    
    if (self.delegate) {
        [self.navigationController popToViewController:self.delegate animated:YES];
//        [self.navigationController popToRootViewControllerAnimated:YES];
//        [self.navigationController popViewControllerAnimated:YES];
    }
    if (self.actionBlock) {
        self.actionBlock();
    }
}
@end
