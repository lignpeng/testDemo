//
//  UIShapeImageClipViewController.m
//  testDemo
//
//  Created by lignpeng on 2018/12/10.
//  Copyright © 2018年 genpeng. All rights reserved.
//

#import "UIShapeImageClipViewController.h"
#import "UICircleShapeView.h"

@interface UIShapeImageClipViewController ()

@property(nonatomic, strong) UICircleShapeView *circleView;

@end

@implementation UIShapeImageClipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.circleView];
    
}

- (UICircleShapeView *)circleView {
    if (!_circleView){
        NSString *imageStr = [[NSBundle mainBundle] pathForResource:@"0021" ofType:@"jpg" inDirectory:@"Resource"];
//        if(imageStr.length == 0){
//            return;
//        }
        _circleView = [UICircleShapeView shapeView:[UIImage imageWithContentsOfFile:imageStr]];
    }
    return _circleView;
}

@end
