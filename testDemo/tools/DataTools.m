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
    
//    for (int i = 0; i < origArray.count; i++) {
//        if (isString) {//字符串
//            NSString *str = origArray[i];
//            NSMutableArray *tempArray = [NSMutableArray array];
//            [tempArray addObject:str];
//            for (int j = i + 1; j < origArray.count; j ++) {
//                NSString *nextStr = origArray[j];
//                if ([nextStr isEqualToString:str]) {
//                    [tempArray addObject:nextStr];
//                    [origArray removeObjectAtIndex:j];
//                    j -= 1;
//                }
//            }
//            [filerArray addObject:tempArray];
//        } else {
//            //对象操作
//            while (origArray.count > 0) {
//                id obj = origArray.firstObject;
//                id value = [obj valueForKey:key];
//                NSPredicate *predic = [NSPredicate predicateWithFormat:@"self.%@ == %@",key,value];
//                NSArray *pArray = [origArray filteredArrayUsingPredicate:predic];
//                [filerArray addObject:pArray];
//                [origArray removeObjectsInArray:pArray];
//            }
//        }
//    }
    return filerArray;
}

@end
