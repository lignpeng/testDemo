//
//  SinaWBSendingViewController.h
//  CSMBP
//
//  Created by 寒山凤鸣 on 12-10-10.
//  Copyright (c) 2012年 Forever OpenSource Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
//#import "NewCSMBP_Header.h"
#import "BaseViewController.h"


@interface SinaWBSendingViewController : BaseViewController

@property (nonatomic, retain) UIImage *contentImage; //图片
@property (nonatomic, retain) NSString *contentText; //分享内容
@property (nonatomic, copy) void(^DidShareCallback)(BOOL isSuccessed);//分享回调
@property (assign) BOOL shareBySeeting;
@property (assign) BOOL noAnimation;
@property (nonatomic,strong) NSString *itemTitle;

@property(nonatomic, strong) UIViewController *parentVC;

@end
