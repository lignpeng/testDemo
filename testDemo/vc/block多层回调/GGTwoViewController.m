//
//  GGTwoViewController.m
//  testDemo
//
//  Created by lignpeng on 2017/8/19.
//  Copyright © 2017年 genpeng. All rights reserved.
//

#import "GGTwoViewController.h"
#import "GGThreeViewController.h"

@interface GGTwoViewController ()

@end

@implementation GGTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat margin = 32;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(margin, margin * 3, CGRectGetWidth([UIScreen mainScreen].bounds) - margin * 2, 42)];
    [button addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"第二个VC" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorWithRed:3/255.0 green:223/255.0 blue:71/255.0 alpha:1];
    button.layer.cornerRadius = 5;
    button.clipsToBounds = YES;
    [self.view addSubview:button];
}

- (void)action {
    GGThreeViewController *vc = [GGThreeViewController new];
    __weak typeof(self) weakSelf = self;
//    vc.actionBlock = ^{
//        __block typeof(weakSelf) strongSelf = weakSelf;
//        
//        if (strongSelf.actionBlock) {
//            strongSelf.actionBlock();
//        }
//        [strongSelf.navigationController popViewControllerAnimated:YES];
//    };
    vc.actionBlock = self.actionBlock;
    vc.delegate = self.delegate;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
