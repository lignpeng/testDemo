//
//  TxetTools.m
//  testDemo
//
//  Created by lignpeng on 2019/1/2.
//  Copyright © 2019年 genpeng. All rights reserved.
//

#import "TxetTools.h"
#import "HexColor.h"

@implementation TxetTools

+ (NSMutableAttributedString *)stringChangeToAttributeString:(NSString *)orginString attributStr:(NSString *)attributString {
    NSMutableAttributedString *infoStr = [[NSMutableAttributedString alloc] initWithString:orginString];
    NSArray *slipArray = [attributString componentsSeparatedByString:kStringAttributeTextSeparateKey];
    NSMutableArray *colorArray = [NSMutableArray array];
    NSMutableArray *strArray = [NSMutableArray array];
    for (NSString *str in slipArray) {
        NSArray *infoStrArray = [str componentsSeparatedByString:kStringAttributeColorSeparateKey];
        [strArray addObject:infoStrArray.firstObject];
        [colorArray addObject:infoStrArray.lastObject];
    }
    NSUInteger startRange = 0;
    NSUInteger length = 0;
    for (int i = 0; i < strArray.count; i++) {
        length = ((NSString *)[strArray objectAtIndex:i]).length;
        [infoStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:(NSString *)[colorArray objectAtIndex:i]] range:NSMakeRange(startRange,length)];
        startRange += length;
    }
    return infoStr;
}

+ (CGSize )stringSize:(NSString *)string font:(UIFont *)font rectSize:(CGSize)rectSize {
        //CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), MAXFLOAT)
    if (CGSizeEqualToSize(rectSize, CGSizeZero) ) {
        rectSize = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), MAXFLOAT);
    }
    CGSize strSize = [string boundingRectWithSize:rectSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    return strSize;
}

+ (NSMutableAttributedString *)attributeImageString:(NSString *)orginString attributStr:(NSString *)attributString insertImage:(NSString *)image font:(UIFont *)font{
    NSMutableAttributedString *infoStr = [self stringChangeToAttributeString:orginString attributStr:attributString];
    CGSize titleSize = [orginString boundingRectWithSize:CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
        // 创建图片图片附件
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage imageNamed:image];
    attach.bounds = CGRectMake(0, (titleSize.height - attach.image.size.height*[UIScreen mainScreen].scale)/([UIScreen mainScreen].scale * 2), attach.image.size.width, attach.image.size.height);
    NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:attach];
        //将图片插入到合适的位置
    [infoStr insertAttributedString:attachString atIndex:0];
    return infoStr;
}

+ (UIFont *)pingFangFont:(NSInteger)fontSize {
    return [self replaceFont:fontSize fontName:@"PingFang SC"];
}

+ (UIFont *)pingFangBoldFont:(NSInteger)fontSize {
    return [self replaceFont:fontSize fontName:@"PingFang SC Bold"];
}

+ (UIFont *)replaceFont:(NSInteger)fontSize fontName:(NSString *)name {
    if (@available(iOS 9.0, *)) {
        return [UIFont fontWithName:name size:fontSize];
    }
    else{
        return [UIFont systemFontOfSize:fontSize];
    }
}


@end
