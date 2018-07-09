//
//  GGStringViewController.m
//  testDemo
//
//  Created by lignpeng on 2018/1/10.
//  Copyright © 2018年 genpeng. All rights reserved.
//

#import "GGStringViewController.h"

@interface GGStringViewController ()

@end

@implementation GGStringViewController

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
    NSArray *array = @[@"123sdf",@"45sfe6释放",@"af/ef"];
    NSLog(@"containt 123 = %d",[array containsObject:@"123"]);
    NSLog(@"containt 23 = %d",[array containsObject:@"23"]);
    NSLog(@"containt 13 = %d",[array containsObject:@"13"]);
    for (NSString *title in array) {
        NSLog(@"%@:%@",title,[title uppercaseString]);
    }
}

@end
