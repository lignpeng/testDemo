//
//  TimeCheckViewController.m
//  testDemo
//
//  Created by lignpeng on 2018/10/24.
//  Copyright © 2018年 genpeng. All rights reserved.
//

#import "TimeCheckViewController.h"
#import "DataTools.h"
#import "HexColor.h"

@interface TimeCheckViewController ()

@property(nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation TimeCheckViewController

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
        //    do something.
    NSString *flightDateString = @"2018-10-29";
    NSString *birthdayDate = @"1984-05-29";
    NSString *age1 = [self actualAgeWithFlightDate:flightDateString bithday:birthdayDate];
    NSString *age2 = [self ageWith:birthdayDate];
    NSLog(@"age1 = %@,age2 = %@",age1,age2);
}

- (NSString *)actualAgeWithFlightDate:(NSString *)flightDateString bithday:(NSString *)birthdayDate {
    
    NSDate *flightDate = [self.dateFormatter dateFromString:flightDateString];
    NSTimeInterval time = [flightDate timeIntervalSinceDate:[self getDateWithString:birthdayDate]];
        //开始时间和结束时间的中间相差的时间
    double year = time / (3600.0 * 24 * 365); //3600秒 * 24小时*365天
    NSInteger dd = (NSInteger)floorf(year);
    NSString *ageString = [NSString stringWithFormat:@"%ld", (long)dd];
    return ageString;
}

- (NSString *)ageWith:(NSString *)birthdayDate {
        //现在的时间
    NSDate * nowDate = [NSDate date];
        //计算两个中间差值(秒)
    NSTimeInterval time = [nowDate timeIntervalSinceDate:[self getDateWithString:birthdayDate]];
    
        //开始时间和结束时间的中间相差的时间
    double year = time/(3600.0 * 24 * 365); //3600秒 * 24小时*365天
    NSInteger dd = (NSInteger)ceil(year);
    NSString *ageString = [NSString stringWithFormat:@"%ld",(long)dd];
    return ageString;
}

- (NSDate *)getDateWithString:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setCalendar:[self cs_currentCalendar]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    return date;
}

- (NSCalendar *)cs_currentCalendar {
    static dispatch_once_t onceToken;
    static NSCalendar *cld = nil;
    dispatch_once(&onceToken, ^{
        cld = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    });
    return cld;
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter =[[NSDateFormatter alloc]init];
        _dateFormatter.dateFormat =@"yyyy-MM-dd";
    }
    return _dateFormatter;
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
