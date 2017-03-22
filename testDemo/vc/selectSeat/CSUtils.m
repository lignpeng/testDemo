//
//  CSUtils.m
//  CSMBP
//
//  Created by lyh on 16/5/13.
//  Copyright © 2016年 China Southern Airlines. All rights reserved.
//

#import "CSUtils.h"
//#import "CSLanguageManager.h"
#import <objc/runtime.h>

@implementation CSUtils


/**
 *  根据会员级别获取相应的会员名称
 *  会员级别 航信定义的南航会员级别
 *  CZ3:南航白金卡 CZ5:南航金卡 CZ7:南航银卡 CZ8:南航普卡 CZ9:南航普通旅客
 *
 *  @param level 会员级别
 *
 *  @return 
 */
+(NSString *)getMemberNameWithLevel:(NSString *)level {
    if ([level isEqualToString:@"CZ3"]) {
        return NSLocalizedString(@"Platinum Card", @"白金卡");
    } else if ([level isEqualToString:@"CZ5"]) {
        return NSLocalizedString(@"Gold Card", @"金卡");
    } else if ([level isEqualToString:@"CZ7"]) {
        return NSLocalizedString(@"Silver Card", @"银卡");
    } else {
        return NSLocalizedString(@"Ordinary passenger", @"普通旅客");
    }
}

NSDictionary *GetPropertyListOfObject(NSObject *object){
    return GetPropertyListOfClass([object class]);
}

NSDictionary *GetPropertyListOfClass(Class cls){
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(cls, &outCount);
    for(i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        const char *propType = property_getAttributes(property);
        if(propType&&propName) {
            NSArray *anAttribute = [[NSString stringWithUTF8String:propType]componentsSeparatedByString:@","];
            NSString *aType = anAttribute[0];
            //暂时不能去掉前缀T@\"和后缀"，需要用以区分标量与否
            //            if ([aType hasPrefix:@"T@\""]) {
            //                aType = [aType substringWithRange:NSMakeRange(3, [aType length]-4)];
            //            }else{
            //                aType = [aType substringFromIndex:1];
            //            }
            [dict setObject:aType forKey:[NSString stringWithUTF8String:propName]];
        }
    }
    free(properties);
    
    return dict;
}

NSDictionary *GetProtocolPropertyListOfClass(Protocol *proto) {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    
    
    unsigned int outCount, i;
    objc_property_t *properties = protocol_copyPropertyList(proto, &outCount);
    for(i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        const char *propType = property_getAttributes(property);
        if(propType&&propName) {
            NSArray *anAttribute = [[NSString stringWithUTF8String:propType]componentsSeparatedByString:@","];
            NSString *aType = anAttribute[0];
            //暂时不能去掉前缀T@\"和后缀"，需要用以区分标量与否
            //            if ([aType hasPrefix:@"T@\""]) {
            //                aType = [aType substringWithRange:NSMakeRange(3, [aType length]-4)];
            //            }else{
            //                aType = [aType substringFromIndex:1];
            //            }
            [dict setObject:aType forKey:[NSString stringWithUTF8String:propName]];
        }
    }
    free(properties);
    
    return dict;
}

@end
