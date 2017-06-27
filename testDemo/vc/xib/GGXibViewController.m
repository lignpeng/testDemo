//
//  GGXibViewController.m
//  testDemo
//
//  Created by gaby on 2017/6/22.
//  Copyright © 2017年 genpeng. All rights reserved.
//

#import "GGXibViewController.h"
#import "HexColor.h"

@interface GGXibViewController ()

@end

@implementation GGXibViewController

+ (instancetype)ceateCSLoginFastBindViewController {
    GGXibViewController *vc = [[GGXibViewController alloc] initWithNibName:NSStringFromClass([GGXibViewController class]) bundle:nil];
    if (!vc) {
        NSLog(@"CSLoginFastBindViewControllerc创建对象失败");
    }
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackgroundColor];
}

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.view.backgroundColor = [UIColor whiteColor];
//    [self setBackgroundColor];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self.navigationController.navigationBar subviews] objectAtIndex:0].alpha = 0;
}

//仅设置当前页面

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[self.navigationController.navigationBar subviews] objectAtIndex:0].alpha = 1;
}


/**
 设置渐变背景色
 */
- (void)setBackgroundColor{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = [UIScreen mainScreen].bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blueColor] CGColor],(id)[[UIColor greenColor] CGColor], nil];
    [self.view.layer insertSublayer:gradient atIndex:0];
}

@end
