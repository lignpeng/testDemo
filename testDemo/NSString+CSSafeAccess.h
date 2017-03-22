//
//  NSString+CSSafeAccess.h
//  CSMBP
//
//  Created by lyh on 7/4/16.
//  Copyright © 2016年 Forever OpenSource Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CSSafeAccess)
+ (NSString*) cs_stringWithUTF8String:(const char *)nullTerminatedCString;
+ (instancetype) cs_stringWithCString:(const char *)cString encoding:(NSStringEncoding)enc;
- (instancetype) cs_initWithCString:(const char *)nullTerminatedCString encoding:(NSStringEncoding)encoding;
- (NSString *)cs_stringByAppendingString:(NSString *)aString;
- (NSString *)cs_substringFromIndex:(NSUInteger)from;
- (NSString *)cs_substringToIndex:(NSUInteger)to;
- (NSString *)cs_substringWithRange:(NSRange)range;
- (NSString *)cs_safeJsonValue;
-(NSRange)cs_rangeOfString:(NSString *)aString;

@end

@interface NSMutableString (CSSafeAccess)

- (void) cs_appendString:(NSString *)aString;
- (void) cs_insertString:(NSString *)aString atIndex:(NSUInteger)loc;
- (void) cs_deleteCharactersInRange:(NSRange)range;

@end
