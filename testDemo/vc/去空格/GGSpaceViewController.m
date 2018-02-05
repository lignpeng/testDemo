//
//  GGSpaceViewController.m
//  testDemo
//
//  Created by lignpeng on 2017/11/7.
//  Copyright © 2017年 genpeng. All rights reserved.
//

#import "GGSpaceViewController.h"

@interface GGSpaceViewController ()

@end

@implementation GGSpaceViewController

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
    NSString *str = @"   123    456  789    ";
    //去除右侧空格
    NSString *str1 = [self stringByTrimmingRightString:str];
    NSLog(@"===%@===",str1);
    //去除右侧空格
    NSString *str4 = [self stringByTrimmingRightString1:str];
    NSLog(@"===%@===",str4);
    //去除右侧空格
    NSString *str5 = [self stringByTrimmingRightString2:str];
    NSLog(@"===%@===",str5);
    //去除前后空格
    NSString *str2 = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSLog(@"===%@===",str2);
    //去除所有空格
    NSString *str3 = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"===%@===",str3);
}

//去除右侧空格
- (NSString *)stringByTrimmingRightString:(NSString *)str {
    //空格集合类型
    NSCharacterSet *characterSet = [NSCharacterSet whitespaceCharacterSet];
    NSUInteger location = 0;
    NSUInteger length = [str length];
    unichar charBuffer[length];
    //获取字符串的所有字符
    [str getCharacters:charBuffer];
    for (length = [str length]; length > 0; length--) {
        //倒序取值，判断字符是不是属于空格，不是的话就退出，定位到非空格的索引
        if (![characterSet characterIsMember:charBuffer[length - 1]]) {
            break;
        }
    }
    return [str substringWithRange:NSMakeRange(location, length - location)];
}

//去除右侧空格：简化
- (NSString *)stringByTrimmingRightString1:(NSString *)str {
    NSUInteger length = 0;
    for (length = [str length]; length > 0; length--) {
        //倒序取值，判断字符是不是属于空格，不是的话就退出，定位到非空格的索引
        NSString *tep = [str substringWithRange:[str rangeOfComposedCharacterSequencesForRange:(NSRange){length-1,1}]];
        if (![tep isEqualToString:@" "]) {
            break;
        }
    }
    return [str substringWithRange:NSMakeRange(0, length)];
}

//去除左侧空格：简化
- (NSString *)stringByTrimmingRightString2:(NSString *)str {
    NSUInteger length = 0;
    NSUInteger sumLength = [str length];
    for (length = 0; length < sumLength; length++) {
        //倒序取值，判断字符是不是属于空格，不是的话就退出，定位到非空格的索引
        NSString *tep = [str substringWithRange:[str rangeOfComposedCharacterSequencesForRange:(NSRange){length,1}]];
        if (![tep isEqualToString:@" "]) {
            break;
        }
    }
    return [str substringWithRange:NSMakeRange(length,sumLength - length)];
}

@end














