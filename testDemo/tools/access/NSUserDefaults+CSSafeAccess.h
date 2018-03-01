//
//  NSUserDefaults+SafeAccess.h
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 15/5/23.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (CSSafeAccess)

+ (void)cs_removeObjectForKey:(NSString *)key;

+ (id)cs_objectForKey:(NSString *)key;

+ (NSString *)cs_stringForKey:(NSString *)key;

+ (NSArray *)cs_arrayForKey:(NSString *)key;

+ (NSDictionary *)cs_dictionaryForKey:(NSString *)key;

+ (NSData *)cs_dataForKey:(NSString *)key;

+ (NSArray *)cs_stringArrayForKey:(NSString *)key;

+ (NSInteger)cs_integerForKey:(NSString *)key;

+ (float)cs_floatForKey:(NSString *)key;

+ (double)cs_doubleForKey:(NSString *)key;

+ (BOOL)cs_boolForKey:(NSString *)key;

+ (NSURL *)cs_URLForKey:(NSString *)key;


#pragma mark - WRITE FOR STANDARD

+ (void)cs_setObject:(id)value forKey:(NSString *)key;

#pragma mark - READ ARCHIVE FOR STANDARD

+ (id)cs_arcObjectForKey:(NSString *)key;

#pragma mark - WRITE ARCHIVE FOR STANDARD

+ (void)cs_setArcObject:(id)value forKey:(NSString *)key;


@end