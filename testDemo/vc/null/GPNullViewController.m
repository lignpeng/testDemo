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

@interface GPNullViewController ()

@end

@implementation GPNullViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect frame = self.view.bounds;
    CGFloat wdith = 120;
    CGFloat height = 42;
    CGRect bframe = CGRectMake((CGRectGetWidth(frame) - wdith)/2, wdith, wdith, height);
    UIButton *btn = [[UIButton alloc] initWithFrame:bframe];
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor blueColor];
    [btn setTitle:@"Ok" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 5.0;
    btn.clipsToBounds = YES;
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
