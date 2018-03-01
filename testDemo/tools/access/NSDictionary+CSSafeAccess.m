//
//  NSDictionary+CSSafeAccess.m
//  CSMBP
//
//  Created by lyh on 28/3/16.
//  Copyright © 2016年 Forever OpenSource Software Inc. All rights reserved.
//

#import "NSDictionary+CSSafeAccess.h"

@implementation NSDictionary (CSSafeAccess)
- (id)cs_objectForKey:(id)key {
    if (key){
        return [self objectForKey:key];
    }
    return nil;
}

- (NSString*)cs_stringForKey:(id)key
{
    id value = [self cs_objectForKey:key];
    if (value == nil || value == [NSNull null])
    {
        return nil;
    }
    if ([value isKindOfClass:[NSString class]]) {
        return (NSString*)value;
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value stringValue];
    }
    
    return nil;
}

- (NSNumber*)cs_numberForKey:(id)key
{
    id value = [self cs_objectForKey:key];
    if ([value isKindOfClass:[NSNumber class]]) {
        return (NSNumber*)value;
    }
    if ([value isKindOfClass:[NSString class]]) {
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        return [f numberFromString:(NSString*)value];
    }
    return nil;
}

- (NSArray*)cs_arrayForKey:(id)key
{
    id value = [self cs_objectForKey:key];
    if (value == nil || value == [NSNull null])
    {
        return nil;
    }
    if ([value isKindOfClass:[NSArray class]])
    {
        return value;
    }
    return nil;
}

- (NSDictionary*)cs_dictionaryForKey:(id)key
{
    id value = [self cs_objectForKey:key];
    if (value == nil || value == [NSNull null])
    {
        return nil;
    }
    if ([value isKindOfClass:[NSDictionary class]])
    {
        return value;
    }
    return nil;
}

- (NSInteger)cs_integerForKey:(id)key
{
    id value = [self cs_objectForKey:key];
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]])
    {
        return [value integerValue];
    }
    return 0;
}
- (NSUInteger)cs_unsignedIntegerForKey:(id)key{
    id value = [self cs_objectForKey:key];
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]])
    {
        return [value unsignedIntegerValue];
    }
    return 0;
}
- (BOOL)cs_boolForKey:(id)key
{
    id value = [self cs_objectForKey:key];
    
    if (value == nil || value == [NSNull null])
    {
        return NO;
    }
    if ([value isKindOfClass:[NSNumber class]])
    {
        return [value boolValue];
    }
    if ([value isKindOfClass:[NSString class]])
    {
        return [value boolValue];
    }
    return NO;
}
- (int16_t)cs_int16ForKey:(id)key
{
    id value = [self cs_objectForKey:key];
    
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]])
    {
        return [value shortValue];
    }
    if ([value isKindOfClass:[NSString class]])
    {
        return [value intValue];
    }
    return 0;
}
- (int32_t)cs_int32ForKey:(id)key
{
    id value = [self cs_objectForKey:key];
    
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]])
    {
        return [value intValue];
    }
    return 0;
}
- (int64_t)cs_int64ForKey:(id)key
{
    id value = [self cs_objectForKey:key];
    
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]])
    {
        return [value longLongValue];
    }
    return 0;
}
- (char)cs_charForKey:(id)key{
    id value = [self cs_objectForKey:key];
    
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]])
    {
        return [value charValue];
    }
    if ([value isKindOfClass:[NSString class]] && ((NSString *)value).length > 0) {
        return [value characterAtIndex:0];
    }
    return 0;
}
- (short)cs_shortForKey:(id)key
{
    id value = [self cs_objectForKey:key];
    
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]])
    {
        return [value shortValue];
    }
    if ([value isKindOfClass:[NSString class]])
    {
        return [value intValue];
    }
    return 0;
}
- (float)cs_floatForKey:(id)key
{
    id value = [self cs_objectForKey:key];
    
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]])
    {
        return [value floatValue];
    }
    return 0;
}
- (double)cs_doubleForKey:(id)key
{
    id value = [self cs_objectForKey:key];
    
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]])
    {
        return [value doubleValue];
    }
    return 0;
}
- (long long)cs_longLongForKey:(id)key
{
    id value = [self cs_objectForKey:key];
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
        return [value longLongValue];
    }
    return 0;
}

