//
//  UIRectShape.m
//  testDemo
//
//  Created by lignpeng on 2018/12/10.
//  Copyright © 2018年 genpeng. All rights reserved.
//

#import "UICircleShapeView.h"

@implementation UICircleShapeView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextMoveToPoint(context, self.bounds.size.width/2.0, self.bounds.size.height/2.0);
//    CGContextAddArc(context, self.bounds.size.width/2.0, self.bounds.size.height/2.0, self.bounds.size.width/2.0, self.startPoint - M_PI/2.0, self.endPoint, (int)self.isClockwise);
//    UIColor*aColor = [UIColor colorWithPatternImage:self.image];
//    CGContextSetFillColorWithColor(context, aColor.CGColor);
//    CGContextDrawPath(context, kCGPathFill);
//    CGImageRef mask = CGBitmapContextCreateImage(context);
//    CGContextClipToMask(context, rect, mask);
//    CGContextRef context = UIGraphicsGetCurrentContext();
        //画一个上下文显示的区域
    CGContextAddArc(context, rect.size.width/2, rect.size.height/2, rect.size.width/2, 0, 2 *M_PI, 1);
        //裁剪上下文的显示区域
    CGContextClip(context);
    [self.image drawInRect:rect];
}


@end
