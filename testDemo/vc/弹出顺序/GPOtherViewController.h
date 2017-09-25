//
//  GPOtherViewController.h
//  testDemo
//
//  Created by lignpeng on 17/3/29.
//  Copyright © 2017年 genpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GPCallBackBlock)();

@interface GPOtherViewController : UIViewController

@property(nonatomic, copy) GPCallBackBlock callBackBlock;

@end
