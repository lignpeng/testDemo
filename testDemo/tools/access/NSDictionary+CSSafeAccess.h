//
//  NSDictionary+CSSafeAccess.h
//  CSMBP
//
//  Created by lyh on 28/3/16.
//  Copyright © 2016年 Forever OpenSource Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (CSSafeAccess)
- (id)cs_objectForKey:(id)key;

- (NSString*)cs_stringForKey:(id)key;

- (NSNumber*)cs_numberForKey:(id)key;

- (NSArray*)cs_arrayForKey:(id)key;

- (NSDictionary*)cs_dictionaryForKey:(id)key;

- (NSInteger)cs_integerForKey:(id)key;

- (NSUInteger)cs_unsignedIntegerForKey:(id)key;

- (BOOL)cs_boolForKey:(id)key;

- (int16_t)cs_int16ForKey:(id)key;

- (int32_t)cs_int32ForKey:(id)key;

- (int64_t)cs_int64ForKey:(id)key;

- (char)cs_charForKey:(id)key;

- (short)cs_shortForKey:(id)key;

- (float)cs_floatForKey:(id)key;

- (double)cs_doubleForKey:(id)key;

- (long long)cs_longLongForKey:(id)key;

- (unsigned long long)cs_unsignedLongLongForKey:(id)key;

//CG
- (CGFloat)cs_CGFloatForKey:(id)key;

- (CGPoint)cs_pointForKey:(id)key;

- (CGSize)cs_sizeForKey:(id)key;

- (CGRect)cs_rectForKey:(id)key;
@end

#pragma --mark NSMutableDictionary setter

@interface NSMutableDictionary(SafeAccess)

-(void)cs_setObj:(id)i forKey:(NSString*)key;

-(void)cs_setString:(NSString*)i forKey:(NSString*)key;

-(void)cs_setBool:(BOOL)i forKey:(NSString*)key;

-(void)cs_setInt:(int)i forKey:(NSString*)key;

-(void)cs_setInteger:(NSInteger)i forKey:(NSString*)key;

-(void)cs_setUnsignedInteger:(NSUInteger)i forKey:(NSString*)key;

-(void)cs_setCGFloat:(CGFloat)f forKey:(NSString*)key;

-(void)cs_setChar:(char)c forKey:(NSString*)key;

-(void)cs_setFloat:(float)i forKey:(NSString*)key;

-(void)cs_setDouble:(double)i forKey:(NSString*)key;

-(void)cs_setLongLong:(long long)i forKey:(NSString*)key;

-(void)cs_setPoint:(CGPoint)o forKey:(NSString*)key;

-(void)cs_setSize:(CGSize)o forKey:(NSString*)key;

-(void)cs_setRect:(CGRect)o forKey:(NSString*)key;

- (void) cs_removeObjectForKey:(id)aKey;
@end
