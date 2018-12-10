//
//  GPPopViewController.m
//  testDemo
//
//  Created by lignpeng on 17/3/28.
//  Copyright © 2017年 genpeng. All rights reserved.
//

#import "GPPopViewController.h"
#import "GPLoginViewController.h"
#import "GPPopNavigationController.h"
#import "UIViewController+Login.h"
#import "GPTools.h"

@interface GPPopViewController ()<LoginDelegate>

@end

@implementation GPPopViewController

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
        [btn setTitle:@"模拟弹出登录界面" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(showAction) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.cornerRadius = 5.0;
        btn.clipsToBounds = YES;
        btn;
    });
    [self.view addSubview:showBtn];
}

- (void)showAction {
    NSLog(@"模拟弹出登录界面");
    GPLoginViewController *login = [GPLoginViewController new];
    login.delegate = self;
    GPPopNavigationController *navi = [[GPPopNavigationController alloc] initWithRootViewController:login];
    __weak typeof(self) weakSelf = self;
    [self presentViewController:navi animated:YES completion:^{
        UINavigationController *vc = (UINavigationController *)weakSelf.presentedViewController;
        NSLog(@"vc: %@",vc);
        NSLog(@"topViewController: %@",vc.topViewController);
        NSLog(@"visibleViewController: %@",vc.visibleViewController);
    }];
    
    
//    UINavigationController *vc = self.navigationController;
//    NSLog(@"self: %@",self);
//    NSLog(@"vc: %@",vc);
//    NSLog(@"topViewController: %@",vc.topViewController);
//    NSLog(@"visibleViewController: %@",vc.visibleViewController);
//    NSLog(@"-----------");
//    [self presentLoginViewController];
}

- (void)loginViewControllerDidSuccessLogin {
//    [GPTools ShowAlert:@""];
    [self didLoginSuccess];
}

@end
