//
//  UIClipImageViewController.m
//  testDemo
//
//  Created by lignpeng on 2018/8/29.
//  Copyright © 2018年 genpeng. All rights reserved.
//

#import "UIClipImageViewController.h"
#import "GPTools.h"
#import "HexColor.h"
#import "UIImageViewController.h"
#import "GPTools.h"
#import "JPImageresizerView.h"

@interface UIClipImageViewController ()
@property(nonatomic, strong) UIImage *image;
//@property(nonatomic, strong) NSDictionary *buttonsArray;
@property(nonatomic, strong) JPImageresizerConfigure *configure;
@property(nonatomic, strong) NSArray *buttonTitles;
@property(nonatomic, strong) NSArray *buttonActions;
@property(nonatomic, strong) UIButton *recoveryBtn;//重置
@property(nonatomic, strong) UIButton *goBackBtn;//返回
@property(nonatomic, strong) UIButton *resizeBtn;//裁剪
@property(nonatomic, strong) UIButton *horMirrorBtn;//水平镜像
@property(nonatomic, strong) UIButton *verMirrorBtn;//垂直镜像
@property(nonatomic, strong) UIButton *rotateBtn;//旋转
@property(nonatomic, weak) JPImageresizerView *imageresizerView;
@property(nonatomic, copy) void (^complishBlock)(UIImage *image);

@end

@implementation UIClipImageViewController

+ (void)clipImage:(UIImage *)image complishBlock:(void(^)(UIImage *image))complishBlock {
    if (!image) {
        return;
    }
    UIClipImageViewController *vc = [UIClipImageViewController new];
    vc.image = image;
    vc.complishBlock = complishBlock;
    [[GPTools getCurrentViewController] presentViewController:vc animated:YES completion:nil];
    return ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
   
    self.recoveryBtn.enabled = NO;
    
    __weak typeof(self) wSelf = self;
    JPImageresizerView *imageresizerView = [JPImageresizerView imageresizerViewWithConfigure:self.configure imageresizerIsCanRecovery:^(BOOL isCanRecovery) {
        __strong typeof(wSelf) sSelf = wSelf;
        if (!sSelf) return;
            // 当不需要重置设置按钮不可点
        sSelf.recoveryBtn.enabled = isCanRecovery;
    } imageresizerIsPrepareToScale:^(BOOL isPrepareToScale) {
        __strong typeof(wSelf) sSelf = wSelf;
        if (!sSelf) return;
            // 当预备缩放设置按钮不可点，结束后可点击
        BOOL enabled = !isPrepareToScale;
        sSelf.rotateBtn.enabled = enabled;
        sSelf.resizeBtn.enabled = enabled;
        sSelf.horMirrorBtn.enabled = enabled;
        sSelf.verMirrorBtn.enabled = enabled;
    }];
    [self.view insertSubview:imageresizerView atIndex:0];
    self.imageresizerView = imageresizerView;
    self.configure = nil;
}

- (void)initData {
//    NSString *imageStr = [[NSBundle mainBundle] pathForResource:@"0021" ofType:@"jpg"];
//    UIImage *image = [UIImage imageWithContentsOfFile:imageStr];
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(50, 0, (40 + 30 + 30 + 10), 0);
    self.configure = [JPImageresizerConfigure defaultConfigureWithResizeImage:self.image make:^(JPImageresizerConfigure *configure) {
        configure.jp_contentInsets(contentInsets);
    }];
    self.buttonTitles = @[@"返回",@"水平镜像",@"垂直镜像",@"锁定",
                          @"更换样式",@"旋转",@"重置",@"预览",
                          @"任意比例",@"1：1",@"16：9",@"确定"];
    self.buttonActions = @[@"goBack:",@"horMirror:",@"verMirror:",@"lockFrame:",
                           @"changeFrameType:",@"rotate:",@"recovery:",@"resize:",
                           @"anyScale:",@"one2one:",@"sixteen2nine:",@"okImage:"];
}

