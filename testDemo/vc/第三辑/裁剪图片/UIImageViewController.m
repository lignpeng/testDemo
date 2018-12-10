//
//  UIImageViewController.m
//  testDemo
//
//  Created by lignpeng on 2018/8/29.
//  Copyright © 2018年 genpeng. All rights reserved.
//

#import "UIImageViewController.h"
#import "GPTools.h"

@interface UIImageViewController ()

@end

@implementation UIImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:imageView];
    imageView.image = self.image;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (void)initView {
    UIButton *button = [GPTools createButton:@"确定" titleFont:nil corner:0 target:self action:@selector(okAction)];
    [self.view addSubview:button];
    
    CGRect vframe = self.view.bounds;
    CGFloat height = 48;
    CGFloat width = 80;
    button.frame = (CGRect){CGRectGetWidth(vframe)-width,CGRectGetHeight(vframe)-height,width,height};
    
    UIButton *saveButton = [GPTools createButton:@"保存到相册" titleFont:nil corner:0 target:self action:@selector(saveAction)];
    [self.view addSubview:saveButton];
    saveButton.frame = (CGRect){0,CGRectGetHeight(vframe)-height,width,height};
}

- (void)okAction {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }    
}

- (void)saveAction {
        //保存到相册
    UIImageWriteToSavedPhotosAlbum(self.image, self,@selector(image:didFinishSavingWithError:contextInfo:), nil);
}

-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = nil;
    if(error){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    [GPTools ShowInfoTitle:nil message:msg delayTime:0.2];
}

@end
