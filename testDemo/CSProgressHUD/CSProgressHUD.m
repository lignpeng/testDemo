//
//  CSProgressHUD.m
//  CSMBP
//
//  Created by Sencho Kong on 15/11/18.
//  Copyright © 2015年 Forever OpenSource Software Inc. All rights reserved.
//

#import "CSProgressHUD.h"
#import "CSProgressHUD_MBProgressHUD.h"
#define localLanIsEN false

static id _currentHUD;

@implementation CSProgressHUD

+ (void)show{
    _currentHUD =[[CSProgressHUD_MBProgressHUD alloc] init];
//    [(CSProgressHUD_MBProgressHUD *)_currentHUD showWithMessage:nil cancelCallBackBlock:nil];
    [(CSProgressHUD_MBProgressHUD *)_currentHUD showWithImageName:@"new_loading" cancelCallBackBlock:nil];
}

+ (void)showWithMessage:(NSString *)message cancelCallBackBlock:(CancelCallBackBlock)block{
    _currentHUD =[[CSProgressHUD_MBProgressHUD alloc] init];

    [(CSProgressHUD_MBProgressHUD *)_currentHUD showWithMessage:message cancelCallBackBlock:block];
}

+ (void)showWithImageName:(NSString *)imageName cancelCallBackBlock:(CancelCallBackBlock)block
{
    _currentHUD = [[CSProgressHUD_MBProgressHUD alloc] init];
    [(CSProgressHUD_MBProgressHUD *)_currentHUD showWithImageName:imageName cancelCallBackBlock:block];
}

+ (void)dismiss{
    if (_currentHUD) {
        [(CSProgressHUD_MBProgressHUD *)_currentHUD dismmis];
    }
}

@end
