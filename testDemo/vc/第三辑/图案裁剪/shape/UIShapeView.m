//
//  UIShapeView.m
//  testDemo
//
//  Created by lignpeng on 2018/12/10.
//  Copyright © 2018年 genpeng. All rights reserved.
//

#import "UIShapeView.h"

@implementation UIShapeView

+(instancetype)shapeView:(UIImage *)image {
    UIShapeView *view = [UIShapeView new];
//    view.image = image;
    view.backgroundColor = [UIColor clearColor];
//    view.bounds = (CGRect){0,0,image.size.width,image.size.height};
    view.frame = (CGRect){0,0,image.size.width,image.size.height};
    view.image = image;
    [view setNeedsDisplay];//重绘制
    return view;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
