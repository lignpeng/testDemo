//
//  GPVideoViewController.m
//  testDemo
//
//  Created by lignpeng on 17/3/21.
//  Copyright © 2017年 genpeng. All rights reserved.
//

#import "GPVideoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface GPVideoViewController ()<UIGestureRecognizerDelegate>

@property(nonatomic, strong) AVCaptureSession *session;//控制输入和输出设备之间的数据传递
@property(nonatomic, strong) AVCaptureDeviceInput *videoInput;//调用所有的输入硬件。例如摄像头和麦克风
@property(nonatomic, strong) AVCaptureStillImageOutput *imageOutput;//用于输出图像
@property(nonatomic, strong) AVCaptureVideoPreviewLayer *preViewLayer;//镜头捕捉到得预览图层
@property(nonatomic, assign) CGFloat beginGestureScale;//记录开始的缩放比例
@property(nonatomic, assign) CGFloat effectiveScale;//最后的缩放比例

@end

@implementation GPVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initVideoSession];
}

- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect frame = [UIScreen mainScreen].bounds;
    CGFloat margin = 32;
    CGFloat wdith = (CGRectGetWidth(frame) - 2 * margin);
    CGFloat height = 42;
    
    CGRect bframe = CGRectMake(margin, CGRectGetHeight(frame) - height - margin, wdith, height);
    UIButton *showBtn = ({
        UIButton *btn = [[UIButton alloc] initWithFrame:bframe];
        btn.backgroundColor = [UIColor blueColor];
        [btn setTitle:@"show" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(showAction) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.cornerRadius = 5.0;
        btn.clipsToBounds = YES;
        btn;
    });
    [self.view addSubview:showBtn];
    UIPinchGestureRecognizer *pinGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    [self.view addGestureRecognizer:pinGesture];
}

- (void)showAction {
    AVCaptureConnection *imageConnection = [self.imageOutput connectionWithMediaType:AVMediaTypeVideo];
    UIDeviceOrientation curDeviceOriention = [[UIDevice currentDevice] orientation];
    AVCaptureVideoOrientation videoOriention = [self avCaptureVideoOrientationForDeviceOriention:curDeviceOriention];
    [imageConnection setVideoOrientation:videoOriention];
    [imageConnection setVideoScaleAndCropFactor:self.effectiveScale];//控制焦距用的暂时先固定为1
    __weak typeof(self) weakSelf = self;
    [self.imageOutput captureStillImageAsynchronouslyFromConnection:imageConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        
        //保存到相册
        CFDictionaryRef ref = CMCopyDictionaryOfAttachments(kCFAllocatorDefault, imageDataSampleBuffer, kCVAttachmentMode_ShouldPropagate);
        ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
        if (status == ALAuthorizationStatusRestricted || status == ALAuthorizationStatusDenied) {
            NSLog(@"无权限");
        }else {
            ALAssetsLibrary *library = [ALAssetsLibrary new];
            [library writeImageDataToSavedPhotosAlbum:imageData metadata:(__bridge NSDictionary *)(ref) completionBlock:^(NSURL *assetURL, NSError *error) {
                NSLog(@"url = %@",assetURL.absoluteString);
            }];
        }
        
        UIImage *image = [UIImage imageWithData:imageData];
        if (image.imageOrientation == UIImageOrientationDown) {
            NSLog(@"照片反了！！！！");
            image = [weakSelf normalizedImage:image];
        }
        if (image.imageOrientation == UIImageOrientationUp) {
            NSLog(@"照片正常！！");
        }
        
    }];
    
}

