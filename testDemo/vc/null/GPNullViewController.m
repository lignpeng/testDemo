//
//  GPNullViewController.m
//  testDemo
//
//  Created by lignpeng on 16/12/2.
//  Copyright © 2016年 genpeng. All rights reserved.
//

/*
 验证null = nil；会不会崩溃。
 2016年12月02日
 
 */

#import "GPNullViewController.h"
#import "DataTools.h"
#import "HexColor.h"

@interface GPNullViewController ()
@property(nonatomic, strong) UITextView *textView;
@end

@implementation GPNullViewController


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

- (void)action {
    NSString *jsonStr = @"{\"type\":\"REG_VCODE_NEW\",\"mobile\":\"13611111112\",\"code\":}";
    NSData * getJsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:getJsonData options:NSJSONReadingMutableContainers error:&error];
    NSInteger code = ((NSNumber *)dic[@"code"]).integerValue;
    NSLog(@"dic: %@",dic);
    NSLog(@"code: %ld",(long)code);
//    NSDictionary *dic = @{};
//    id nn = nil;
//    id name;
//    if (nn) {
//        id xx;
//    }
//    name = nil;
//    [self codeString:dic[@"12"]];
}
-(void)codeString:(NSString *)str {
    str = @"";
    str = nil;
}

@end
//OC中NSLog函数输出格式详解  %@ 对象  • %d, %i 整数  • %u 无符整形  • %f 浮点/双字  • %x, %X 二进制整数  • %o 八进制整数  • %zu size_t  • %p 指针  • %e 浮点/双字 （科学计算）  • %g 浮点/双字  • %s C 字符串  • %.*s Pascal字符串  • %c 字符  • %C unichar  • %lld 64位长整数（long long）  • %llu 无符64位长整数  • %Lf 64位双字
