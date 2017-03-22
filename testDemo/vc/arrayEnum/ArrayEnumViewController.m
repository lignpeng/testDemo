//
//  ArrayEnumViewController.m
//  testDemo
//
//  Created by lignpeng on 17/1/4.
//  Copyright © 2017年 genpeng. All rights reserved.
//

#import "ArrayEnumViewController.h"

@interface ArrayEnumViewController ()

@end

@implementation ArrayEnumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect frame = [UIScreen mainScreen].bounds;
    CGFloat margin = 32;
    CGFloat wdith = (CGRectGetWidth(frame) - 2 * margin);
    CGFloat height = 42;
    
    CGRect bframe = CGRectMake(margin, margin + 64, wdith, height);
    UIButton *showBtn = ({
        UIButton *btn = [[UIButton alloc] initWithFrame:bframe];
        btn.backgroundColor = [UIColor blueColor];
        [btn setTitle:@"show" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(showAction) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.cornerRadius = 5.0;
        btn.clipsToBounds = YES;
        btn;
    });
    [self.view addSubview:showBtn];
}

- (void)showAction {
    NSArray *tArray = @[@"身份证验证",@"扩展view",@"nil、NULL的区别",@"tableViewCell传：nil",@"图片旋转",@"倒计时60s",@"腾讯 GT",@"选座排座",@"数组枚举"];
    [tArray enumerateObjectsUsingBlock:^(NSString *_Nonnull str, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%@ : %lu",str,(unsigned long)idx);
        if (idx > 3) {
            *stop = YES;
        }
    }];
    
}

@end
