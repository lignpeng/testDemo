//
//  TimezoneViewController.m
//  testDemo
//
//  Created by lignpeng on 2018/5/8.
//  Copyright © 2018年 genpeng. All rights reserved.
//

#import "TimezoneViewController.h"

@interface TimezoneViewController ()

@end

@implementation TimezoneViewController

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
    NSTimeZone *zone = [NSTimeZone localTimeZone];
    NSString *strZoneName = [zone name];
    NSString *strZoneAbbreviation = [zone abbreviation];
    NSString *str =[strZoneName stringByAppendingString:[NSString stringWithFormat:@"(%@)",strZoneAbbreviation]];
    NSLog(@"名称 是 %@",str);
}

@end