- (unsigned long long)cs_unsignedLongLongForKey:(id)key
{
    id value = [self cs_objectForKey:key];
    if ([value isKindOfClass:[NSString class]]) {
        NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
        value = [nf numberFromString:value];
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value unsignedLongLongValue];
    }
    return 0;
}
//CG
- (CGFloat)cs_CGFloatForKey:(id)key
{
    CGFloat f = [[self cs_stringForKey:key] doubleValue];
    return f;
}

- (CGPoint)cs_pointForKey:(id)key
{
    CGPoint point = CGPointFromString([self cs_stringForKey:key]);
    return point;
}
- (CGSize)cs_sizeForKey:(id)key
{
    CGSize size = CGSizeFromString([self cs_stringForKey:key]);
    return size;
}
- (CGRect)cs_rectForKey:(id)key
{
    CGRect rect = CGRectFromString([self cs_stringForKey:key]);
    return rect;
}
@end

#pragma --mark NSMutableDictionary setter
@implementation NSMutableDictionary (SafeAccess)
-(void)cs_setObj:(id)i forKey:(NSString*)key{
    if (!key) {
        return;
    }
    if (i!=nil) {
        self[key] = i;
    }
}
-(void)cs_setString:(NSString*)i forKey:(NSString*)key;
{
    if (!key) {
        return;
    }
    if (!i) {
        i = @"";
    }
    [self setValue:i forKey:key];
}
-(void)cs_setBool:(BOOL)i forKey:(NSString *)key
{
    if (!key) {
        return;
    }
    self[key] = @(i);
}
-(void)cs_setInt:(int)i forKey:(NSString *)key
{
    if (!key) {
        return;
    }
    self[key] = @(i);
}
-(void)cs_setInteger:(NSInteger)i forKey:(NSString *)key
{
    if (!key) {
        return;
    }
    self[key] = @(i);
}
-(void)cs_setUnsignedInteger:(NSUInteger)i forKey:(NSString *)key
{
    if (!key) {
        return;
    }
    self[key] = @(i);
}
-(void)cs_setCGFloat:(CGFloat)f forKey:(NSString *)key
{
    if (!key) {
        return;
    }
    self[key] = @(f);
}
-(void)cs_setChar:(char)c forKey:(NSString *)key
{
    if (!key) {
        return;
    }
    self[key] = @(c);
}
-(void)cs_setFloat:(float)i forKey:(NSString *)key
{
    if (!key) {
        return;
    }
    self[key] = @(i);
}
-(void)cs_setDouble:(double)i forKey:(NSString*)key{
    self[key] = @(i);
}
-(void)cs_setLongLong:(long long)i forKey:(NSString*)key{
    if (!key) {
        return;
    }
    self[key] = @(i);
}
-(void)cs_setPoint:(CGPoint)o forKey:(NSString *)key
{
    if (!key) {
        return;
    }
    self[key] = NSStringFromCGPoint(o);
}
-(void)cs_setSize:(CGSize)o forKey:(NSString *)key
{
    if (!key) {
        return;
    }
    self[key] = NSStringFromCGSize(o);
}
-(void)cs_setRect:(CGRect)o forKey:(NSString *)key
{
    if (!key) {
        return;
    }
    self[key] = NSStringFromCGRect(o);
}
- (void) cs_removeObjectForKey:(id)aKey {
    if (aKey) {
        [self removeObjectForKey:aKey];
    } else {
        NSLog(@"NSMutableDictionary invalid args cs_hookRemoveObjectForKey:[%@]", aKey);
    }
}

@end
