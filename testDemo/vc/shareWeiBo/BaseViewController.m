//
//  BaseViewController.m
//  CSMBP
//
//  Created by Mr Right on 13-11-20.
//  Copyright (c) 2013年 Forever OpenSource Software Inc. All rights reserved.
//
#define NAVIGATIONBARBGHEIGHT 64

#import "BaseViewController.h"
//#import "RDVTabBarController.h"
//#import "CSMBPAppDelegate.h"
//#import "UIColor+CICAdditions.h"
//#import "UINavigationBar+BackgroundColor.h"
//#import "BaseUits.h"

#define UIColorFromRGB(rgbValue)[UIColor colorWithRed:((float)((rgbValue&0xFF0000)>>16))/255.0 green:((float)((rgbValue&0xFF00)>>8))/255.0 blue:((float)(rgbValue&0xFF))/255.0 alpha:1.0]

@interface BaseViewController ()

@end

@implementation BaseViewController

#pragma mark - view cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
        self.navigationController.navigationBar.translucent = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
        self.navigationController.navigationBar.translucent = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem= self.customBackBarItem;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   

//    if (![CSMBPAppDelegate isNewApp]) {
//        
//        
//        if([self isKindOfClass:NSClassFromString(@"HomeViewController")]
//           ||[self isKindOfClass:NSClassFromString(@"MyInfoViewController")]
//           ||[self isKindOfClass:NSClassFromString(@"BaseUINavigationController")]
//           ||[self isKindOfClass:NSClassFromString(@"CSMoreViewController")]
//           ||[self isKindOfClass:NSClassFromString(@"FlightStatusMainVC")]
//           ||[self isKindOfClass:NSClassFromString(@"MyAttationListVC")]){
//            
//            if (self.isPush) {
//                [self.rdv_tabBarController setTabBarHidden:YES animated:NO];
//            } else {
//                [self.rdv_tabBarController setTabBarHidden:NO animated:NO];
//            }
//        }else{
//            [self.rdv_tabBarController setTabBarHidden:YES animated:NO];
//        }
//    }
//#endif
}

-(void)viewWillDisappear:(BOOL)animated
{
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    [super viewWillDisappear:animated];
}

- (void)goBack{
    
    [self navPoptoLastViewControllerAnimated];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (UIBarButtonItem *)customBackBarItem{
//    if (!_customBackBarItem) {
//
//
//        if ([CSMBPAppDelegate isNewApp]) {
//            _customBackBarItem = getCustomNavImageButton(@"icon_left_arrow", nil, self, @selector(goBack));
//        
//        } else {
//            _customBackBarItem = getCustomNavImageButton(@"nav_leftbtn_nor", nil, self, @selector(goBack));
//        }
//
//    }
//    return _customBackBarItem;
    return [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
}



- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)backToHomePage{
    
//    CSMBPAppDelegate *appDelegate = (CSMBPAppDelegate *)[UIApplication sharedApplication].delegate;
//    UIViewController *rootViewController = appDelegate.window.rootViewController;
//    
//    if ([rootViewController isKindOfClass:[RDVTabBarController class]]) {
//        RDVTabBarController *vc = (RDVTabBarController *)rootViewController;
//        [vc setSelectedIndex:0];
//        [self navPoptoRootViewControllerAnimated];
//        for (UINavigationController *nav in self.rdv_tabBarController.viewControllers) {
//            [nav popToRootViewControllerAnimated:NO];
//        }
//    } else {
//        [self navPoptoRootViewControllerAnimated];
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }
    
}

#pragma mark - helper methods

//检测到返回上一个页面事件
- (void)navPoptoLastViewControllerAnimated{
    
}

//检测到返回首页事件
- (void)navPoptoRootViewControllerAnimated{
    
    
}

@end
