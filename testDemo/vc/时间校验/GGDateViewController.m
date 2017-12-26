//
//  GGDateViewController.m
//  testDemo
//
//  Created by lignpeng on 2017/8/14.
//  Copyright © 2017年 genpeng. All rights reserved.
//

#import "GGDateViewController.h"

@interface GGDateViewController ()

@end

@implementation GGDateViewController

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
    button.backgroundColor = [UIColor blueColor];
    button.layer.cornerRadius = 5;
    button.clipsToBounds = YES;
    [self.view addSubview:button];
}

- (void)action {
    NSString *str = @"1983-04-17";
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    df.dateFormat = @"yyyy-MM-dd";
    NSDate *date = [df dateFromString:str];
    
    NSTimeInterval  dd = [date timeIntervalSinceNow];//时间戳一直是负数
    NSTimeInterval ss = [date timeIntervalSince1970];//时间大于1970是正数，否则负数
    
    
    NSDate *dds = [NSDate dateWithTimeIntervalSinceNow:dd];
    NSDate *sss = [NSDate dateWithTimeIntervalSince1970:ss];
    
    //护照有效期
    NSComparisonResult result =[date compare:[NSDate date]];
    [self calculateAge:str];
    [self calculateMargin:@""];
    [self dateyesToday];
}

//计算年龄
- (double )calculateAge:(NSString *)str {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSDate *birthDay = [dateFormatter dateFromString:str];
    //现在的时间
//    NSDate * nowDate = [NSDate date];
    //计算两个中间差值(秒)
    NSTimeInterval time = [birthDay timeIntervalSinceNow];
    NSDate *ds = [NSDate dateWithTimeIntervalSinceNow:time];
    
    //现在的时间
//    NSDate * nowDate = [NSDate date];
//    //计算两个中间差值(秒)
//    time = [nowDate timeIntervalSinceDate:birthDay];
    
    //开始时间和结束时间的中间相差的时间
    double year = floor(ABS(time)/(3600.0 * 24 * 365)); //3600秒 * 24小时*365天
    return year;
}


- (void )calculateMargin:(NSString *)str {
    str = @"2018-08-14";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSDate *birthDay = [dateFormatter dateFromString:str];

    //现在的时间
    NSDate * nowDate = [NSDate date];
    //计算两个中间差值(秒)
    NSTimeInterval time = [nowDate timeIntervalSinceDate:birthDay];
}

- (void)dateyesToday {
    NSDate *today = [NSDate date];
//    NSLog(@”today is %@”,today);
    //再获取的时间date减去24小时的时间（昨天的这个时候）
    NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow:-(24*60*60)];
//    NSLog(@”yesterday is %@”,yesterday);//打印昨天的时间
    NSDateFormatter *dateFormater = [NSDateFormatter new];
    dateFormater.dateFormat =@"yyyy-MM-dd";
    NSString *todayString = [dateFormater stringFromDate:today];
    NSString *yestoday = [dateFormater stringFromDate:yesterday];
    NSString *dd = @"2017-12-07";
    if ([dd isEqualToString:todayString]) {
        NSLog(@"today is %@",todayString);
    }else {
        NSLog(@"today is not %@",todayString);
    }
    
    if ([dd isEqualToString:yestoday]) {
        NSLog(@"yestoday is %@",dd);
    }else {
        NSLog(@"yestoday is not %@",dd);
    }
}



@end
