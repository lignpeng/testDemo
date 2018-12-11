//
//  UIRectShape.m
//  testDemo
//
//  Created by lignpeng on 2018/12/10.
//  Copyright © 2018年 genpeng. All rights reserved.
//

#import "UIRectShapeView.h"

@implementation UIRectShapeView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddRect(context, self.bounds);
//    UIColor*aColor = [UIColor colorWithPatternImage:self.image];
//    CGContextSetFillColorWithColor(context, aColor.CGColor);
//    CGContextDrawPath(context, kCGPathFill);
//    CGImageRef mask = CGBitmapContextCreateImage(context);
//    CGContextClipToMask(context, rect, mask);
    [self.image drawInRect:rect];
}


@end
