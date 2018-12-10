//
//  UnmenberToken.m
//  CSMBP
//
//  Created by chen shaomou on 11-8-13.
//  Copyright 2011年 Forever OpenSource Software Inc. All rights reserved.
//

#import "UnmenberToken.h"


@implementation UnmenberToken

- (instancetype)init {
    if (self = [super init]) {
        self.mobilestr = @"";
        self.vCode = @"";
        self.result = @"";
        self.method = @"";
    }
    return self;
}


- (void)setData {
    self.mobilestr = @"13611111111";
    self.vCode = @"123456";
    self.result = @"12300";
    self.method = @"action";
}


@end
