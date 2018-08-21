//
//  CSProgressHUD_MBProgressHUD.h
//  CSMBP
//
//  Created by Sencho Kong on 15/11/18.
//  Copyright © 2015年 Forever OpenSource Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSProgressHUDProtocol.h"


@interface CSProgressHUD_MBProgressHUD : NSObject

@property (nonatomic ,copy)  CancelCallBackBlock didClickCancelButtonBlock;

- (void)show;

- (void)showWithMessage:(NSString *)message cancelCallBackBlock:(CancelCallBackBlock)block;

- (void)showWithImageName:(NSString *)imageName cancelCallBackBlock:(CancelCallBackBlock)block;

- (void)dismmis;

@end
