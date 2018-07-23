//
//  GPTools.m
//  testDemo
//
//  Created by lignpeng on 17/3/24.
//  Copyright © 2017年 genpeng. All rights reserved.
//

#import "GPTools.h"


@implementation GPTools

+ (UIViewController *)getCurrentVC {
    UIViewController *baseVC = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    if (baseVC.presentedViewController) {
        return  [baseVC.presentedViewController isKindOfClass:[UINavigationController class]] ? ((UINavigationController *)baseVC.presentedViewController).topViewController : baseVC.presentedViewController;
    }
    return baseVC;
}

+ (UIViewController *)getCurrentViewController {
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    //app默认windowLevel是UIWindowLevelNormal，如果不是，找到它
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    id nextResponder = nil;
    UIViewController *appRootVC = window.rootViewController;
    //1、通过present弹出VC，appRootVC.presentedViewController不为nil
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
    }else{
        //2、通过navigationcontroller弹出VC
        NSLog(@"subviews == %@",[window subviews]);
        UIView *frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];
    }
    //1、tabBarController
    if ([nextResponder isKindOfClass:[UITabBarController class]]){
        UITabBarController * tabbar = (UITabBarController *)nextResponder;
        UINavigationController * nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        //或者 UINavigationController * nav = tabbar.selectedViewController;
        result = nav.childViewControllers.lastObject;
    }else if ([nextResponder isKindOfClass:[UINavigationController class]]){
        //2、navigationController
        UIViewController * nav = (UIViewController *)nextResponder;
        result = nav.childViewControllers.lastObject;
    }else{//3、viewControler
        result = nextResponder;
    }
    return result;
}


+ (void)ShowAlert:(NSString *)message{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Tips",@"提示") message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertView = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK",@"确定") style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:alertView];
    [[self getCurrentVC] presentViewController:alertVC animated:true completion:nil];
}

+ (void)ShowAlertView:(NSString *)message alertHandler:(AlertViewHandler)handle{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Tips",@"提示") message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel",@"取消") style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK",@"确定") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (handle) {
            handle();
        }
    }];
    [alertVC addAction:action];
    [alertVC addAction:cancelAction];
    [[self getCurrentVC] presentViewController:alertVC animated:true completion:nil];
}

+ (void)ShowAlertViewWithoutCancelAction:(NSString *)title message:(NSString *)message handler:(AlertViewHandler) handle{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK",@"确定") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (handle) {
            handle();
        }
    }];
    [alertVC addAction:action];
    [[self getCurrentVC] presentViewController:alertVC animated:true completion:nil];
}

+ (void)ShowAlertViewWithCustomAction:(NSString *)title message: (NSString *)message cancleActionTitle: (NSString *)cancleActionTitle OKActionTitle: (NSString *)OKActionTitle cancelAction: (AlertViewHandler)cancelAction OKAction:(AlertViewHandler)OKAction{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *OKAc = [UIAlertAction actionWithTitle:OKActionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (OKAction) {
            OKAction();
        }
    }];
    UIAlertAction *cancleAc = [UIAlertAction actionWithTitle:cancleActionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (cancelAction) {
            cancelAction();
        }
    }];
    [alertVC addAction:OKAc];
    [alertVC addAction:cancleAc];
    [[self getCurrentVC] presentViewController:alertVC animated:true completion:nil];
}


+ (void)ShowAlertView:(NSString *)title message:(NSString *)message clickedIndex:(AlertViewClickedIndex) clickedIndex cancelButtonTitle:(NSString *)cancelButtonTitle otherButtons:(NSArray <NSString*>*)otherButtons{    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    if (otherButtons.count > 0) {
        for (int i = 0; i < otherButtons.count; i++) {
            NSString *title = otherButtons[i];
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (clickedIndex) {
                    clickedIndex(i);
                }
            }];
            [alertVC addAction:otherAction];
        }
    }
    if (cancelButtonTitle.length > 0) {
        UIAlertAction *cancleAc = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (clickedIndex) {
                clickedIndex(otherButtons.count);
            }
        }];
        [alertVC addAction:cancleAc];
    }
    [[self getCurrentVC] presentViewController:alertVC animated:YES completion:nil];
}

+ (NSString *)createFileName:(int)length {
    char data[length];
    for (int x=0;x<length;data[x++] = (char)('A' + (arc4random_uniform(26))));
    return [[NSString alloc] initWithBytes:data length:length encoding:NSUTF8StringEncoding];
}

//获取指定区域的图片
+ (UIImage *)clipImageOrignImage:(UIImage *)orignImage WithRect:(CGRect)aRect {
    
    CGImageRef subImageRef = CGImageCreateWithImageInRect(orignImage.CGImage, aRect);
    UIGraphicsBeginImageContext(aRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, aRect, subImageRef);
    UIImage *viewImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();

    return viewImage;
    
}

+ (UIButton *)createButton:(NSString *)title titleFont:(UIFont *)titleFont corner:(CGFloat)radius target:(nullable id)target action:(SEL)selector {
    UIButton *bt = [[UIButton alloc] init];
    [bt setTitle:title forState:UIControlStateNormal];
    bt.backgroundColor = [UIColor clearColor];
        //    bt.titleLabel.textColor = [UIColor colorWithRed:21.0/256.0 green:126.0/256.0 blue:251.0/256.0 alpha:1];
    if (radius > 0) {
        bt.layer.cornerRadius = radius;
        bt.clipsToBounds = YES;
    }
    bt.titleLabel.font = titleFont;
    [bt addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return bt;
}

@end


