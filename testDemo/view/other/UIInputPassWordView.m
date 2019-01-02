//
//  UIInputPassWordView.m

//
//  Created by lignpeng on 2018/12/12.
//  Copyright © 2018年 genpeng. All rights reserved.
//

#import "UIInputPassWordView.h"
#import "HexColor.h"
static const CGFloat kLineHeight = 0.5f;//bar条高度

@interface UIInputPassWordView ()

@property (nonatomic, assign) NSInteger passWordNum;//密码的位数
@property (nonatomic, assign) CGFloat pointRadius;//黑点半径
@property (nonatomic, strong) UIColor *pointColor;//黑点颜色
@property(nonatomic, strong) UIColor *lineColor;
@property(nonatomic, assign) NSInteger wordLength;

@end

@implementation UIInputPassWordView

+ (instancetype)inputPasswordView:(NSUInteger)passwordNum {
    UIInputPassWordView *view = [[UIInputPassWordView alloc] init];
    view.passWordNum = passwordNum;
    return view;
}

- (instancetype)init {
    if(self = [super init]){
        self.lineColor = [UIColor colorWithHexString:@"#D1D9E0"];
        self.passWordNum = 6;
        self.pointRadius = 6;
        self.wordLength = 0;
        self.backgroundColor = [UIColor whiteColor];
        //设置边框圆角与颜色
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 3;
        self.layer.borderColor = self.lineColor.CGColor;
        self.layer.borderWidth = kLineHeight;
    }
    return self;
}

- (void)updateView:(NSInteger)length isError:(BOOL)isError {
    if (isError) {
        self.lineColor = [UIColor colorWithHexString:@"#E5004E"];
    }else {
        self.lineColor = [UIColor colorWithHexString:@"#D1D9E0"];
    }
    self.wordLength = length <= self.passWordNum?length:self.passWordNum;
    self.layer.borderColor = self.lineColor.CGColor;
    [self setNeedsDisplay];
}

//划线
- (void)drawRect:(CGRect)rect {
    if (self.passWordNum <= 0) {
        self.passWordNum = 6;
    }
    CGFloat squareWidth = CGRectGetWidth(rect)/self.passWordNum;
    CGFloat height = rect.size.height;
    CGFloat width = rect.size.width;
    CGFloat x = (width - squareWidth * self.passWordNum)/2.0;
    CGFloat y = (height - squareWidth)/2.0;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, kLineHeight);
    //设置分割线颜色
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    
    for (int i = 0; i < self.passWordNum - 1;  i++){
        CGContextMoveToPoint(context, squareWidth * (i + 1), 0);
        CGContextAddLineToPoint(context,squareWidth * (i + 1) , CGRectGetHeight(rect));
    }
    CGContextStrokePath(context);
    CGContextDrawPath(context, kCGPathStroke);
    //画黑点
    CGContextSetFillColorWithColor(context, self.pointColor.CGColor);
    for (int i = 1; i <= self.wordLength; i++) {
        CGContextAddArc(context, x + squareWidth * i - squareWidth/2.0, y + squareWidth/2.0, self.pointRadius, 0, M_PI * 2, YES);
        CGContextDrawPath(context, kCGPathFill);
    }
}

@end
