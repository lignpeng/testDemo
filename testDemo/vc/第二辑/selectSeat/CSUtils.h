//
//  CSUtils.h
//  CSMBP
//
//  Created by lyh on 16/5/13.
//  Copyright © 2016年 genpeng. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CSUtils : NSObject


/**
 *  根据会员级别获取相应的会员名称
 *  会员级别 航信定义的南航会员级别
 *  CZ3:南航白金卡 CZ5:南航金卡 CZ7:南航银卡 CZ8:南航普卡 CZ9:南航普通旅客
 *
 *  @param level 会员级别
 *
 *  
 */
+(NSString *)getMemberNameWithLevel:(NSString *)level;

NSDictionary *GetPropertyListOfObject(NSObject *object);
NSDictionary *GetPropertyListOfClass(Class cls);
NSDictionary *GetProtocolPropertyListOfClass(Protocol *proto);

@end
