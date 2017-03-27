//
//  GPGIFViewController.m
//  testDemo
//
//  Created by lignpeng on 17/3/27.
//  Copyright © 2017年 genpeng. All rights reserved.
//

/*
 播放gif格式图片
 两种方式：
 一种：webView
 一种：imageView 
 
 */

#import "GPGIFViewController.h"
#import <ImageIO/ImageIO.h>

@interface GPGIFViewController ()

@property(nonatomic, strong) UIWebView *webView;

@end

@implementation GPGIFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect frame = [UIScreen mainScreen].bounds;
    CGFloat margin = 32;
    CGFloat topMargin = 64;
    CGFloat wdith = (CGRectGetWidth(frame) - 2 * margin);
    CGFloat height = 42;
    CGRect lframe = (CGRect){margin,topMargin,wdith,margin};
    UILabel *webLabel =({
        UILabel *label = [UILabel new];
        label.frame = lframe;
        label.text = @"UIWebView 加载gif：";
        label.font = [UIFont systemFontOfSize:14.0];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.backgroundColor = [UIColor clearColor];
        label;
    });
    [self.view addSubview:webLabel];
    
    CGRect wframe = (CGRect){0,CGRectGetMinY(lframe) + CGRectGetHeight(lframe),CGRectGetWidth(frame),topMargin * 2};
    self.webView = [[UIWebView alloc] initWithFrame:wframe];
    self.webView.scrollView.bounces = NO;
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.scalesPageToFit = YES;
    [self.view addSubview:self.webView];
    UILabel *imageLabel = ({
        UILabel *label = [UILabel new];
        label.frame = (CGRect){margin,CGRectGetHeight(wframe) + CGRectGetMinY(wframe) + margin * 0.5,wdith,margin};
        label.text = @"UIImageView 加载gif：";
        label.font = [UIFont systemFontOfSize:14.0];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.tag = 1;
        label;
    });
    [self.view addSubview:imageLabel];
    
    UIImageView *imageView = [UIImageView new];
    imageView.tag = 10;
    [self.view addSubview:imageView];
    
    CGRect bframe = CGRectMake(margin, CGRectGetHeight(frame) - margin - height, wdith, height);
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
}

- (void)showAction {
//    NSString *gitPath = [[NSBundle mainBundle] pathForResource:@"33" ofType:@"gif"];
    
//    NSString *gitPath = [[NSBundle mainBundle] pathForResource:@"33" ofType:@"gif" inDirectory:@"gif"];
    NSArray *gitPathArray = [[NSBundle mainBundle] pathsForResourcesOfType:@"gif" inDirectory:@"gif"];
    if (gitPathArray.count <= 0) {
        return;
    }
    NSString *gitPath = gitPathArray[arc4random()%gitPathArray.count];
    UIImage *image = [UIImage imageWithContentsOfFile:gitPath];
    CGRect wframe = (CGRect){(CGRectGetWidth([UIScreen mainScreen].bounds) - image.size.width) * 0.5,CGRectGetMinY(self.webView.frame),image.size};
    CGFloat margin = 16;
    self.webView.frame = wframe;
    NSData *gifData = [NSData dataWithContentsOfFile:gitPath];
    [self.webView loadData:gifData MIMEType:@"image/gif" textEncodingName:@"" baseURL:[NSURL URLWithString:gitPath]];
    
    UILabel *label = (UILabel *)[self.view viewWithTag:1];
    CGRect lfame = (CGRect){CGRectGetMinX(label.frame), CGRectGetMinY(wframe) + CGRectGetHeight(wframe) + margin,label.frame.size};
    label.frame = lfame;
    
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:10];
    imageView.frame = (CGRect){CGRectGetMinX(wframe),CGRectGetMinY(lfame) + CGRectGetHeight(lfame) + margin * 0.5 ,image.size};
    imageView.image = [[self class] animatedGIFWithData:gifData];
}

+ (UIImage *)animatedGIFWithData:(NSData *)data {
    if (!data) {
        return nil;
    }
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    NSUInteger count = CGImageSourceGetCount(source);
    if (count <= 1) {
        return [[UIImage alloc] initWithData:data];
    }
    
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        CGImageRef cgImageRef = CGImageSourceCreateImageAtIndex(source, i, NULL);
        UIImage *image = [UIImage imageWithCGImage:cgImageRef scale:1 orientation:UIImageOrientationUp];
        [images addObject:image];
        CGImageRelease(cgImageRef);
    }
    
    UIImage *gitImage = [UIImage animatedImageWithImages:images duration:0.1f * count];
    CFRelease(source);
    return gitImage;
}

@end


























