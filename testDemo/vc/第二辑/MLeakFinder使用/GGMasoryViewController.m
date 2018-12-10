//
//  GGMasoryViewController.m
//  testDemo
//
//  Created by lignpeng on 2017/9/20.
//  Copyright © 2017年 genpeng. All rights reserved.
//

#import "GGMasoryViewController.h"
#import "Masonry.h"

@interface GGMasoryViewController ()

@end

@implementation GGMasoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat margin = 32;
    //CGRectMake(margin, margin * 3, CGRectGetWidth([UIScreen mainScreen].bounds) - margin * 2, 42)
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
    [button addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"action" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorWithRed:3/255.0 green:223/255.0 blue:71/255.0 alpha:1];
    button.layer.cornerRadius = 5;
    button.clipsToBounds = YES;
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(margin * 3);
        make.leading.equalTo(self.view).offset(margin * 3);
        make.trailing.equalTo(self.view).offset(- margin * 3);
        make.height.mas_equalTo(42);
    }];
    
    NSMutableArray *arr1 = [NSMutableArray array];
    NSMutableArray *arr2 = [NSMutableArray array];
    
    [arr1 addObject:arr2];
    [arr2 addObject:arr1];
    
}

- (void)action {
    NSLog(@"self = %@",[self class]);
}

@end
