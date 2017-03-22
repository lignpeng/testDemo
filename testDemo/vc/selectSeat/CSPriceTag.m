//
//  CSPriceTag.m
//  CSMBP
//
//  Created by lyh on 16/6/30.
//  Copyright © 2016年 China Southern Airlines. All rights reserved.
//

#import "CSPriceTag.h"
#import "CSUtils.h"

@implementation CSPriceTag

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"tag":          @"tag",
                                                       @"price":        @"price",
                                                       @"currencyCode": @"currencyCode"
                                                       }];
}


/**
 *  获取带币种符号的价格字符串
 *
 *  @return
 */
-(NSString *)getPrice {
    return [NSString stringWithFormat:@"%@%@", [[self class] currencySymbol:_currencyCode] ? : @"¥", @(_price)];
}

/**
 *  会员级别
 *
 *  @return
 */
-(NSString *)memberLevel {
    return [CSUtils getMemberNameWithLevel:_tag];
}


/**
 *  根据币种代码获取币种符号
 *
 *  @param currencyCode 币种代码
 *
 *  @return 币种符号
 */
+(NSString *)currencySymbol:(NSString *)currencyCode {
    if ([currencyCode isEqualToString:@"CNY"]) {
        return @"¥";
    } else {
        return @"$";
    }
}

@end
