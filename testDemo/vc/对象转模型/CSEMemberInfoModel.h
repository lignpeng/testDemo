//
//  CSEMemberInfoModel.h
//  CSMBP
//
//  Created by chpeng on 17/6/9.
//  Copyright © 2017年 China Southern Airlines. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UnmenberToken.h"

@class CSNonFfpUser, CSELoginInfo;

@interface CSEMemberInfoModel : NSObject

/**  登录类型
 0会员密码登录
 1 会员免密码登录
 2 手机非会员
 3 qq绑定会员登录
 4 qq非会员登录
 5 微信会员登录
 6 微信非会员登录
 7 微博会员登录
 8 微信非会员登录
 */
@property (nonatomic, copy) NSString *loginType;


/**
 用户信息   非会员登录对象
 */
@property (nonatomic, strong) CSNonFfpUser *nonFfpUser;


/**
 是否多卡号标识 ture 表示多卡号
 */
@property (nonatomic, assign) BOOL oneToManyFlag;

@property (nonatomic, strong) UnmenberToken *token;

- (void)setData;
@end


#pragma mark - 非会员登录对象

@interface CSNonFfpUser : NSObject

/**
 成功失败标示
 */
@property (nonatomic, copy) NSString *key;

/**
 手机号码
 */
@property (nonatomic, copy) NSString *mobileNo;

/**
 e行会员信息
 */
@property (nonatomic, strong) CSELoginInfo *eLoginInfo;
- (void)setData;
@end


#pragma mark - e行会员信息

@interface CSELoginInfo : NSObject

/**
 E用户编号
 */
@property (nonatomic, copy) NSString *aid;

/**
 手机号码
 */
@property (nonatomic, copy) NSString *mobileNo;

/**
 邮箱
 */
@property (nonatomic, copy) NSString *email;

/**
 用户状态
 */
@property (nonatomic, copy) NSString *status;

/**
 认证状态
 */
@property (nonatomic, copy) NSString *identifyStatus;

/**
 会员卡号
 */
@property (nonatomic, copy) NSString *memberNo;
- (void)setData;
@end


