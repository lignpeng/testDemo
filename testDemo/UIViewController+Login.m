//
//  UIViewController+Login.m
//  CSMBP
//
//  Created by Ease on 12-3-29.
//  Copyright (c) 2012年 Forever OpenSource Software Inc. All rights reserved.
//
#import <objc/runtime.h>
#import "UIViewController+Login.h"
#import "GPLoginViewController.h"
#import "GPPopNavigationController.h"
#import "GPPopViewController.h"
#import "GPTools.h"
#import "GPOtherViewController.h"

@interface UIViewController ()

@property (nonatomic,copy) void (^callBackBlock)();

@end

@implementation UIViewController (Login)

- (void)presentLoginViewController {
    
    GPLoginViewController *loginVC = [[GPLoginViewController alloc] init];
    
    GPPopNavigationController *nav =[[GPPopNavigationController alloc]initWithRootViewController:loginVC];
    
    __weak typeof(self) weakSelf = self;
    [self presentViewController:nav animated:YES completion:^{
        UINavigationController *navi = (UINavigationController *)weakSelf.presentedViewController;
        NSLog(@"---------推出login后-----------");
        NSLog(@"self: %@",weakSelf);
        NSLog(@"vc: %@",navi);
        NSLog(@"topViewController: %@",navi.topViewController);
        NSLog(@"visibleViewController: %@",navi.visibleViewController);
        [GPTools ShowAlert:@""];
    }];

//    [self.navigationController pushViewController:loginVC animated:YES];
}


-(void)didLoginSuccess {
    NSLog(@"---------显示login后-------------");
//    NSArray *array = self.navigationController.viewControllers;
//    for (UIViewController *viewController in array) {
//        NSLog(@"%@",viewController);
//        if ([viewController isKindOfClass:[GPPopViewController class]]) {
//        }
//    }
//    NSLog(@"--------1-------");
////    NSArray *array1 = self.navigationController.viewControllers;
////    for (UIViewController *viewController in array1) {
////        NSLog(@"%@",viewController);
////    }
//    NSLog(@"--------2-------");
    UINavigationController *nav = (UINavigationController *)self.presentedViewController;
//
    NSLog(@"self: %@",self);
    NSLog(@"nav: %@",nav);
    if ([nav isKindOfClass:[UIAlertController class]]) {
        NSLog(@"nav : UIAlertController");
    }else{
        NSLog(@"topViewController: %@",nav.topViewController);
        NSLog(@"visibleViewController: %@",nav.visibleViewController);
    }
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        NSLog(@"----%@",vc);
    }
    for (UIViewController *vc in nav.viewControllers) {
        NSLog(@"*****%@",vc);
    }
    NSLog(@"************************");
    GPLoginViewController *loginView = (GPLoginViewController *)nav.visibleViewController;
    
    GPOtherViewController *otherVC = [GPOtherViewController new];
    otherVC.callBackBlock = ^(){
        [loginView dismissViewControllerAnimated:YES completion:nil];
    };
    [nav pushViewController:otherVC animated:YES];
}

@end
