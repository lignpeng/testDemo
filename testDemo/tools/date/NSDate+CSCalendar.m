//
//  NSDate+CSCalendar.m
//  CSUtilCategory
//
//  Created by zhangfangzhu on 2017/12/12.
//

#import "NSDate+CSCalendar.h"

const NSCalendarUnit kCSCalendarUnitYMD = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;


@implementation NSDate (CSCalendar)

+ (NSCalendar *)cs_currentCalendar {
    static dispatch_once_t onceToken;
    static NSCalendar *cld = nil;
    dispatch_once(&onceToken, ^{
        cld = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    });
    return cld;
}

- (NSCalendar *)calendar{
    return [[self class] cs_currentCalendar];
}

#pragma mark 年月日时分获取

- (NSUInteger)year {
    return [self.calendar components:NSCalendarUnitYear fromDate:self].year;
}

- (NSUInteger)month {
    return [self.calendar components:NSCalendarUnitMonth fromDate:self].month;
}

- (NSUInteger)day {
    return [self.calendar components:NSCalendarUnitDay fromDate:self].day;
}

- (NSUInteger)hour {
    return [self.calendar components:NSCalendarUnitHour fromDate:self].hour;
}

- (NSUInteger)minute {
    return [self.calendar components:NSCalendarUnitMinute fromDate:self].minute;
}

- (NSInteger)weekdayValue {
    
    NSDateComponents *comps= [[[self class] cs_currentCalendar] components:(NSCalendarUnitYear |
                                                                            NSCalendarUnitMonth |
                                                                            NSCalendarUnitDay |
                                                                            NSCalendarUnitWeekday) fromDate:self];
    return [comps weekday];
}

- (NSDateComponents *)YMDWComponents{
    
    return [self.calendar components:
            NSCalendarUnitYear|
            NSCalendarUnitMonth|
            NSCalendarUnitDay|
            NSCalendarUnitWeekday fromDate:self];
}

- (NSDate *)clampToComponents:(NSUInteger)unitFlags {
    NSDateComponents *components = [self.calendar components:unitFlags fromDate:self];
    return [self.calendar dateFromComponents:components];
}

+ (NSDate *)dateFromComponents:(NSDateComponents *)components {
    return [[NSDate cs_currentCalendar] dateFromComponents:components];
}

+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    NSDateComponents *comp = [[NSDateComponents alloc] init];
    comp.year = year;
    comp.month = month;
    comp.day = day;
    return [[NSDate cs_currentCalendar] dateFromComponents:comp];
}

#pragma mark 日期计算类方法

- (NSDate *)dateByAddingDays:(NSInteger)days {

    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day = days;
    return [self.calendar dateByAddingComponents:dateComponents toDate:self options:0];
}

- (NSDate *)dateByAddingMonths:(NSInteger)months {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = months;
    return [self.calendar dateByAddingComponents:dateComponents toDate:self options:0];
}

- (NSDate *)dateByAddingYears:(NSInteger)years {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = years;
    return [self.calendar dateByAddingComponents:dateComponents toDate:self options:0];
}

#pragma mark 当天起始日期、结束日期的计算

+ (NSDate *)beginOfDate:(NSDate *)date {
    NSCalendar *calendar = [NSDate cs_currentCalendar];
    NSDate *beginDate;
    NSTimeInterval interval;
    BOOL ok = [calendar rangeOfUnit:NSCalendarUnitDay startDate:&beginDate interval:&interval forDate:date];
    if (ok) {
        return beginDate;
    }else{
        return nil;
    }
}

+ (NSDate *)endOfDate:(NSDate *)date {
    NSCalendar *calendar = [NSDate cs_currentCalendar];
    NSDate *beginDate;
    NSTimeInterval interval;
    BOOL ok = [calendar rangeOfUnit:NSCalendarUnitDay startDate:&beginDate interval:&interval forDate:date];
    if (ok) {
        return [beginDate dateByAddingTimeInterval:interval-1];
    }else{
        return nil;
    }
}


#pragma mark 某个月份的天数、第一天、最后一天的计算

