//
//  CSNoviceGuide.m
//  CSMBP
//
//  Created by lignpeng on 16/12/21.
//  Copyright © 2016年 genpeng. All rights reserved.
//
/*
 新手引导
时间：2016年12月21日10:24:21
*/

#import "CSNoviceGuideView.h"

#define keyWindow [UIApplication sharedApplication].keyWindow

@interface CSNoviceGuideView()

@property(nonatomic, strong) NSArray *pathArray;
@property(nonatomic, strong) UIImageView *arrowImageView;
@property(nonatomic, strong) UIImageView *okImageView;
@property(nonatomic, strong) UIBezierPath *bezierPath;
@property(nonatomic, getter=isAnimation, assign) BOOL animation;
@property(nonatomic, assign) NSInteger currentIndex;

@end

@implementation CSNoviceGuideView

-(NSArray *)pathArray {
    if (_pathArray) {
        return _pathArray;
    }
    _pathArray = @[@"circular",@"identify",@"extentionView",
                   @"nullWithNil",@"imageRevose",@"time60s"];
    return _pathArray;
}

- (UIBezierPath *)bezierPath {
    if (_bezierPath) {
        return _bezierPath;
    }
    _bezierPath = [[UIBezierPath alloc] init];
    return _bezierPath;
}

- (UIImageView *)arrowImageView {
    if (_arrowImageView) {
        return _arrowImageView;
    }
    UIImage *arrowImage = [UIImage imageNamed:@"guide_arrow_up"];
    _arrowImageView = [[UIImageView alloc] initWithImage:arrowImage];
    _arrowImageView.frame = CGRectZero;
    [self addSubview:_arrowImageView];
    return _arrowImageView;
}

- (UIImageView *)okImageView {
    if (_okImageView) {
        return _okImageView;
    }
    UIImage *okImage = [UIImage imageNamed:@"guide_ok"];
    _okImageView = [[UIImageView alloc] initWithImage:okImage];
    _okImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    tap.numberOfTapsRequired = 1;
    [_okImageView addGestureRecognizer:tap];
    _okImageView.frame = CGRectZero;
    [self addSubview:_okImageView];
    return _okImageView;
}

+ (instancetype)showNoviceGuideWithAnimated:(BOOL)animated {
    CSNoviceGuideView *guideView = [[CSNoviceGuideView alloc] initWithView:keyWindow animated:animated];
    return guideView;
}

- (instancetype)initWithView:(UIView *)view animated:(BOOL)animated {
    
    CSNoviceGuideView *guideView = [self initWithFrame:view.bounds];
    guideView.backgroundColor = [UIColor blackColor];
    [view addSubview:guideView];
    guideView.animation = animated;
    guideView.alpha = 0.0;
    float alpha = 0.8;
    if (animated) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.30];
        guideView.alpha = alpha;
        [UIView commitAnimations];
    }else {
        guideView.alpha = alpha;
    }
    self.currentIndex = 0;
    [guideView showGuideWithIndex:self.currentIndex];
    return guideView;
}

- (void)showGuideWithIndex:(NSInteger)index {
    if (index > self.pathArray.count -1) {
        return;
    }
    NSString *actionStr = self.pathArray[index];
    SEL action = NSSelectorFromString(actionStr);
    if ([self respondsToSelector:action]) {
//        [self performSelector:action];
//        [self performSelectorInBackground:action withObject:@{@"index":@(index)}];
    }
}

//圆
- (void)circular {
    CGRect frame = keyWindow.bounds;
    [self.bezierPath removeAllPoints];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:frame];
    CGFloat radius = 30;
    [path appendPath:[UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(frame) - radius - 4, 42) radius:radius startAngle:0 endAngle:2 * M_PI clockwise:NO]];
    CAShapeLayer *shaperLayer = [CAShapeLayer layer];
    shaperLayer.path = path.CGPath;
    self.layer.mask = shaperLayer;
    frame.size.height = radius * 2;
    [self viewModelWithFrame:frame];
}

