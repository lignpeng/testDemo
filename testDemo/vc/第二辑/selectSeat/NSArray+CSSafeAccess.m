//
//  NSArray+SafeAccess.m
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 15/2/8.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import "NSArray+CSSafeAccess.h"

@implementation NSArray (SafeAccess)

-(id)cs_objectWithIndex:(NSUInteger)index{
    if (index <self.count) {
        return self[index];
    }else{
        return nil;
    }
}

- (NSString*)cs_stringWithIndex:(NSUInteger)index
{
    id value = [self cs_objectWithIndex:index];
    if (value == nil || value == [NSNull null] || [[value description] isEqualToString:@"<null>"])
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


- (NSNumber*)cs_numberWithIndex:(NSUInteger)index
{
    id value = [self cs_objectWithIndex:index];
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

- (NSDecimalNumber *)cs_decimalNumberWithIndex:(NSUInteger)index{
    id value = [self cs_objectWithIndex:index];
    
    if ([value isKindOfClass:[NSDecimalNumber class]]) {
        return value;
    } else if ([value isKindOfClass:[NSNumber class]]) {
        NSNumber * number = (NSNumber*)value;
        return [NSDecimalNumber decimalNumberWithDecimal:[number decimalValue]];
    } else if ([value isKindOfClass:[NSString class]]) {
        NSString * str = (NSString*)value;
        return [str isEqualToString:@""] ? nil : [NSDecimalNumber decimalNumberWithString:str];
    }
    return nil;
}

- (NSArray*)cs_arrayWithIndex:(NSUInteger)index
{
    id value = [self cs_objectWithIndex:index];
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


- (NSDictionary*)cs_dictionaryWithIndex:(NSUInteger)index
{
    id value = [self cs_objectWithIndex:index];
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

- (NSInteger)cs_integerWithIndex:(NSUInteger)index
{
    id value = [self cs_objectWithIndex:index];
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
- (NSUInteger)cs_unsignedIntegerWithIndex:(NSUInteger)index
{
    id value = [self cs_objectWithIndex:index];
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
- (BOOL)cs_boolWithIndex:(NSUInteger)index
{
    id value = [self cs_objectWithIndex:index];
    
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
- (int16_t)cs_int16WithIndex:(NSUInteger)index
{
    id value = [self cs_objectWithIndex:index];
    
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
- (int32_t)cs_int32WithIndex:(NSUInteger)index
{
    id value = [self cs_objectWithIndex:index];
    
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
- (int64_t)cs_int64WithIndex:(NSUInteger)index
{
    id value = [self cs_objectWithIndex:index];
    
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

- (char)cs_charWithIndex:(NSUInteger)index{
    
    id value = [self cs_objectWithIndex:index];
    
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]])
    {
        return [value charValue];
    }
    return 0;
}

- (short)cs_shortWithIndex:(NSUInteger)index
{
    id value = [self cs_objectWithIndex:index];
    
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
- (float)cs_floatWithIndex:(NSUInteger)index
{
    id value = [self cs_objectWithIndex:index];
    
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
- (double)cs_doubleWithIndex:(NSUInteger)index
{
    id value = [self cs_objectWithIndex:index];
    
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

- (NSDate *)cs_dateWithIndex:(NSUInteger)index dateFormat:(NSString *)dateFormat {
    NSDateFormatter *formater = [[NSDateFormatter alloc]init];
    formater.dateFormat = dateFormat;
    id value = [self cs_objectWithIndex:index];
    
    if (value == nil || value == [NSNull null])
    {
        return nil;
    }
    
    if ([value isKindOfClass:[NSString class]] && ![value isEqualToString:@""] && !dateFormat) {
        return [formater dateFromString:value];
    }
    return nil;
}

//CG
- (CGFloat)cs_CGFloatWithIndex:(NSUInteger)index
{
    id value = [self cs_objectWithIndex:index];
    
    CGFloat f = [value doubleValue];
    
    return f;
}

- (CGPoint)cs_pointWithIndex:(NSUInteger)index
{
    id value = [self cs_objectWithIndex:index];
    
    CGPoint point = CGPointFromString(value);
    
    return point;
}
- (CGSize)cs_sizeWithIndex:(NSUInteger)index
{
    id value = [self cs_objectWithIndex:index];
    
    CGSize size = CGSizeFromString(value);
    
    return size;
}
- (CGRect)cs_rectWithIndex:(NSUInteger)index
{
    id value = [self cs_objectWithIndex:index];
    
    CGRect rect = CGRectFromString(value);
    
    return rect;
}


- (NSArray *)cs_subarrayWithRange:(NSRange)range {
    if (range.location != NSNotFound && range.length != NSNotFound && range.location + range.length <= self.count){
        return [self subarrayWithRange:range];
    }else if (range.location != NSNotFound && range.location < self.count){
        return [self subarrayWithRange:NSMakeRange(range.location, self.count-range.location)];
    }
    return nil;
}


@end


#pragma --mark NSMutableArray setter
@implementation NSMutableArray (SafeAccess)
-(void)cs_addObj:(id)i{
    if (i!=nil) {
        [self addObject:i];
    }
}
-(void)cs_addObjectsFromArray:(NSArray *)i{
    if (i!=nil) {
        [self addObjectsFromArray:i];
    }
}
-(void)cs_addString:(NSString*)i
{
    if (i!=nil) {
        [self cs_addObj:i];
    }
}
-(void)cs_addBool:(BOOL)i
{
    [self cs_addObj:@(i)];
}
-(void)cs_addInt:(int)i
{
    [self cs_addObj:@(i)];
}
-(void)cs_addInteger:(NSInteger)i
{
    [self cs_addObj:@(i)];
}
-(void)cs_addUnsignedInteger:(NSUInteger)i
{
    [self cs_addObj:@(i)];
}
-(void)cs_addCGFloat:(CGFloat)f
{
    [self cs_addObj:@(f)];
}
-(void)cs_addChar:(char)c
{
    [self cs_addObj:@(c)];
}
-(void)cs_addFloat:(float)i
{
    [self cs_addObj:@(i)];
}
-(void)cs_addPoint:(CGPoint)o
{
    [self cs_addObj:NSStringFromCGPoint(o)];
}
-(void)cs_addSize:(CGSize)o
{
    [self cs_addObj:NSStringFromCGSize(o)];
}
-(void)cs_addRect:(CGRect)o
{
    [self cs_addObj:NSStringFromCGRect(o)];
}

- (void) cs_insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (anObject && index <= self.count) {
        [self insertObject:anObject atIndex:index];
    } else {
        if (!anObject) {
            NSLog(@"NSMutableArray invalid args cs_hookInsertObject:[%@] atIndex:[%@]", anObject, @(index));
        }
        if (index > self.count) {
            NSLog(@"NSMutableArray cs_hookInsertObject[%@] atIndex:[%@] out of bound:[%@]", anObject, @(index), @(self.count));
        }
    }
}

- (void) cs_removeObjectAtIndex:(NSUInteger)index {
    if (index < self.count) {
        [self removeObjectAtIndex:index];
    } else {
        NSLog(@"NSMutableArray cs_hookRemoveObjectAtIndex:[%@] out of bound:[%@]", @(index), @(self.count));
    }
}


- (void) cs_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    if (index < self.count && anObject) {
        [self replaceObjectAtIndex:index withObject:anObject];
    } else {
        if (!anObject) {
            NSLog( @"NSMutableArray invalid args cs_hookReplaceObjectAtIndex:[%@] withObject:[%@]", @(index), anObject);
        }
        if (index >= self.count) {
            NSLog(@"NSMutableArray cs_hookReplaceObjectAtIndex:[%@] withObject:[%@] out of bound:[%@]", @(index), anObject, @(self.count));
        }
    }
}

- (void) cs_removeObjectsInRange:(NSRange)range {
    if (range.location + range.length <= self.count) {
        [self removeObjectsInRange:range];
    }else {
        NSLog( @"NSMutableArray invalid args cs_hookRemoveObjectsInRange:[%@]", NSStringFromRange(range));
    }
}

@end