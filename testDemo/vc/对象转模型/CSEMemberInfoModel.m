//
//  CSEMemberInfoModel.m
//  CSMBP
//
//  Created by chpeng on 17/6/9.
//  Copyright © 2017年 China Southern Airlines. All rights reserved.
//

#import "CSEMemberInfoModel.h"

@implementation CSEMemberInfoModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.loginType = @"u";
        self.nonFfpUser = [CSNonFfpUser new];
        self.oneToManyFlag = NO;
        self.token = [UnmenberToken new];
    }
    return self;
}

- (void)setData {
    
}

@end

#pragma mark - 非会员登录对象

@implementation CSELoginInfo

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.aid = @"";
        self.mobileNo = @"";
        self.email = @"";
        self.status = @"";
        self.identifyStatus = @"";
        self.memberNo = @"";
    }
    return self;
}

- (void)setData {
    self.aid = @"1234567890";
    self.mobileNo = @"13611111111";
    self.email = @"123456@126.com";
    self.status = @"Y";
    self.identifyStatus = @"Y";
    self.memberNo = @"95278800";
}

@end

#pragma mark - e行会员信息

@implementation CSNonFfpUser

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.key = @"";
        self.mobileNo = @"";
        self.eLoginInfo = [CSELoginInfo new];
    }
    return self;
}

- (void)setData {
    self.key = @"Y";
    self.mobileNo = @"13611111111";
}

@end
