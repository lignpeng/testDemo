//
//  NSDate+Display.h
//  Scent
//
//  Created by Justin Yip on 5/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (NSDate_Display)

//根据日期返回星期几
- (NSString *)weekdayString;
//根据日期返回星期几，除今天，明天，昨天
- (NSString *)weekdayStringDetail;
//根据日期返回星期几，除今天，明天，后天
- (NSString *)weekdayStringDetailFromToday;

- (NSString *)yearMonthString;

// MM月dd日
- (NSString *)stringMMdd;

@end
