//
//  TxetTools.h
//  testDemo
//
//  Created by lignpeng on 2019/1/2.
//  Copyright © 2019年 genpeng. All rights reserved.
//
/*
 文本相关工具
 
 */

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

static NSString *kStringAttributeTextSeparateKey = @"&&";
static NSString *kStringAttributeColorSeparateKey = @"|";
NS_ASSUME_NONNULL_BEGIN

@interface TxetTools : NSObject
/*
 orginString：原始的字符串
 attributString：加了颜色属性的字符串，如@“原始的|#E5004E,字符串|#E5004E”
 */
+ (NSMutableAttributedString *)stringChangeToAttributeString:(NSString *)orginString attributStr:(NSString *)attributString;

/*
 图文混排
 图片插在最前
 */
+ (NSMutableAttributedString *)attributeImageString:(NSString *)orginString attributStr:(NSString *)attributString insertImage:(NSString *)image font:(UIFont *)font;

    //指定字体类型pingFang、大小
+ (UIFont *)pingFangFont:(NSInteger)fontSize;
+ (UIFont *)pingFangBoldFont:(NSInteger)fontSize;

    //计算文本size，rectSize：默认CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), MAXFLOAT)
+ (CGSize )stringSize:(NSString *)string font:(UIFont *)font rectSize:(CGSize)rectSize;

@end

NS_ASSUME_NONNULL_END
