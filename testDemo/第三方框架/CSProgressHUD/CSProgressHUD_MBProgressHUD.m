//
//  CSProgressHUD_MBProgressHUD.m
//  CSMBP
//
//  Created by Sencho Kong on 15/11/18.
//  Copyright © 2015年 Forever OpenSource Software Inc. All rights reserved.
//

#import "CSProgressHUD_MBProgressHUD.h"
#import "MBProgressHUD.h"
#import "CSProgressCustomView.h"

@interface CSProgressHUD_MBProgressHUD ()<MBProgressHUDDelegate>

@property (nonatomic ,strong) MBProgressHUD *hud;

@property(nonatomic, strong) UIView *backView;

@property(nonatomic, assign) float viewAlpha;

@end

@implementation CSProgressHUD_MBProgressHUD

- (float)viewAlpha {
    return 0.65;
}

- (void)show{
    [self showWithMessage:nil cancelCallBackBlock:nil];
}

- (void)showWithMessage:(NSString *)message cancelCallBackBlock:(CancelCallBackBlock)block {
    [self showWithMessage:message imagaName:@"new_loading" cancelCallBackBlock:block];
}

- (UIView *)createCustomViewWithImageName:(NSString *)imageName {
    CSProgressCustomView *customView = [[CSProgressCustomView alloc] initWithFrame:CGRectMake(0, 0, 90, 90) WithImageName:imageName];
//    customView.layer.borderWidth = 1.0;
//    customView.layer.borderColor = [UIColor blackColor].CGColor;
//    customView.layer.cornerRadius = 6.0;
//    customView.clipsToBounds = YES;
    [customView startAnimating];
    return customView;
}



- (void)showWithMessage:(NSString *)message imagaName:(NSString *)imageName cancelCallBackBlock:(CancelCallBackBlock)block{
    
    BOOL isNew = YES;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if (isNew) {
        self.backView = [UIView new];
        self.backView.frame = [UIScreen mainScreen].bounds;
        self.backView.backgroundColor = [UIColor blackColor];
        self.backView.alpha = self.viewAlpha;
        [keyWindow addSubview:self.backView];
    }
    
    [MBProgressHUD hideAllHUDsForView:keyWindow animated:NO];
    
    self.hud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
//    self.hud.alpha=0.8;
    self.hud.delegate = self;
    self.hud.labelText = message;
    self.hud.labelColor = [UIColor darkTextColor];
    self.hud.customView = [self createCustomViewWithImageName:imageName];
    self.hud.mode = MBProgressHUDModeCustomView;
    self.hud.margin = 10;
    self.hud.color = [UIColor clearColor];
   
//    if (isNew) {
//        return;
//    }
    
    if (block) {
        self.didClickCancelButtonBlock = block;
        CGPoint centerOfHUD = self.hud.center;
        __block UIButton *click=[UIButton buttonWithType:UIButtonTypeCustom];
        CALayer *layer=[click layer];
        //是否设置边框以及是否可见
        [layer setMasksToBounds:YES];
        //设置边框圆角的弧度
        [layer setCornerRadius:6.0];
        
        [click setBackgroundImage: [UIImage imageNamed:@"btn_login_cancel"] forState:UIControlStateNormal];
        [click setFrame:CGRectMake(0, 0,30, 30)];
        [click setCenter:CGPointMake(centerOfHUD.x+80, centerOfHUD.y-45)];
        [click setBackgroundColor:[UIColor clearColor]];
        [click addTarget:self action:@selector(didClickCancleButton:) forControlEvents:UIControlEventTouchUpInside];
        [click.titleLabel setFont:[UIFont fontWithName:@"helvetica" size:16]];
        
        [self.hud addSubview:click];
        self.hud.layoutSubviewsCallBack = ^(CGSize size){
            [click setCenter:CGPointMake(centerOfHUD.x + size.width/2 , centerOfHUD.y - size.height/2 )];
        };
    }
   
}

- (void)showWithImageName:(NSString *)imageName cancelCallBackBlock:(CancelCallBackBlock)block {
    BOOL isNew = YES;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if (isNew) {
        self.backView = [UIView new];
        self.backView.frame = [UIScreen mainScreen].bounds;
        self.backView.backgroundColor = [UIColor blackColor];
        self.backView.alpha = self.viewAlpha;
        [keyWindow addSubview:self.backView];
    }
    
    [MBProgressHUD hideAllHUDsForView:keyWindow animated:NO];
    
    self.hud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
    self.hud.alpha=1.0;
    self.hud.delegate = self;
    self.hud.customView = [self createCustomViewWithImageName:imageName];
    self.hud.mode = MBProgressHUDModeCustomView;
    self.hud.margin = 10;
    self.hud.color = [UIColor clearColor];
//    if (isNew) {
//        return;
//    }
    if (block) {
        self.didClickCancelButtonBlock = block;
        CGPoint centerOfHUD = self.hud.center;
        __block UIButton *click=[UIButton buttonWithType:UIButtonTypeCustom];
        CALayer *layer=[click layer];
        //是否设置边框以及是否可见
        [layer setMasksToBounds:YES];
        //设置边框圆角的弧度
        [layer setCornerRadius:6.0];
        
        [click setBackgroundImage: [UIImage imageNamed:@"btn_login_cancel"] forState:UIControlStateNormal];
        CGFloat common = 30.0;
        [click setFrame:CGRectMake(0, 0, common, common)];
        CGRect iframe = self.hud.bounds;
        CGPoint icenter = self.hud.customView.center;
        icenter.x += (CGRectGetWidth(iframe) - common)/2;
        icenter.y -= (CGRectGetHeight(iframe) - common)/2;
        [click setCenter:icenter];
        [click setBackgroundColor:[UIColor clearColor]];
        [click addTarget:self action:@selector(didClickCancleButton:) forControlEvents:UIControlEventTouchUpInside];
        [click.titleLabel setFont:[UIFont fontWithName:@"helvetica" size:16]];
        
        [self.hud addSubview:click];
        self.hud.layoutSubviewsCallBack = ^(CGSize size){
            [click setCenter:CGPointMake(centerOfHUD.x + size.width/2 , centerOfHUD.y - size.height/2 )];
        };
    }
}


- (void)didClickCancleButton:(UIButton *)sender{
    if (_didClickCancelButtonBlock) {
        _didClickCancelButtonBlock(sender);
    }
}


- (void)dismmis{
    [self.backView removeFromSuperview];
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:NO];
}


#pragma mark- MBProgressHUD Delegate

- (void)hudWasHidden:(MBProgressHUD *)hud{
   

}

@end
