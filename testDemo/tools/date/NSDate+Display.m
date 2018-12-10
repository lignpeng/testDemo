//
//  NSDate+Display.m
//  Scent
//
//  Created by Justin Yip on 5/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSDate+Display.h"
#import "CSSafeAccess.h"
#import "NSDate+CSCalendar.h"

@implementation NSDate (NSDate_Display)


/**
 判断是否为后天

 */
- (BOOL)theDayAfterTomorrow{
    NSDate *tomorrowDate = [[NSDate date] dateByAddingTimeInterval:2*24*60*60];
    
    return [self sameToDate:tomorrowDate];
}
- (BOOL)sameToDate:(NSDate *)aDate{//日期yyyy-MM-dd相同与否---by Ease
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents* comps = [calendar components:unitFlags fromDate:aDate];
    [comps setHour:0];
    [comps setMinute:0];
    [comps setSecond:-1];
    NSDate *start = [calendar dateFromComponents:comps];
    
    [comps setHour:23];
    [comps setMinute:59];
    [comps setSecond:60];
    NSDate *end = [calendar dateFromComponents:comps];
    
    if ([self compare:start] == NSOrderedDescending&&[self compare:end] == NSOrderedAscending) {
        return YES;
    } else {
        return NO;
    }
}

- (NSString*)weekdayString {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null],NSLocalizedString(@"Sunday", @"星期日"),NSLocalizedString(@"Monday", @"星期一"),NSLocalizedString(@"Tuesday", @"星期二"),NSLocalizedString(@"Wednesday",@"星期三") ,NSLocalizedString(@"Thursday",@"星期四"),NSLocalizedString(@"Friday",@"星期五") ,NSLocalizedString(@"Saturday",@"星期六") , nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    

    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:self];
    
    return [weekdays cs_objectWithIndex:theComponents.weekday];
    
}

- (NSString*)weekdayStringDetail {
    if ([self tomorrow]) {
        return NSLocalizedString(@"Tomorrow", @"明天");
    } else if ([self today]) {
        return NSLocalizedString(@"Today", @"今天");
    } else if ([self yesterday]) {
        return NSLocalizedString(@"Yestoday", @"昨天");
    } else {
        NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], NSLocalizedString(@"Sunday", @"星期日"), NSLocalizedString(@"Monday", @"星期一"), NSLocalizedString(@"Tuesday", @"星期二"), NSLocalizedString(@"Wednesday", @"星期三"), NSLocalizedString(@"Thursday", @"星期四"), NSLocalizedString(@"Friday", @"星期五"), NSLocalizedString(@"Saturday", @"星期六"), nil];
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        
        NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
        
        NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:self];
        
        return [weekdays cs_objectWithIndex:theComponents.weekday];
    }
}
- (NSString*)weekdayStringDetailFromToday {
    if ([self tomorrow]) {
        return NSLocalizedString(@"Tomorrow", @"明天");
    } else if ([self today]) {
        return NSLocalizedString(@"Today", @"今天");
    } else if ([self theDayAfterTomorrow]) {
        return @"后天";
    } else {
        NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], NSLocalizedString(@"Sunday", @"星期日"), NSLocalizedString(@"Monday", @"星期一"), NSLocalizedString(@"Tuesday", @"星期二"), NSLocalizedString(@"Wednesday", @"星期三"), NSLocalizedString(@"Thursday", @"星期四"), NSLocalizedString(@"Friday", @"星期五"), NSLocalizedString(@"Saturday", @"星期六"), nil];
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        
        NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
        
        NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:self];
        
        return [weekdays cs_objectWithIndex:theComponents.weekday];
    }
}

- (NSString *)yearMonthString{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM"];
    [df setCalendar:[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian]];
    return [df stringFromDate:self];
}

- (NSString *)stringMMddisEnglish:(BOOL)isEnglish {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    [dateFormatter setDateFormat:@"MM月dd日"];
    
    NSString *destDateString = [dateFormatter stringFromDate:self];
    
    if (isEnglish) {
        NSString *monthTemp = [NSString stringWithFormat:@"%@Month",[destDateString cs_substringWithRange:NSMakeRange(0, 2)]];
        NSString *month = NSLocalizedString(monthTemp, @"月");
        NSString *day = [destDateString cs_substringWithRange:NSMakeRange(3, 2)];

        return [NSString stringWithFormat:@"%@ %@",day,month];
    }else{
        return destDateString;
    }

}

@end
