//
//  DataTools.m
//  testDemo
//
//  Created by lignpeng on 2018/7/30.
//  Copyright © 2018年 genpeng. All rights reserved.
//

#import "DataTools.h"
#import <objc/runtime.h>


@implementation DataTools

+ (NSString *)createFileName:(int)length {
    char data[length];
    for (int x=0;x<length;data[x++] = (char)('A' + (arc4random_uniform(26))));
    return [[NSString alloc] initWithBytes:data length:length encoding:NSUTF8StringEncoding];
}

/*
 筛选数组中的对象的相同个数，分组存储，是自定义的对象
 isString：是否字符串数组，不是的话就自定义对象数组，需要指定对象的筛选的key，即对象的属性名
 */
+ (NSArray *)filterMaxItemsArray:(NSArray *)array isStringObj:(BOOL)isString filterKey:(NSString *)key {
    NSMutableArray *origArray = [NSMutableArray arrayWithArray:array];
    NSMutableArray *filerArray = [NSMutableArray array];
    
    while (origArray.count > 0) {
        id obj = origArray.firstObject;
        NSPredicate *predic = nil;
        if (isString) {
            predic = [NSPredicate predicateWithFormat:@"self == %@",obj];
        }else {
            id value = [obj valueForKey:key];
            predic = [NSPredicate predicateWithFormat:@"self.%@ == %@",key,value];
        }
        
        NSArray *pArray = [origArray filteredArrayUsingPredicate:predic];
        [filerArray addObject:pArray];
        [origArray removeObjectsInArray:pArray];
    }
    
    return filerArray;
}

//计算图片大小
+ (NSDictionary *)calulateImageFileSize:(UIImage *)image {
    NSData *data = UIImagePNGRepresentation(image);
    if (!data) {
        data = UIImageJPEGRepresentation(image, 0.5);//需要改成0.5才接近原图片大小，原因请看下文
    }
    double dataLength = [data length] * 1.0;
    NSArray *typeArray = @[@"bytes",@"KB",@"MB",@"GB",@"TB",@"PB", @"EB",@"ZB",@"YB"];
    NSInteger index = 0;
    while (dataLength > 1024) {
        dataLength /= 1024.0;
        index ++;
    }
    NSLog(@"image = %.3f %@",dataLength,typeArray[index]);
    return @{@"size":@(dataLength),@"type":typeArray[index]};
}

+ (float)calulateImageFileSizeTypeMB:(UIImage *)image {
    NSData *data = UIImagePNGRepresentation(image);
    if (!data) {
        data = UIImageJPEGRepresentation(image, 0.5);//需要改成0.5才接近原图片大小
    }
    float dataLength = [data length] * 1.0 /(1024*1024);
    return dataLength;
}

@end
