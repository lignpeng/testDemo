//
//  CSNewDatePickerView.h
//
//  Created by lignpeng on 2017/7/28.
//

#import <UIKit/UIKit.h>

typedef void(^DatePickerBlock)(NSDate *aDate, NSString *aFlag);

@interface CSNewDatePickerView : UIView

@property(nonatomic, copy) DatePickerBlock complishBlock;

+ (instancetype)datePickerView;

//+ (instancetype)datePickerView:(void(^)(NSDate *aDate, NSString *aFlag))complishBlock;

+ (instancetype)datePickerViewWithPresentDate:(NSDate *)presentDate andMinDate:(NSDate *)minDate andMaxDate:(NSDate *)maxDate andTitle:(NSString *)title andFlag:(NSString *)aFlag complishBlock:(void(^)(NSDate *aDate, NSString *aFlag))complishBlock;

/**
 新版预定流用,改了月份的展示样式
 */
+ (instancetype)datePickerViewWithPresentDate:(NSDate *)presentDate andMinDate:(NSDate *)minDate andMaxDate:(NSDate *)maxDate andFlag:(NSString *)aFlag isNewFlightBooking:(BOOL)isNewFlightBooking complishBlock:(void(^)(NSDate *aDate, NSString *aFlag))complishBlock;

@end