//矩形
- (void)rectanleWintIndex:(NSInteger)index {
    CGRect frame = keyWindow.bounds;
    
    [self.bezierPath removeAllPoints];
    [self.bezierPath appendPath:[UIBezierPath bezierPathWithRect:frame]];
    CGFloat height = 72;
    CGFloat margin = 8;
    frame = CGRectMake(margin, 64 + height * index, CGRectGetWidth(frame) - margin * 2, height);
    [self.bezierPath appendPath:[[UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:5] bezierPathByReversingPath]];
    CAShapeLayer *shaperLayer = [CAShapeLayer layer];
    shaperLayer.path = self.bezierPath.CGPath;
    self.layer.mask = shaperLayer;
    [self viewModelWithFrame:frame];
}

- (void)identify {
    [self rectanleWintIndex:0];
}

- (void)extentionView {
    [self rectanleWintIndex:1];
}

- (void)nullWithNil {
    [self rectanleWintIndex:2];
}

- (void)imageRevose {
    [self rectanleWintIndex:4];
}

- (void)time60s {
    [self rectanleWintIndex:5];
}

- (void)viewModelWithFrame:(CGRect)frame {
    CGFloat margin = 8.0;
    
    CGSize arrowSize = self.arrowImageView.image.size;
    CGSize okSize = self.okImageView.image.size;
    CGFloat marginWidth = (CGRectGetWidth(frame) - arrowSize.width - okSize.width)/2;
    CGRect aframe = CGRectMake(okSize.width + marginWidth + margin, margin + CGRectGetMinY(frame) + CGRectGetHeight(frame), arrowSize.width, arrowSize.height);
    
    CGRect okFrame = CGRectMake(marginWidth, margin + CGRectGetMinY(aframe) + CGRectGetHeight(aframe), okSize.width, okSize.height);
    
    if ((CGRectGetHeight(okFrame) + CGRectGetMinY(okFrame) + margin + 32) > CGRectGetHeight(keyWindow.bounds)) {
        //我知道在上方
        self.arrowImageView.image = [UIImage imageNamed:@"guide_arrow_down"];
        aframe.size = self.arrowImageView.image.size;
        aframe.origin.y = CGRectGetMinY(frame) - CGRectGetHeight(aframe) - margin;
        okFrame.origin.y = CGRectGetMinY(aframe) - CGRectGetHeight(okFrame) - margin;
    }
    
    if ([self isAnimation]) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.30];
        self.okImageView.frame = okFrame;
        self.arrowImageView.frame = aframe;
        [UIView commitAnimations];
    }else {
        self.okImageView.frame = okFrame;
        self.arrowImageView.frame = aframe;
    }
    
}

- (void)tapAction {
    self.currentIndex++;
    if (self.currentIndex > self.pathArray.count -1) {
        [CSNoviceGuideView dismiss];
        return;
    }
    [self showGuideWithIndex:self.currentIndex];
    
}

+ (void)dismiss {
    [self hideAllBackgroundViews];
}

+ (NSUInteger)hideAllBackgroundViews {
    
    NSArray *views = [self allBackgroundViewForView:keyWindow];
    for (CSNoviceGuideView *view in views) {
//        [UIView beginAnimations:nil context:NULL];
//        [UIView setAnimationDuration:0.30];
//        view.alpha = 0;
//        [UIView commitAnimations];
        [UIView animateWithDuration:0.3 animations:^{
            view.alpha = 0;
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
//        [view removeFromSuperview];
    }
    return [views count];
}

+ (NSArray *)allBackgroundViewForView:(UIView *)view {
    NSMutableArray *views = [NSMutableArray array];
    NSArray *subviews = view.subviews;
    for (UIView *aView in subviews) {
        if ([aView isKindOfClass:self]) {
            [views addObject:aView];
        }
    }
    return [NSArray arrayWithArray:views];
}

@end