- (void)initView {
    self.view.backgroundColor = [UIColor blackColor];
    UIView *topBar = [UIView new];
    topBar.backgroundColor = [UIColor clearColor];
    CGFloat margin = 42;
    NSInteger num = 4;
    CGFloat gap = 1;
    CGRect sframe = [UIScreen mainScreen].bounds;
    CGFloat widht = CGRectGetWidth(sframe);
    CGFloat height = CGRectGetHeight(sframe);
    CGRect tframe = (CGRect){0,0,widht,margin};
    topBar.frame = tframe;
    [self.view addSubview:topBar];
    
    CGFloat bWidth = (widht- 3*gap) / num;
    CGRect bframe = (CGRect){0,0,bWidth,margin};
    for (int i = 0; i < num; i++) {
        NSString *title = self.buttonTitles[i];
        SEL func = NSSelectorFromString(self.buttonActions[i]);
        UIButton *bt = [GPTools colorButton:title titleFont:nil isColor:NO corner:0 target:self action:func];
        bt.backgroundColor = [UIColor colorWith8BitRedN:41 green:45 blue:51];
        bframe.origin.x = i * (bWidth+gap);
        bt.frame = bframe;
        [topBar addSubview:bt];
        
        if ([title isEqualToString:@"返回"]) {
            self.goBackBtn = bt;
        }else if ([title isEqualToString:@"水平镜像"]){
            self.verMirrorBtn = bt;
        }else if ([title isEqualToString:@"垂直镜像"]){
            self.horMirrorBtn = bt;
        }
    }
    
    UIView *bottomBar = [UIView new];
    bottomBar.frame = (CGRect){0,height - margin * 2 + gap,widht,margin*2 + gap};
    bottomBar.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bottomBar];
    
    bframe = (CGRect){0,0,bWidth,margin};
    for (int i = 0; i < self.buttonTitles.count - num; i++) {
        NSString *title = self.buttonTitles[i+num];
        SEL func = NSSelectorFromString(self.buttonActions[i+num]);
        UIButton *bt = [GPTools colorButton:title titleFont:nil isColor:NO corner:0 target:self action:func];
        bt.backgroundColor = [UIColor colorWith8BitRedN:41 green:45 blue:51];
        bframe.origin.x = i%num * (bWidth + gap);
        bframe.origin.y = i/num * (margin + gap);
        bt.frame = bframe;
        [bottomBar addSubview:bt];
        if ([title isEqualToString:@"旋转"]) {
            self.rotateBtn = bt;
        }else if ([title isEqualToString:@"重置"]){
            self.recoveryBtn = bt;
        }else if ([title isEqualToString:@"预览"]){
            self.resizeBtn = bt;
        }
    }
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

//更换样式
- ( void)changeFrameType:(UIButton *)sender {
    sender.selected = !sender.selected;
    JPImageresizerFrameType frameType;
    if (sender.selected) {
        frameType = JPClassicFrameType;
    } else {
        frameType = JPConciseFrameType;
    }
    self.imageresizerView.frameType = frameType;
}

//旋转
- ( void)rotate:(id)sender {
    [self.imageresizerView rotation];
}

//重置
- ( void)recovery:(id)sender {
    [self.imageresizerView recovery];
}

//任意比例
- ( void)anyScale:(id)sender {
    self.imageresizerView.resizeWHScale = 0;
}

//1：1
- ( void)one2one:(id)sender {
    self.imageresizerView.resizeWHScale = 1;
}

//16：9
- ( void)sixteen2nine:(id)sender {
    self.imageresizerView.resizeWHScale = 16.0 / 9.0;
}

//确定
- ( void)okImage:(UIButton *)sender {
    self.recoveryBtn.enabled = NO;
    __weak typeof(self) weakSelf = self;
    [self.imageresizerView imageresizerWithComplete:^(UIImage *resizeImage) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        if (!resizeImage) {
            NSLog(@"没有裁剪图片");
            [GPTools ShowInfoTitle:@"提醒" message:@"没有裁剪图片" delayTime:0.2];
            return;
        }
        strongSelf.complishBlock(resizeImage);
        [strongSelf goBack:nil];
    } isOriginImageSize:YES];
}

//更换图片
- ( void)replaceImage:(UIButton *)sender {
    return;
    sender.selected = !sender.selected;
    UIImage *image;
    if (sender.selected) {
        image = [UIImage imageNamed:@"Kobe.jpg"];
    } else {
        image = [UIImage imageNamed:@"Girl.jpg"];
    }
    self.imageresizerView.resizeImage = image;
}

//预览
- ( void)resize:(id)sender {
    self.recoveryBtn.enabled = NO;
    __weak typeof(self) weakSelf = self;
    [self.imageresizerView imageresizerWithComplete:^(UIImage *resizeImage) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        
        if (!resizeImage) {
            NSLog(@"没有裁剪图片");
            [GPTools ShowInfoTitle:@"提醒" message:@"没有裁剪图片" delayTime:0.2];
            return;
        }
        
        UIImageViewController *vc = [UIImageViewController new];
        vc.image = resizeImage;
        if (self.navigationController) {
            [strongSelf.navigationController pushViewController:vc animated:YES];
        }else {
//            return;
            [self presentViewController:vc animated:YES completion:nil];
        }
        
        strongSelf.recoveryBtn.enabled = YES;
        
    } isOriginImageSize:YES];
}

//返回
- ( void)goBack:(id)sender {
//    for (UIButton *btn in self.processBtns) {
//        btn.hidden = NO;
//    }
//    self.imageresizerView.hidden = NO;
//
//    self.imageView.image = nil;
//    self.imageView.hidden = YES;
//    self.goBackBtn.hidden = YES;
//
//    self.recoveryBtn.enabled = YES;
//    [self.imageresizerView recovery];
    [self pop:nil];
}

- ( void)pop:(id)sender {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

//锁定
- ( void)lockFrame:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.imageresizerView.isLockResizeFrame = sender.selected;
}

//垂直镜像
- ( void)verMirror:(id)sender {
    [self.imageresizerView setVerticalityMirror:!self.imageresizerView.verticalityMirror animated:YES];
}

//水平镜像
- ( void)horMirror:(id)sender {
    [self.imageresizerView setHorizontalMirror:!self.imageresizerView.horizontalMirror animated:YES];
}

@end

