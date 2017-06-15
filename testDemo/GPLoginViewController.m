//
//  GPLoginViewController.m
//  testDemo
//
//  Created by lignpeng on 17/3/28.
//  Copyright © 2017年 genpeng. All rights reserved.
//

#import "GPLoginViewController.h"
#import "GPTools.h"
#import "UIViewController+Login.h"

@interface GPLoginViewController ()

@end

@implementation GPLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [GPTools ShowAlert:@""];
    [self initView];
    [self showAction];
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
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
}

- (void)showAction {
    if ([self.delegate respondsToSelector:@selector(loginViewControllerDidSuccessLogin)]) {
        [self.delegate loginViewControllerDidSuccessLogin];
    }
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

@end