- (void)initVideoSession {
    self.effectiveScale = 1.0;
    self.beginGestureScale = 0;
    self.session = [[AVCaptureSession alloc] init];
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //更改这个设置的时候必须先锁定设备，修改完后再解锁，否则崩溃
    [device lockForConfiguration:nil];
    //设置闪光灯为自动
    [device setFlashMode:AVCaptureFlashModeAuto];
    //这句代码是对夜间拍照时候的自动补光, 如果没有这句代码, 晚上拍照基本上是黑色的, 比苹果系统的相机照片差很多
    if ([device isLowLightBoostSupported]) {
        device.automaticallyEnablesLowLightBoostWhenAvailable = YES;
    }
    [device unlockForConfiguration];
    NSError *error;
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
    if (error) {
        NSLog(@"error: %@",error);
        return;
    }
    //输出设置。AVVideoCodecJPEG   输出jpeg格式图片
    self.imageOutput = [AVCaptureStillImageOutput new];
    NSDictionary *outputSettingDict = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    [self.imageOutput setOutputSettings:outputSettingDict];
    
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
    if ([self.session canAddOutput:self.imageOutput]) {
        [self.session addOutput:self.imageOutput];
    }
    
    //初始化预览图层
    self.preViewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [self.preViewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
    CGRect frame = [UIScreen mainScreen].bounds;
    CGFloat height = 72;
    self.preViewLayer.frame = CGRectMake(0, height, CGRectGetWidth(frame), CGRectGetWidth(frame) * 1.2);
    self.preViewLayer.masksToBounds = YES;
    [self.view.layer addSublayer:self.preViewLayer];
}
//接下来搞一个获取设备方向的方法，再配置图片输出的时候需要使用
- (AVCaptureVideoOrientation)avCaptureVideoOrientationForDeviceOriention:(UIDeviceOrientation)deviceOrientation {
    if (deviceOrientation == UIDeviceOrientationLandscapeLeft) {
        return AVCaptureVideoOrientationLandscapeRight;
    }
    return AVCaptureVideoOrientationLandscapeLeft;
}

//这里还有一个问题 就是如果旋转手机后拍照后直接上传到服务器
//服务器收到的图片是反的(上下颠倒) 但是如果是在手机相册查看是正常的 所以这里需要做一下处理
- (UIImage *)normalizedImage:(UIImage *)image {
    if (image.imageOrientation == UIImageOrientationUp) {
        return image;
    }
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    [image drawInRect:(CGRect){0,0,image.size}];
    UIImage *normalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalImage;
}

//注意:session的开启时很消耗CUP的  一直处于开启状态  会导致手机发热  不建议放在viewWillApper方法里面开启和viewDidDisappear里面关闭
//最好是拍照前开启 拍照后关闭
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.session) {
        [self.session startRunning];
    }
}

- (void)viewWillDisappear:(BOOL)animated  {
    if (self.session) {
        [self.session stopRunning];
    }
    [super viewWillDisappear:animated];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]]) {
        self.beginGestureScale = self.effectiveScale;
    }
    return YES;
}

- (void)handlePinchGesture:(UIPinchGestureRecognizer *)pinGesture {
    BOOL isTouchOnPreVideLayer = YES;
    NSUInteger numTouches = [pinGesture numberOfTouches];
    for (int i = 0; i < numTouches; ++i) {
        CGPoint location = [pinGesture locationInView:self.view];
        CGPoint convertLocation = [self.preViewLayer convertPoint:location toLayer:self.preViewLayer.superlayer];
        if (![self.preViewLayer containsPoint:convertLocation]) {
            isTouchOnPreVideLayer = NO;
            break;
        }
    }
    
    if (!isTouchOnPreVideLayer) {
        return;
    }
    self.effectiveScale = self.beginGestureScale * pinGesture.scale;
    self.effectiveScale = self.effectiveScale < 1.0 ? 1.0:self.effectiveScale;
    NSLog(@"%f-------------->%f------------recognizerScale%f",self.effectiveScale,self.beginGestureScale,pinGesture.scale);
    CGFloat maxScaleAndCropFactor = [[self.imageOutput connectionWithMediaType:AVMediaTypeVideo] videoMaxScaleAndCropFactor];
    self.effectiveScale = self.effectiveScale > maxScaleAndCropFactor ? maxScaleAndCropFactor : self.effectiveScale;
    [CATransaction begin];
    [CATransaction setAnimationDuration:.025];
    [self.preViewLayer setAffineTransform:CGAffineTransformMakeScale(self.effectiveScale, self.effectiveScale)];
    [CATransaction commit];
}

@end






















