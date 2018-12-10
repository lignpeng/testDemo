//
//  BaseViewController.h
//  CSMBP
//
//  Created by Mr Right on 13-11-20.
//  Copyright (c) 2013年 Forever OpenSource Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (nonatomic ,strong) UIBarButtonItem *customBackBarItem;
/// push过来的话，隐藏TabBar。open票过来要隐藏TabBar。现在这里是写死了几个页面，如果是这几个页面默认会显示TarBar，所以这里先不要写得这么通用了
@property (nonatomic ,assign) BOOL isPush;

// 返回上一页
- (void)goBack;

// 返回首页
- (void)backToHomePage;

//检测到返回上一个页面事件
- (void)navPoptoLastViewControllerAnimated;
//检测到返回首页事件
- (void)navPoptoRootViewControllerAnimated;


@end
