//
//  NSUserDefaults+SafeAccess.m
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 15/5/23.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import "NSUserDefaults+CSSafeAccess.h"

@implementation NSUserDefaults (CSSafeAccess)

+ (void)cs_removeObjectForKey:(NSString *)key {
    if (!key) {
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)cs_objectForKey:(NSString *)key {
    if (!key) {
        return nil;
    }
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (NSString *)cs_stringForKey:(NSString *)key {
    if (!key) {
        return nil;
    }
    return [[NSUserDefaults standardUserDefaults] stringForKey:key];
}

+ (NSArray *)cs_arrayForKey:(NSString *)key {
    if (!key) {
        return nil;
    }
    return [[NSUserDefaults standardUserDefaults] arrayForKey:key];
}

+ (NSDictionary *)cs_dictionaryForKey:(NSString *)key {
    if (!key) {
        return nil;
    }
    return [[NSUserDefaults standardUserDefaults] dictionaryForKey:key];
}

+ (NSData *)cs_dataForKey:(NSString *)key {
    if (!key) {
        return nil;
    }
    return [[NSUserDefaults standardUserDefaults] dataForKey:key];
}

+ (NSArray *)cs_stringArrayForKey:(NSString *)key {
    if (!key) {
        return nil;
    }
    return [[NSUserDefaults standardUserDefaults] stringArrayForKey:key];
}

+ (NSInteger)cs_integerForKey:(NSString *)key {
    if (!key) {
        return 0;
    }
    return [[NSUserDefaults standardUserDefaults] integerForKey:key];
}

+ (float)cs_floatForKey:(NSString *)key {
    if (!key) {
        return 0.0;
    }
    return [[NSUserDefaults standardUserDefaults] floatForKey:key];
}

+ (double)cs_doubleForKey:(NSString *)key {
    if (!key) {
        return 0.0;
    }
    return [[NSUserDefaults standardUserDefaults] doubleForKey:key];
}

+ (BOOL)cs_boolForKey:(NSString *)key {
    if (!key) {
        return NO;
    }
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

+ (NSURL *)cs_URLForKey:(NSString *)key {
    if (!key) {
        return nil;
    }
    return [[NSUserDefaults standardUserDefaults] URLForKey:key];
}

#pragma mark - WRITE FOR STANDARD

+ (void)cs_setObject:(id)value forKey:(NSString *)key {
    if (!key) {
        return;
    }
    if (value == nil || [value isKindOfClass:[NSNull class]]) {
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - READ ARCHIVE FOR STANDARD

+ (id)cs_arcObjectForKey:(NSString *)key {
    if (!key) {
        return nil;
    }
    return [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:key]];
}

#pragma mark - WRITE ARCHIVE FOR STANDARD

+ (void)cs_setArcObject:(id)value forKey:(NSString *)key {
    if (!key) {
        return;
    }
    [NSUserDefaults cs_setObject:[NSKeyedArchiver archivedDataWithRootObject:value] forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
