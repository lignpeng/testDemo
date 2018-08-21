

#import "CSProgressCustomView.h"

static NSString *kMMRingStrokeAnimationKey = @"mmmaterialdesignspinner.stroke";
static NSString *kMMRingRotationAnimationKey = @"mmmaterialdesignspinner.rotation";

@interface CSProgressCustomView ()
@property (nonatomic, readonly) CAShapeLayer *progressLayer;
@property (nonatomic, readwrite) BOOL isAnimating;

@property(nonatomic, strong) UIImageView *loadingImageView;

@end

@implementation CSProgressCustomView

@synthesize progressLayer=_progressLayer;

- (instancetype)initWithFrame:(CGRect)frame WithImageName:(NSString *)imageName{
    if (self = [super initWithFrame:frame]) {
        self.imageName = imageName;
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    self.loadingImageView = ({
        //CGRectMake(0, 0, 55, 55)
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.image = [UIImage imageNamed:self.imageName];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.center = self.center;
        imageView;
    });
    
    [self addSubview:self.loadingImageView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetAnimations) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (UIImageView *)rotate360DegreeWithImageView:(UIImageView *)imageView{
    CABasicAnimation *animation = [ CABasicAnimation
                                   animationWithKeyPath: @"transform" ];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    
    //围绕Z轴旋转，垂直与屏幕
    animation.toValue = [ NSValue valueWithCATransform3D:
                         
                         CATransform3DMakeRotation(M_PI, 0.0, 0.0, 1.0) ];
    animation.duration = 0.65;
    //旋转效果累计，先转180度，接着再旋转180度，从而实现360旋转
    animation.cumulative = YES;
    animation.repeatCount = 5;
    
    //在图片边缘添加一个像素的透明区域，去图片锯齿
    CGRect imageRrect = CGRectMake(0, 0,imageView.frame.size.width, imageView.frame.size.height);
    UIGraphicsBeginImageContext(imageRrect.size);
    [imageView.image drawInRect:CGRectMake(1,1,imageView.frame.size.width-2,imageView.frame.size.height-2)];
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [imageView.layer addAnimation:animation forKey:nil];
    return imageView;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

//- (void)layoutSubviews {
//    [super layoutSubviews];
////    self.loadingImageView.center = self.center;
////    CGRect frame = self.bounds;
////    CGRect iframe = self.loadingImageView.bounds;
////    iframe.origin.x = (CGRectGetWidth(frame) - CGRectGetWidth(iframe))/2;
////    iframe.origin.y = (CGRectGetHeight(frame) - CGRectGetHeight(iframe))/2;
////    self.loadingImageView.frame = iframe;
//}

- (void)resetAnimations {

    if (self.isAnimating) {
        [self stopAnimating];
        [self startAnimating];
    }
}

- (void)setAnimating:(BOOL)animate {
    (animate ? [self startAnimating] : [self stopAnimating]);
}

- (void)startAnimating {
    if (self.isAnimating){
        return;
    }
    
    self.loadingImageView = [self rotate360DegreeWithImageView:self.loadingImageView];

    self.isAnimating = true;
    
    if (self.hidesWhenStopped) {
        self.hidden = NO;
    }
}

- (void)stopAnimating {
    if (!self.isAnimating){
        return;
    }
    
    [self.loadingImageView.layer removeAllAnimations];

    self.isAnimating = false;
    
    if (self.hidesWhenStopped) {
        self.hidden = YES;
    }
}

#pragma mark - Private

#pragma mark - Properties



- (BOOL)isAnimating {
    return _isAnimating;
}

- (void)setHidesWhenStopped:(BOOL)hidesWhenStopped {
    _hidesWhenStopped = hidesWhenStopped;
    self.hidden = !self.isAnimating && hidesWhenStopped;
}

@end
