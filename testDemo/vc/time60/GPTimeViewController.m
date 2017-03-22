//
//  GPTimeViewController.m
//  testDemo
//
//  Created by lignpeng on 16/12/7.
//  Copyright © 2016年 genpeng. All rights reserved.
//

#import "GPTimeViewController.h"

@interface GPTimeViewController ()

@property(nonatomic, assign) NSInteger secondsCount;//倒计时总时长
@property(nonatomic, strong) NSTimer *countTimer;//
@property(nonatomic, strong) UIButton *showBtn;
@end

@implementation GPTimeViewController

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
    self.showBtn = ({
        UIButton *btn = [[UIButton alloc] initWithFrame:bframe];
        btn.backgroundColor = [UIColor blueColor];
//        [btn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(showAction) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.cornerRadius = 5.0;
        btn.clipsToBounds = YES;
        btn;
    });
    [self setButtonTitle:@"获取验证码"];
    [self.view addSubview:self.showBtn];
}

- (void)setButtonTitle:(NSString *)str {
    [self.showBtn setTitle:str forState:UIControlStateNormal];
}

- (void)showAction {
    self.secondsCount = 60;
    self.showBtn.enabled = false;
    self.showBtn.backgroundColor = [UIColor grayColor];
    [self setButtonTitle:[NSString stringWithFormat:@"获取验证码(%ld)",(long)self.secondsCount]];
    [self.countTimer invalidate];
    self.countTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireAction) userInfo:nil repeats:YES];
    
}

- (void)timeFireAction {
    self.secondsCount--;
    [self setButtonTitle:[NSString stringWithFormat:@"获取验证码(%ld)",(long)self.secondsCount]];
    if (self.secondsCount <=0) {
        self.showBtn.enabled = YES;
        self.showBtn.backgroundColor = [UIColor blueColor];
        [self setButtonTitle:@"获取验证码"];
        [self.countTimer invalidate];
        
    }
}

- (void)dealloc {
    [self.countTimer invalidate];
}

@end
