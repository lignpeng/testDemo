//
//  LoadingViewController.m
//  testDemo
//
//  Created by lignpeng on 16/12/5.
//  Copyright © 2016年 genpeng. All rights reserved.
//

#import "LoadingViewController.h"

//#import "CSProgressHUD.h"

@interface LoadingViewController ()

@property(nonatomic, strong) UIImageView *imageView;

@property(nonatomic, strong) UISlider *slider;

@end

@implementation LoadingViewController

- (UIImageView *)imageView {
    if (_imageView) {
        return _imageView;
    }
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"new_loading"]];
    return _imageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initView];
    
}

- (void)initView {
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Stop" style:UIBarButtonItemStylePlain target:self action:@selector(stopAction)];
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect frame = [UIScreen mainScreen].bounds;
    CGFloat margin = 10;
    CGFloat wdith = (CGRectGetWidth(frame) - 4 * margin)/3;
    CGFloat height = 42;
    CGRect rect = [[UIApplication sharedApplication] statusBarFrame];
    CGRect bframe = CGRectMake(margin, margin + CGRectGetHeight(rect) + CGRectGetHeight(self.navigationController.navigationBar.frame), wdith, height);
//    UIButton *showBtn = ({
//        UIButton *btn = [[UIButton alloc] initWithFrame:bframe];
//        btn.backgroundColor = [UIColor blueColor];
//        [btn setTitle:@"show" forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [btn addTarget:self action:@selector(showAction) forControlEvents:UIControlEventTouchUpInside];
//        btn.layer.cornerRadius = 5.0;
//        btn.clipsToBounds = YES;
//        btn;
//    });
//    [self.view addSubview:showBtn];
//
//    bframe.origin.x += (CGRectGetWidth(bframe) + margin);
//    UIButton *showMessageBtn = ({
//        UIButton *btn = [[UIButton alloc] initWithFrame:bframe];
//        [self.view addSubview:btn];
//        btn.backgroundColor = [UIColor blueColor];
//        [btn setTitle:@"message" forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [btn addTarget:self action:@selector(showMessageAction) forControlEvents:UIControlEventTouchUpInside];
//        btn.layer.cornerRadius = 5.0;
//        btn.clipsToBounds = YES;
//        btn;
//    });
//    [self.view addSubview:showMessageBtn];
//
//    bframe.origin.x += (CGRectGetWidth(bframe) + margin);
//    UIButton *showImageBtn = ({
//        UIButton *btn = [[UIButton alloc] initWithFrame:bframe];
//        [self.view addSubview:btn];
//        btn.backgroundColor = [UIColor blueColor];
//        [btn setTitle:@"image" forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [btn addTarget:self action:@selector(showImageAction) forControlEvents:UIControlEventTouchUpInside];
//        btn.layer.cornerRadius = 5.0;
//        btn.clipsToBounds = YES;
//        btn;
//    });
//    [self.view addSubview:showImageBtn];
//
//    bframe.origin.y += (CGRectGetHeight(bframe) + margin);
//    bframe.size.width = 200;
//    bframe.size.height = 20;
//    self.slider = ({
//
//        UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
//        slider.minimumValue = 0;
//        slider.maximumValue = 100;
//        slider.value = 50;
//        [slider addTarget:self action:@selector(updateValue:) forControlEvents:UIControlEventValueChanged];
//        slider;
//    });
//
//    [self.view addSubview:self.slider];
}

- (void)updateValue:(UISlider *)slider {
    float value = slider.value;
    NSLog(@"value: %f",value);
}
//- (void)action {
//    [CSProgressHUD showWithImageName:@"new_loading" cancelCallBackBlock:^(id reason) {
//        [CSProgressHUD dismiss];
//    }];
//}
//
//- (void)showAction {
//    [CSProgressHUD show];
//    [self performSelector:@selector(stopAction) withObject:self afterDelay:5];
//}
//
//- (void)showMessageAction {
//    [CSProgressHUD showWithMessage:@"ok" cancelCallBackBlock:^(id button) {
//        [CSProgressHUD dismiss];
//    }];
//}
//
//- (void)showImageAction {
//    [CSProgressHUD showWithImageName:@"new_loading" cancelCallBackBlock:^(id reason) {
//        [CSProgressHUD dismiss];
//    }];
//}
//
//- (void)stopAction {
////    [self.imageView.layer removeAllAnimations];
//    [CSProgressHUD dismiss];
//}

+ (UIImageView *)rotate360DegreeWithImageView:(UIImageView *)imageView{
    CABasicAnimation *animation = [ CABasicAnimation
                                   animationWithKeyPath: @"transform" ];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    
    //围绕Z轴旋转，垂直与屏幕
    animation.toValue = [ NSValue valueWithCATransform3D:
                         
                         CATransform3DMakeRotation(M_PI, 0.0, 0.0, 1.0) ];
    animation.duration = 0.5;
    //旋转效果累计，先转180度，接着再旋转180度，从而实现360旋转
    animation.cumulative = YES;
    animation.repeatCount = INT_MAX;
    
    //在图片边缘添加一个像素的透明区域，去图片锯齿
    CGRect imageRrect = CGRectMake(0, 0,imageView.frame.size.width, imageView.frame.size.height);
    UIGraphicsBeginImageContext(imageRrect.size);
    [imageView.image drawInRect:CGRectMake(1,1,imageView.frame.size.width-2,imageView.frame.size.height-2)];
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [imageView.layer addAnimation:animation forKey:nil];
    return imageView;
}


@end
