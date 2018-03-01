//
//  NSArray+CSSafeAccess.h
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 15/2/8.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (CSSafeAccess)
-(id)cs_objectWithIndex:(NSUInteger)index;

- (NSString*)cs_stringWithIndex:(NSUInteger)index;

- (NSNumber*)cs_numberWithIndex:(NSUInteger)index;

- (NSDecimalNumber *)cs_decimalNumberWithIndex:(NSUInteger)index;

- (NSArray*)cs_arrayWithIndex:(NSUInteger)index;

- (NSDictionary*)cs_dictionaryWithIndex:(NSUInteger)index;

- (NSInteger)cs_integerWithIndex:(NSUInteger)index;

- (NSUInteger)cs_unsignedIntegerWithIndex:(NSUInteger)index;

- (BOOL)cs_boolWithIndex:(NSUInteger)index;

- (int16_t)cs_int16WithIndex:(NSUInteger)index;

- (int32_t)cs_int32WithIndex:(NSUInteger)index;

- (int64_t)cs_int64WithIndex:(NSUInteger)index;

- (char)cs_charWithIndex:(NSUInteger)index;

- (short)cs_shortWithIndex:(NSUInteger)index;

- (float)cs_floatWithIndex:(NSUInteger)index;

- (double)cs_doubleWithIndex:(NSUInteger)index;

- (NSDate *)cs_dateWithIndex:(NSUInteger)index dateFormat:(NSString *)dateFormat;
//CG
- (CGFloat)cs_CGFloatWithIndex:(NSUInteger)index;

- (CGPoint)cs_pointWithIndex:(NSUInteger)index;

- (CGSize)cs_sizeWithIndex:(NSUInteger)index;

- (CGRect)cs_rectWithIndex:(NSUInteger)index;

- (NSArray *)cs_subarrayWithRange:(NSRange)range;

@end


#pragma --mark NSMutableArray setter

@interface NSMutableArray(CSSafeAccess)

-(void)cs_addObj:(id)i;
-(void)cs_addObjectsFromArray:(NSArray *)i;

-(void)cs_addString:(NSString*)i;

-(void)cs_addBool:(BOOL)i;

-(void)cs_addInt:(int)i;

-(void)cs_addInteger:(NSInteger)i;

-(void)cs_addUnsignedInteger:(NSUInteger)i;

-(void)cs_addCGFloat:(CGFloat)f;

-(void)cs_addChar:(char)c;

-(void)cs_addFloat:(float)i;

-(void)cs_addPoint:(CGPoint)o;

-(void)cs_addSize:(CGSize)o;

-(void)cs_addRect:(CGRect)o;

- (void) cs_insertObject:(id)anObject atIndex:(NSUInteger)index;

- (void) cs_removeObjectAtIndex:(NSUInteger)index;

- (void) cs_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;

- (void) cs_removeObjectsInRange:(NSRange)range;


@end
