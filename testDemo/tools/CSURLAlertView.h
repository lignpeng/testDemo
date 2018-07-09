//
//  CSURLAlertView.h
//  CSMBP-AppStore-Package
//
//  Created by lignpeng on 2018/6/11.
//  Copyright © 2018年 China Southern Airlines. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSURLAlertView : UIView

+ (instancetype)urlAlertView;

//fullString:完整的字符串，urlStr：要转换成链接部分的字符串
+ (instancetype)urlAlertView:(NSString *)fullString urlString:(NSString *)urlStr complish:(void(^)(BOOL flag))complishBlock;

    //fullString:完整的字符串，urlStr：要转换成链接部分的字符串
+ (instancetype)urlAlertView:(NSString *)fullString urlString:(NSString *)urlStr buttonTitle:(NSString *)title complish:(void(^)(BOOL flag))complishBlock;

@end
