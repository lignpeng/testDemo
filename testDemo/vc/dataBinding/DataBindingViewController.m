//
//  DataBindingViewController.m
//  testDemo
//
//  Created by lignpeng on 17/1/24.
//  Copyright © 2017年 genpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+RZDataBinding.h"
#import "RZDBMacros.h"
#import "Person.h"

#import "DataBindingViewController.h"

@interface DataBindingViewController ()

@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) Person *pp;
@end

@implementation DataBindingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self bindingData];
}

-(void)bindingData {
    
    [self rz_addTarget:self action:@selector(changeName) forKeyPathChange:RZDB_KP_OBJ(self, name)];//不能重复调用这个方法，否则的就是多次监听了
    
    self.pp = [[Person alloc] init];
    [self.pp rz_addTarget:self action:@selector(changeName) forKeyPathChange:RZDB_KP_OBJ(self.pp, name)];
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
    
    self.name = @"012";
    self.pp.name = @"123456";
}

- (void)changeName {
    NSLog(@"\n--------------\nself.name: %@\n",self.name);
    NSLog(@"\nself.pp.name: %@\n---------------",self.pp.name);
}

@end














