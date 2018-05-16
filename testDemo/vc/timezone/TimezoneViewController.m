//
//  TimezoneViewController.m
//  testDemo
//
//  Created by lignpeng on 2018/5/8.
//  Copyright © 2018年 genpeng. All rights reserved.
//

#import "TimezoneViewController.h"

@interface TimezoneViewController ()

@property(nonatomic, strong) UILabel *label;

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
    UILabel *label = [[UILabel alloc] init];
    label.frame = (CGRect){margin,CGRectGetMinY(button.frame)+CGRectGetHeight(button.frame) +margin,CGRectGetWidth([UIScreen mainScreen].bounds) - margin * 2,margin};
    label.backgroundColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor lightTextColor];
    [self.view addSubview:label];
    self.label = label;
}

- (void)action {
    NSTimeZone *zone = [NSTimeZone localTimeZone];
    NSString *strZoneName = [zone name];
    NSString *strZoneAbbreviation = [zone abbreviation];
    if (![strZoneAbbreviation containsString:@":"]) {
        strZoneAbbreviation = [strZoneAbbreviation stringByAppendingString:@":00"];
    }
    NSString *str =[strZoneName stringByAppendingString:[NSString stringWithFormat:@"(%@)",strZoneAbbreviation]];
    NSLog(@"名称 是 %@",str);
    self.label.text = str;
}

@end