+ (NSUInteger)numberOfDaysInMonth:(NSDate *)date {
    return [[[self class] cs_currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
}

+ (NSDate *)firstDateInMonth:(NSDate *)date {
    
    NSCalendar *currentCalendar = [NSDate cs_currentCalendar];
    NSDateComponents *components = [currentCalendar components:kCSCalendarUnitYMD fromDate:date];
    components.day = 1;
    return [currentCalendar dateFromComponents:components];
}

+ (NSDate *)lastDateInMonth:(NSDate *)date {
    
    NSCalendar *currentCalendar = [NSDate cs_currentCalendar];
    NSDateComponents *components = [currentCalendar components:kCSCalendarUnitYMD fromDate:date];
    components.day = [NSDate numberOfDaysInMonth:date];
    return [currentCalendar dateFromComponents:components];
}

+ (NSInteger)monthsBetweenDate:(NSDate *)dateOne andDate:(NSDate *)dateTwo {
    if (dateOne && dateTwo) {
        NSDateComponents *comp = [[NSDate cs_currentCalendar] components:NSCalendarUnitMonth fromDate:dateOne toDate:dateTwo options:0];
        return comp.month + 1;
    }
    return 0;
}

#pragma mark 日期的判断

- (BOOL)yesterday {
    return [self isSameDayWithDate:[[NSDate date] dateByAddingTimeInterval:-24*60*60]];
}

- (BOOL)today {
    return [self isSameDayWithDate:[NSDate date]];
}

- (BOOL)tomorrow {
    return [self isSameDayWithDate:[[NSDate date] dateByAddingTimeInterval:24*60*60]];
}

- (BOOL)theDayAfterTomorrow {
    return [self isSameDayWithDate:[[NSDate date] dateByAddingTimeInterval:2*24*60*60]];
}

//是否会员日
+ (BOOL)isDuringMemberDay {
    //获取当前GMT时间
    NSDate *nowDate = [NSDate date];
    
    NSCalendar *calendar = [NSDate cs_currentCalendar];
    NSDateComponents *dateComponents = [calendar
                                        components:NSCalendarUnitYear | NSCalendarUnitMonth
                                        fromDate:nowDate];
    
    //使用中国时区来设置活动的起始时间段
    [dateComponents setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    
    dateComponents.day = 28;
    dateComponents.hour = 0;
    dateComponents.minute = 0;
    dateComponents.second = 0;
    NSDate *beginDate = [calendar dateFromComponents:dateComponents];
    
    dateComponents.day = 28;
    dateComponents.hour = 23;
    dateComponents.minute = 59;
    dateComponents.second = 59;
    NSDate *endDate = [calendar dateFromComponents:dateComponents];
    
    if (([nowDate compare:beginDate] != NSOrderedAscending) && ([nowDate compare:endDate] != NSOrderedDescending)) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark 日期比较，比较单位：天
- (BOOL)isSameDayWithDate:(NSDate *)date {
    NSDateComponents *curComp = [self YMDWComponents];
    NSDateComponents *otherComp = [date YMDWComponents];
    BOOL result = (curComp.year == otherComp.year && curComp.month == otherComp.month && curComp.day == otherComp.day);
    return result;
}

- (BOOL)isDaysEarlierThanDate:(NSDate *)date {
    return [self compareByDayWithDate:date] == NSOrderedAscending;
}

- (BOOL)isDaysLaterThanDate:(NSDate *)date {
    return [self compareByDayWithDate:date] == NSOrderedDescending;
}

- (NSComparisonResult)compareByDayWithDate:(NSDate *)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSDate *dateA = [dateFormatter dateFromString:[dateFormatter stringFromDate:self]];
    NSDate *dateB = [dateFormatter dateFromString:[dateFormatter stringFromDate:date]];
    return [dateA compare:dateB];
}

#pragma mark NSDate和NSString的转换方法

- (NSString *)stringWithFormat:(NSString *)format {
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setCalendar:self.calendar];
    [df setDateFormat:format];
    return [df stringFromDate:self];
}

+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format {
    if (!format)
        format = @"yyyy-MM-dd";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setCalendar:[NSDate cs_currentCalendar]];
    [dateFormatter setDateFormat:format];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

+ (NSDate *)dateFromString:(NSString *)dateString format:(NSString *)format {
    
    if (!format)
        format = @"yyyy-MM-dd";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setCalendar:[NSDate cs_currentCalendar]];
    [dateFormatter setDateFormat:format];
    return [dateFormatter dateFromString:dateString];
}

@end
