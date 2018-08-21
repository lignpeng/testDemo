//
//  NSString+CSSafeAccess.m
//  CSMBP
//
//  Created by lyh on 7/4/16.
//  Copyright © 2016年 Forever OpenSource Software Inc. All rights reserved.
//

#import "NSString+CSSafeAccess.h"

@implementation NSString (CSSafeAccess)
+ (NSString*) cs_stringWithUTF8String:(const char *)nullTerminatedCString
{
    if (NULL != nullTerminatedCString) {
        return [NSString stringWithUTF8String:nullTerminatedCString];
    }
    return nil;
}
+ (instancetype) cs_stringWithCString:(const char *)cString encoding:(NSStringEncoding)enc
{
    if (NULL != cString){
        return [NSString stringWithCString:cString encoding:enc];
    }
    return nil;
}
- (instancetype) cs_initWithCString:(const char *)nullTerminatedCString encoding:(NSStringEncoding)encoding
{
    if (NULL != nullTerminatedCString){
        return [self initWithCString:nullTerminatedCString encoding:encoding];
    }
    return nil;
}
- (NSString *)cs_stringByAppendingString:(NSString *)aString
{
    if (aString){
        return [self stringByAppendingString:aString];
    }
    return self;
}
- (NSString *)cs_substringFromIndex:(NSUInteger)from
{
    if (from <= self.length) {
        return [self substringFromIndex:from];
    }
    return nil;
}
- (NSString *)cs_substringToIndex:(NSUInteger)to
{
    if (to <= self.length) {
        return [self substringToIndex:to];
    }
    return self;
}

- (NSString *)cs_safeJsonValue
{
    return self?:@"";
}

- (NSString *)cs_substringWithRange:(NSRange)range
{
    if (range.location + range.length <= self.length) {
        return [self substringWithRange:range];
    }else if (range.location < self.length){
        return [self substringWithRange:NSMakeRange(range.location, self.length-range.location)];
    }
    return nil;
}

-(NSRange)cs_rangeOfString:(NSString *)aString {
    if (aString) {
        return [self rangeOfString:aString];
    }
    
    return NSMakeRange(NSNotFound, 0);
}

@end

@implementation NSMutableString (CSSafeAccess)

- (void) cs_appendString:(NSString *)aString
{
    if (aString){
        [self appendString:aString];
    }else{
        NSLog(@"NSMutableString invalid args cs_hookAppendString:[%@]", aString);
    }
}
- (void) cs_insertString:(NSString *)aString atIndex:(NSUInteger)loc
{
    if (aString && loc <= self.length) {
        [self insertString:aString atIndex:loc];
    }else{
        NSLog(@"NSMutableString invalid args cs_hookInsertString:[%@] atIndex:[%@]", aString, @(loc));
    }
}
- (void) cs_deleteCharactersInRange:(NSRange)range
{
    if (range.location + range.length <= self.length){
        [self deleteCharactersInRange:range];
    }else{
        NSLog(@"NSMutableString invalid args cs_hookDeleteCharactersInRange:[%@]", NSStringFromRange(range));
    }
}

@end
