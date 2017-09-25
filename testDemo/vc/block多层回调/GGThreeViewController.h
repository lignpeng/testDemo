//
//  GGThreeViewController.h
//  testDemo
//
//  Created by lignpeng on 2017/8/30.
//  Copyright © 2017年 genpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGThreeViewController : UIViewController

@property(nonatomic, copy) void (^actionBlock)();

@property(nonatomic, weak) id delegate;

@end
