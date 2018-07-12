//
//  SelectManagerViewController.m
//  testDemo
//
//  Created by lignpeng on 2018/7/11.
//  Copyright © 2018年 genpeng. All rights reserved.
//

#import "SelectManagerViewController.h"
#import "SelectPanViewController.h"

@interface SelectManagerViewController ()

@property(nonatomic, strong) UIView *listView;
@property(nonatomic, strong) UITextField *textField;
@property(nonatomic, strong) UIButton *addButton;

@end

@implementation SelectManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAction)];
}

- (void)addAction {
    SelectPanViewController *vc = [SelectPanViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
