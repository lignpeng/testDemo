//
//  CSPriceTag.h
//  CSMBP
//
//  Created by lyh on 16/6/30.
//  Copyright © 2016年 genpeng. All rights reserved.
//

#import "JSONModel.h"

@protocol CSPriceTag <NSObject>
@end

@interface CSPriceTag : JSONModel

//价格标签，如CZ3,CZ5,CZ7,CZ9
@property (nonatomic, copy) NSString<Optional> *tag;
//价格，如500
@property (nonatomic) double price;
//货币代码，如CNY
@property (nonatomic, copy) NSString<Optional> *currencyCode;

/**
 *  获取带币种符号的价格字符串
 *
 *  @return
 */
-(NSString *)getPrice;

/**
 *  会员级别
 *
 *  @return
 */
-(NSString *)memberLevel;

/**
 *  根据币种代码获取币种符号
 *
 *  @param currencyCode 币种代码
 *
 *  @return 币种符号
 */
+(NSString *)currencySymbol:(NSString *)currencyCode;
@end
