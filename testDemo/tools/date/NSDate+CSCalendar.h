//
//  NSDate+CSCalendar.h
//  CSUtilCategory
//
//  Created by zhangfangzhu on 2017/12/12.
//

#import <Foundation/Foundation.h>

@interface NSDate (CSCalendar)

+ (NSCalendar *)cs_currentCalendar;

/** 获取年月日时分等信息 **/

- (NSUInteger)year;
- (NSUInteger)month;
- (NSUInteger)day;
- (NSUInteger)hour;
- (NSUInteger)minute;
//周日是“1”，周一是“2”...
- (NSUInteger)weekdayValue;


/** 获取NSDateComponents或NSDate对象 **/

- (NSDateComponents *)YMDWComponents;
- (NSDate *)clampToComponents:(NSUInteger)unitFlags;
+ (NSDate *)dateFromComponents:(NSDateComponents *)components;
+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;

/**
 日期计算类方法
 */
- (NSDate *)dateByAddingDays:(NSInteger)days;
- (NSDate *)dateByAddingMonths:(NSInteger)months;
- (NSDate *)dateByAddingYears:(NSInteger)years;


/** 当前日期的起始、结束日期计算 **/

//当天的起始时间，即0时0分0秒
+ (NSDate *)beginOfDate:(NSDate *)date;
//当天的结束时间，即23时59分59秒
+ (NSDate *)endOfDate:(NSDate *)date;


/** 某一日期月份的内容计算方法 **/

//当月的天数
+ (NSUInteger)numberOfDaysInMonth:(NSDate *)date;
//当月的起始日期
+ (NSDate *)firstDateInMonth:(NSDate *)date;
//当月的最后日期
+ (NSDate *)lastDateInMonth:(NSDate *)date;
//两个日期间隔的月份，同一个月为1
+ (NSInteger)monthsBetweenDate:(NSDate *)dateOne andDate:(NSDate *)dateTwo;


/** 日期的判断类方法 */

//是否昨天
- (BOOL)yesterday;
//是否今天
- (BOOL)today;
//是否明天
- (BOOL)tomorrow;
//是否后天
- (BOOL)theDayAfterTomorrow;

/** 以天为单位来判断日期 **/

//是否同一天
- (BOOL)isSameDayWithDate:(NSDate *)date;
//是否比参考日期早
- (BOOL)isDaysEarlierThanDate:(NSDate *)date;
//是否比参考日期晚
- (BOOL)isDaysLaterThanDate:(NSDate *)date;
//是否会员日活动期间
+ (BOOL)isDuringMemberDay;

/** NSDate和NSString之间的格式化转换 **/

- (NSString *)stringWithFormat:(NSString *)format;
+ (NSDate *)dateFromString:(NSString *)dateString format:(NSString *)format;
+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format;
@end
