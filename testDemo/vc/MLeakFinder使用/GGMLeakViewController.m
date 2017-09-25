//
//  GGMLeakViewController.m
//  testDemo
//
//  Created by lignpeng on 2017/9/19.
//  Copyright © 2017年 genpeng. All rights reserved.
//

#import "GGMLeakViewController.h"
#import "GGMLViewController.h"
#import "GGMasoryViewController.h"


@class ClassA;
@class ClassB;

@interface ClassA : NSObject

@property(nonatomic, strong) ClassB *b;

@end

@implementation ClassA

@end

@interface ClassB : NSObject

@property(nonatomic, strong) ClassA *a;

@end

@implementation ClassB

@end

@interface GGMLeakViewController ()

@property(nonatomic, strong) NSString *name;

@end

@implementation GGMLeakViewController

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
//    [self masonry];
    [self block];
}

- (void)block {
    ClassA *a = [ClassA new];
    ClassB *b = [ClassB new];
    a.b = b;
    b.a = a;
    GGMLViewController *vc = [GGMLViewController new];
    //    vc.actionBlock = xxoo;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)masonry {
    GGMasoryViewController *vc = [GGMasoryViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
