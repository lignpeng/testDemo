//
//  DataTools.h
//  testDemo
//
//  Created by lignpeng on 2018/7/30.
//  Copyright © 2018年 genpeng. All rights reserved.
//
/*
 关于数据方面的操作
 
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DataTools : NSObject

//创建随机字符串
+ (NSString *)createFileName:(int)length;
/*
 筛选数组中的对象的相同个数，分组存储，是自定义的对象
 isString：是否字符串数组，不是的话就自定义对象数组，需要指定对象的筛选的key，即对象的属性名
 */
+ (NSArray *)filterMaxItemsArray:(NSArray *)origArray isStringObj:(BOOL)isString filterKey:(NSString *)key;

//计算图片大小{@"size":大小,@"type":type}
+ (NSDictionary *)calulateImageFileSize:(UIImage *)image;
+ (float)calulateImageFileSizeTypeMB:(UIImage *)image;
@end
