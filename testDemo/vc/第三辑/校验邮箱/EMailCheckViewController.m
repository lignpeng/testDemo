//
//  EMailCheckViewController.m
//  testDemo
//
//  Created by lignpeng on 2018/10/15.
//  Copyright © 2018年 genpeng. All rights reserved.
//

#import "EMailCheckViewController.h"
#import "DataTools.h"
#import "HexColor.h"

@interface EMailCheckViewController ()

@property(nonatomic, strong) UITextView *textView;

@end

@implementation EMailCheckViewController

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
    button.backgroundColor = [UIColor colorWith8BitRed:arc4random()%256 green:arc4random()%256 blue:arc4random()%256];
    button.layer.cornerRadius = 5;
    button.clipsToBounds = YES;
    [self.view addSubview:button];
    CGRect bframe = button.frame;
    CGFloat y = CGRectGetHeight(bframe) + CGRectGetMinY(bframe) + margin * 0.25;
    self.textView.frame = (CGRect){margin * 0.5,y,CGRectGetWidth(sframe) - margin,CGRectGetHeight(sframe) - y - margin};
    [self.view addSubview:self.textView];
}

- (void)action {
        //    do something.
    //1.含有“.”和“@”，且不在第一位 2."."后至少有2位字符，“@”后最少有4位字符
    NSString *str = @"xy.ch@live.com";
    NSString *regCCC = @"^\\w+([.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([.]\\w+)*$";
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:str];
    [array addObject:regCCC];
    [array addObject:[NSString stringWithFormat:@"结果：%d",[self validateEmail:str regex:regCCC]]];
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    [array addObject:emailRegex];
    [array addObject:[NSString stringWithFormat:@"结果：%d",[self validateEmail:str regex:emailRegex]]];
    [self showString:array];
}

-(BOOL)validateEmail:(NSString *)str regex:(NSString *)emailRegex{
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:str];
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
