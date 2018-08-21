//
//  CSProgressHUDProtocol.h
//  CSMBP
//
//  Created by Sencho Kong on 15/11/18.
//  Copyright © 2015年 Forever OpenSource Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CancelCallBackBlock)(id);

@protocol CSProgressHUDProtocol <NSObject>

@property (nonatomic ,copy)  CancelCallBackBlock didClickCancelButtonBlock;

+ (void)show;

+ (void)showWithMessage:(NSString *)message cancelCallBackBlock:(CancelCallBackBlock)block;

+ (void)showWithImageName:(NSString *)imageName cancelCallBackBlock:(CancelCallBackBlock)block;

+ (void)dismiss;

@end
