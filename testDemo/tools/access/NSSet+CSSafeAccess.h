//
//  NSSet+CSSafeAccess.h
//  CSMBP
//
//  Created by lyh on 7/4/16.
//  Copyright © 2016年 Forever OpenSource Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSSet (CSSafeAccess)
+ (instancetype)cs_setWithObject:(id)object;
@end

@interface NSMutableSet (CSSafeAccess)
- (void) cs_addObject:(id)object;
- (void) cs_removeObject:(id)object;
@end

@interface NSOrderedSet (CSSafeAccess)
+ (instancetype)cs_orderedSetWithObject:(id)object;
- (instancetype)cs_initWithObject:(id)object;
- (id)cs_objectAtIndex:(NSUInteger)idx;
@end

@interface NSMutableOrderedSet (CSSafeAccess)
- (void)cs_addObject:(id)object;
- (void)cs_insertObject:(id)object atIndex:(NSUInteger)idx;
- (void)cs_removeObjectAtIndex:(NSUInteger)idx;
- (void)cs_replaceObjectAtIndex:(NSUInteger)idx withObject:(id)object;
@end

@interface NSIndexSet(CSSafeAccess)

@end

#pragma mark - NSMutableIndexSet
@interface NSMutableIndexSet(CSSafeAccess)
- (void)cs_addIndexesInRange:(NSRange)range;
@end