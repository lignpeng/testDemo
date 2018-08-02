//
//  GGStringViewController.m
//  testDemo
//
//  Created by lignpeng on 2018/1/10.
//  Copyright © 2018年 genpeng. All rights reserved.
//

#import "GGStringViewController.h"
#import "DataTools.h"
#import "HexColor.h"

@interface GGStringViewController ()
@property(nonatomic, strong) UITextView *textView;
@end

@implementation GGStringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat margin = 32;
    CGRect sframe = [UIScreen mainScreen].bounds;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(margin, margin * 3, CGRectGetWidth(sframe) - margin * 2, 42)];
    [button addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"action" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorWith8BitRedN:arc4random()%256 green:arc4random()%256 blue:arc4random()%256];
    button.layer.cornerRadius = 5;
    button.clipsToBounds = YES;
    [self.view addSubview:button];
    CGRect bframe = button.frame;
    CGFloat y = CGRectGetHeight(bframe) + CGRectGetMinY(bframe) + margin * 0.25;
    self.textView.frame = (CGRect){margin * 0.5,y,CGRectGetWidth(sframe) - margin,CGRectGetHeight(sframe) - y - margin};
    [self.view addSubview:self.textView];
}

- (void)action {
    NSArray *array = @[@"123sdf",@"45sfe6释放",@"af/ef"];
    NSLog(@"containt 123 = %d",[array containsObject:@"123"]);
    NSLog(@"containt 23 = %d",[array containsObject:@"23"]);
    NSLog(@"containt 13 = %d",[array containsObject:@"13"]);
    for (NSString *title in array) {
        NSLog(@"%@:%@",title,[title uppercaseString]);
    }
    [self showString:array];
}

- (void)showString:(NSArray *)array {
    NSString *str = @"";
    for (NSString *string in array) {
        str = [str stringByAppendingFormat:@"\n%@",string];
    }
    self.textView.text = str;
}



- (UITextView *)textView {
    if (!_textView) {
        _textView = [UITextView new];
        _textView.font = [UIFont systemFontOfSize:14];
        _textView.showsHorizontalScrollIndicator = NO;
        _textView.editable = NO;
        _textView.textAlignment = NSTextAlignmentLeft;
    }
    return _textView;
}


@end
