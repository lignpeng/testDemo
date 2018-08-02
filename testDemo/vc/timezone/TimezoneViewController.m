//
//  TimezoneViewController.m
//  testDemo
//
//  Created by lignpeng on 2018/5/8.
//  Copyright © 2018年 genpeng. All rights reserved.
//

#import "TimezoneViewController.h"
#import "DataTools.h"
#import "HexColor.h"

@interface TimezoneViewController ()

@property(nonatomic, strong) UILabel *label;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) UITextView *textView;

@end

@implementation TimezoneViewController

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
    
//     [self timezone];
    [self timeTemp];
}

- (void)timezone {
    NSTimeZone *zone = [NSTimeZone localTimeZone];
    NSString *strZoneName = [zone name];
    NSString *strZoneAbbreviation = [zone abbreviation];
    if (![strZoneAbbreviation containsString:@":"]) {
        strZoneAbbreviation = [strZoneAbbreviation stringByAppendingString:@":00"];
    }
    NSString *str =[strZoneName stringByAppendingString:[NSString stringWithFormat:@"(%@)",strZoneAbbreviation]];
    NSLog(@"名称 是 %@",str);
    self.textView.text = str;
}

- (void)timeTemp {
    NSArray *array =@[@"685728000000",@"671846400000",@"685728000",@"-62049485143000"];
    for (NSString *str in array) {
        NSString *ss =[self timeWithTimeIntervalString:str];
        NSLog(@"%@=%@",str,ss);
    }
    NSLog(@"-----------");
    for (NSString *str in array) {
        NSString *ss =[self actualAgeWithTime:str];
        NSLog(@"%@=%@",str,ss);
    }
//    self.label.text = [self timeWithTimeIntervalString:@""];
    NSDate *dd = [self.dateFormatter dateFromString:@"0003-9-25"];
    NSTimeInterval interval = [dd timeIntervalSince1970]*1000; // *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", interval]; //转为字符型
    NSLog(@"timeStr = %@",timeString);
}

- (NSString *)actualAgeWithTime:(NSString *)timeStr {
    
    NSDate *nowDate = [NSDate date];
    NSTimeInterval time = [nowDate timeIntervalSinceDate:[self getDateWithString:timeStr]];
        //开始时间和结束时间的中间相差的时间
    double year = time / (3600.0 * 24 * 365); //3600秒 * 24小时*365天
    NSInteger dd = (NSInteger)floorf(year);
    NSString *ageString = [NSString stringWithFormat:@"%ld", (long)dd];
    
    return ageString;
}

- (NSDate *)getDateWithString:(NSString *)timeStr {
    
    NSDate *date = nil;
    if (timeStr != nil) {
        date = [NSDate dateWithTimeIntervalSince1970:[timeStr floatValue] / 1000];
    }
    
    return date;
}

    //时间戳转换为时间字符串
- (NSString *)timeWithTimeIntervalString:(NSString *)timeString {
    //因为时差问题要加8小时 == 28800 sec
//    NSTimeInterval time = [timeString doubleValue] + 28800;
    NSTimeInterval time = [timeString doubleValue];
    NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:time / 1000.0];
    NSLog(@"date:%@", [detaildate description]);
        //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:detaildate];
    
    return currentDateStr;
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter =[[NSDateFormatter alloc]init];
        _dateFormatter.dateFormat =@"yyyy-MM-dd";
    }
    return _dateFormatter;
}

@end
