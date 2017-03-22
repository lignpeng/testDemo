//
//  AttributeLabelViewController.m
//  testDemo
//
//  Created by lignpeng on 17/2/16.
//  Copyright © 2017年 genpeng. All rights reserved.
//

#import "AttributeLabelViewController.h"

@interface AttributeLabelViewController ()

@property(nonatomic, strong) UILabel *label;

@end

@implementation AttributeLabelViewController

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
    
    bframe.origin.y += CGRectGetHeight(bframe) + 20;
    bframe.size.height = CGRectGetHeight(frame) - CGRectGetMinY(bframe) - 56;
    self.label  = ({
        UILabel *label = [[UILabel alloc] initWithFrame:bframe];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor lightGrayColor];
        label.numberOfLines = 0;
        label;
    });
    
    [self.view addSubview:showBtn];
    [self.view addSubview:self.label];
}

- (void)showAction {
    NSString *string = @"电145商(1fgh2)\n金54额(3hdt4)\n分类(5tert6)";
//    NSString *str = @"电商(12)"; //6,\n = 1
//    NSLog(@"%lu",(unsigned long)str.length);
    NSLog(@"%lu",(unsigned long)string.length);
    //lenght = 2 * 6 + 6
//    self.label.text = string;
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:string];
    NSArray *spliteArray = [string componentsSeparatedByString:@"\n"];
    for (NSString *spliteStr in spliteArray) {
        NSArray *secondSpliteArray = [spliteStr componentsSeparatedByString:@"("];
        NSString *str = secondSpliteArray.firstObject;
        NSRange range = [string rangeOfString:str];
        [AttributedStr addAttribute:NSForegroundColorAttributeName
                              value:[UIColor redColor]
                              range:NSMakeRange(range.location + range.length, spliteStr.length - range.length)];
    }
    
    self.label.attributedText = AttributedStr;
    
}


@end
