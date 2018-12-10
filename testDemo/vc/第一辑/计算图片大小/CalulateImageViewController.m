//
//  CalulateImageViewController.m
//  testDemo
//
//  Created by lignpeng on 2017/7/21.
//  Copyright © 2017年 genpeng. All rights reserved.
//

#import "CalulateImageViewController.h"

@interface CalulateImageViewController ()

@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UILabel *infoLabel;

@end

@implementation CalulateImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSString *imageStr = [[NSBundle mainBundle] pathForResource:@"0021" ofType:@"jpg"];
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:imageStr]];
    CGRect frame = [UIScreen mainScreen].bounds;
    CGFloat imageWith = 120;
    CGFloat imageHeight = 180;
    CGRect iframe = CGRectMake((CGRectGetWidth(frame) - imageWith) /2,72 , imageWith, imageHeight);
    self.imageView.frame = iframe;
    [self.view addSubview:self.imageView];
    
    self.infoLabel = ({
        UILabel *label = [UILabel new];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:14.0];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentLeft;
        label;
    });
    
    CGFloat margin = 32;
    CGFloat height = 42;
    CGRect lframe = CGRectMake(margin,CGRectGetHeight(iframe) + CGRectGetMinY(iframe) , CGRectGetWidth(frame) - 2 * margin, CGRectGetHeight(frame) - CGRectGetHeight(iframe) - CGRectGetMinY(iframe) - margin - height);
    self.infoLabel.frame = lframe;
    [self.view addSubview:self.infoLabel];
    
    CGFloat wdith = (CGRectGetWidth(frame) - 2 * margin);
    CGRect bframe = CGRectMake(margin, CGRectGetHeight(lframe) + CGRectGetMinY(lframe) + margin * 0.5, wdith, height);
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
    NSString *infoString = @"image 原大小：\n";
    NSString *imageStr = [[NSBundle mainBundle] pathForResource:@"0021" ofType:@"jpg"];
    NSData *data = [NSData dataWithContentsOfFile:imageStr];
    infoString = [infoString stringByAppendingString:[self data:data value:0]];
    infoString = [infoString stringByAppendingString:@"\n"];
    float value = 1.0;
    while (value > 0.01) {
        infoString = [infoString stringByAppendingString:[self value:value]];
        value -= 0.05;
    }
    
    self.infoLabel.text = infoString;
}

- (NSString *)value:(float)value {
    NSData *data = UIImageJPEGRepresentation(self.imageView.image, value);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    docDir = [docDir stringByAppendingString:[NSString stringWithFormat:@"/0021.%.3f.jpg",value]];
    NSLog(@"path = %@",docDir);
    [data writeToFile:docDir atomically:YES];
    return [self data:data value:value];
}

- (NSString *)data:(NSData *)data value:(float)value {
    double dataLength = [data length] * 1.0;
    double orgrionLenght = dataLength;
    NSArray *typeArray = @[@"bytes",@"KB",@"MB",@"GB",@"TB",@"PB", @"EB",@"ZB",@"YB"];
    NSInteger index = 0;
    while (dataLength > 1024) {
        dataLength /= 1024.0;
        index ++;
    }
    NSString *str = [NSString stringWithFormat:@"%.3f，%.1f字节，%.3f%@\n",value,orgrionLenght,dataLength,typeArray[index]];
    return str;
}

@end
