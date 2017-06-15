//
//  GPLoginViewController.h
//  testDemo
//
//  Created by lignpeng on 17/3/28.
//  Copyright © 2017年 genpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LoginDelegate <NSObject>

@optional

- (void)loginViewControllerDidSuccessLogin;

@end

@interface GPLoginViewController : UIViewController

@property(nonatomic, assign) id delegate;
@property(nonatomic, strong) NSString *name;

@end
