//
//  NSSet+CSSafeAccess.m
//  CSMBP
//
//  Created by lyh on 7/4/16.
//  Copyright © 2016年 Forever OpenSource Software Inc. All rights reserved.
//

#import "NSSet+CSSafeAccess.h"

#pragma mark - NSSet
@implementation NSSet (CSSafeAccess)
+ (instancetype)cs_setWithObject:(id)object
{
    if (object){
        return [self setWithObject:object];
    }
    NSLog(@"NSSet invalid args cs_hookSetWithObject:[%@]", object);
    return nil;
}
@end

@implementation NSMutableSet (CSSafeAccess)
- (void) cs_addObject:(id)object {
    if (object) {
        [self addObject:object];
    } else {
        NSLog(@"NSMutableSet invalid args cs_hookAddObject[%@]", object);
    }
}

- (void) cs_removeObject:(id)object {
    if (object) {
        [self removeObject:object];
    } else {
        NSLog(@"NSMutableSet invalid args cs_hookRemoveObject[%@]", object);
    }
}
@end

#pragma mark - NSOrderedSet
@implementation NSOrderedSet (CSSafeAccess)
+ (instancetype)cs_orderedSetWithObject:(id)object
{
    if (object) {
        return [self orderedSetWithObject:object];
    }
    NSLog(@"NSOrderedSet invalid args cs_hookOrderedSetWithObject:[%@]", object);
    return nil;
}
- (instancetype)cs_initWithObject:(id)object
{
    if (object){
        return [self initWithObject:object];
    }
    NSLog(@"NSOrderedSet invalid args cs_hookInitWithObject:[%@]", object);
    return nil;
}
- (id)cs_objectAtIndex:(NSUInteger)idx
{
    if (idx < self.count){
        return [self objectAtIndex:idx];
    }
    return nil;
}
@end

@implementation NSMutableOrderedSet (CSSafeAccess)
- (void)cs_addObject:(id)object {
    if (object) {
        [self addObject:object];
    } else {
        NSLog(@"NSMutableOrderedSet invalid args cs_hookAddObject:[%@]", object);
    }
}
- (void)cs_insertObject:(id)object atIndex:(NSUInteger)idx
{
    if (object && idx <= self.count) {
        [self insertObject:object atIndex:idx];
    }else{
        NSLog(@"NSMutableOrderedSet invalid args cs_hookInsertObject:[%@] atIndex:[%@]", object, @(idx));
    }
}
- (void)cs_removeObjectAtIndex:(NSUInteger)idx
{
    if (idx < self.count){
        [self removeObjectAtIndex:idx];
    }else{
        NSLog(@"NSMutableOrderedSet invalid args cs_hookRemoveObjectAtIndex:[%@]", @(idx));
    }
}
- (void)cs_replaceObjectAtIndex:(NSUInteger)idx withObject:(id)object
{
    if (object && idx < self.count) {
        [self replaceObjectAtIndex:idx withObject:object];
    }else{
        NSLog(@"NSMutableOrderedSet invalid args cs_hookReplaceObjectAtIndex:[%@] withObject:[%@]", @(idx), object);
    }
}
@end

#pragma mark - NSIndexSet
@implementation NSIndexSet(CSSafeAccess)

@end

#pragma mark - NSMutableIndexSet
@implementation NSMutableIndexSet(CSSafeAccess)
- (void)cs_addIndexesInRange:(NSRange)range {
    if (range.location != NSNotFound && range.length != NSNotFound) {
        [self addIndexesInRange:range];
    }
}

@end
