//
//  SinaWBSendingViewController.m
//  CSMBP
//
//  Created by 寒山凤鸣 on 12-10-10.
//  Copyright (c) 2012年 Forever OpenSource Software Inc. All rights reserved.
//

//------------sinaWBShare imgView
#define kShareImgWidth 280

#define kShareImgHeight 260
#define IPHONE_HEIGHT [UIScreen mainScreen].bounds.size.height
#define IPHONE_WIDTH [UIScreen mainScreen].bounds.size.width

#define kWBSDKDemoAppKey  @"1235495803"//@"272892095"
#define kWBSDKDemoAppSecret  @"3366054ee023801597662c16dbd0d657"/
//NavBar高度
#define NavigationBar_HEIGHT 44
//状态栏
#define StatusBar_HEIGHT    20

#define kMiniScale 0.5
#import "GPTools.h"

#import "SinaWBSendingViewController.h"

#define shareImgViewRect CGRectMake(60,10,200,226)
@interface SinaWBSendingViewController ()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *contentTextView;//编辑框
@property (nonatomic, strong) UIImageView *contentImageView;//图片
@property (nonatomic, strong) UIButton *sendButton;//分享按钮
@property (nonatomic, strong) UILabel *wordCountLabel;//字数label
@property (nonatomic, strong) UIScrollView *scrollView;//看图片用的

@end

@implementation SinaWBSendingViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.contentImage = [UIImage imageNamed:@"0012"];
    self.title= @"微博分享";
    
    self.contentText = @"咖啡；儿科；安排；而我怕‘安抚我GV立刻就阿尔vaopwefjap【靠父母操盘文件方面啊";
//    self.noAnimation = YES;
    [self initView];
    [self animation];
}

- (void)initView {
    
    CGRect frame = [UIScreen mainScreen].bounds;
    CGFloat upMargin = 16;//上边距
    //图片view
    CGFloat imageWdith = 145;
    CGFloat imageHeight = 240;
    if (self.contentImage){
        //调整图片显示尺寸
        CGSize imageSize = self.contentImage.size;
        CGFloat width = imageSize.width;
        CGFloat height = imageSize.height;
        
        float verticalRadio = imageHeight / height;
        float horizontalRadio = imageWdith / width;
        
        float radio = 1;
        if(verticalRadio>1 && horizontalRadio>1) {
            radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
        } else {
            radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
        }
        
        imageWdith = width * radio;
        imageHeight = height * radio;
    }
    CGRect iframe = CGRectMake((CGRectGetWidth(frame) - imageWdith)/2.0, upMargin, imageWdith, imageHeight);
    self.contentImageView = ({
        UIImageView *imageView = [[UIImageView alloc] initWithImage:self.contentImage];
        imageView.frame = iframe;
        //添加手势
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
        [imageView addGestureRecognizer:recognizer];
        imageView.userInteractionEnabled = YES;
        //截图框边框阴影处理
        CALayer *layer = [imageView layer];
        layer.borderColor = [[UIColor lightGrayColor] CGColor];
        layer.borderWidth = 2.0;
        layer.shadowColor = [UIColor blackColor].CGColor;
        layer.shadowOpacity = 0.5;
        layer.shadowRadius = 3.0;
        imageView;
    });
    
    [self.view addSubview:self.contentImageView];
    
    //编辑框
    iframe.origin.y += CGRectGetHeight(iframe) + upMargin;
    iframe.origin.x = 20;
    iframe.size.width = CGRectGetWidth(frame) - CGRectGetMinX(iframe) * 2;
    iframe.size.height = 120;
    self.contentTextView = ({
        UITextView *textView = [[UITextView alloc] initWithFrame:iframe];
        textView.font = [UIFont systemFontOfSize:14];
        textView.textColor = [UIColor blackColor];
        textView.showsVerticalScrollIndicator = YES;
        textView.showsHorizontalScrollIndicator = NO;
        textView.editable = YES;
        textView.selectable = YES;
        textView.delegate = self;
        CALayer *textLayer = [textView layer];
        [textLayer setCornerRadius:8];
        [textLayer setBorderColor:[[UIColor lightGrayColor] CGColor]];
        [textLayer setBorderWidth:2.0f];
        textView;
    });
    self.contentTextView.text = self.contentText;
    [self.view addSubview:self.contentTextView];
    
    //字数label
    self.wordCountLabel = ({
        CGFloat lableWdith = 56;
        CGFloat labelHeight = 21;
        CGRect lframe = CGRectMake(CGRectGetWidth(frame) - CGRectGetMinX(iframe) - lableWdith, CGRectGetMinY(iframe) + CGRectGetHeight(iframe) - labelHeight, lableWdith, labelHeight);
        UILabel *label = [[UILabel alloc] initWithFrame:lframe];
        label.font = [UIFont systemFontOfSize:12.0];
        label.textColor = [UIColor darkGrayColor];
        label.textAlignment = NSTextAlignmentRight;
        label.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
        label;
    });
    [self.view addSubview:self.wordCountLabel];
    
    //发送按钮
    iframe.origin.y += CGRectGetHeight(iframe) + upMargin;
    iframe.size.height = 44;
    self.sendButton = ({
        UIButton *button = [[UIButton alloc] initWithFrame:iframe];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
        [button setTitle:NSLocalizedString(@"Share to Sina Weibo", @"分享到新浪微博") forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor colorWithRed:255/255.f green:154/255.f blue:20/255.f alpha:1.0]];
        [button.layer setCornerRadius:6.0f];
        [button.layer setBorderWidth:0];
        [button.layer setBorderColor:[[UIColor colorWithRed:197/255.f green:0/255.f blue:14/255.f alpha:1] CGColor]];
        [button addTarget:self action:@selector(shareToSinaWB:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.view addSubview:self.sendButton];
    [self calculateTextLength];
}

//图片动画
- (void)animation {
    if (self.noAnimation) {
        return;
    }
    CGRect sframe = [UIScreen mainScreen].bounds;
    UIImageView *cutImageView = [[UIImageView alloc] initWithImage:self.contentImage];
    cutImageView.frame = sframe;
    [[[UIApplication sharedApplication] keyWindow] addSubview:cutImageView];
    self.contentImageView.hidden = YES;

    //动画 cutImageView变小
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:1.0 animations:^{
        CGFloat width = cutImageView.frame.size.width;
        CGFloat height = cutImageView.frame.size.height;
        CGRect iframe = self.contentImageView.frame;
        CGFloat shareImgWidthMini = kMiniScale * CGRectGetWidth(iframe);
        CGFloat shareImgHeightMini = kMiniScale *  CGRectGetHeight(iframe);
        if (height > shareImgHeightMini) {
            width = width *shareImgHeightMini/height;
            height = shareImgHeightMini;
        }else if (width > shareImgWidthMini){
            height = height *shareImgWidthMini/width;
            width = shareImgWidthMini;
        }
        CGPoint center = self.contentImageView.center;
        CGRect tframe = CGRectMake(center.x - width / 2, center.y - height/2 + CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]) + CGRectGetHeight(weakSelf.navigationController.navigationBar.frame) , width, height);
        cutImageView.frame = tframe;
    } completion:^(BOOL finished) {
            //动画 cutImageView变大
            [UIView animateWithDuration:0.7 animations:^{
                CGRect iframe = weakSelf.contentImageView.frame;
                CGFloat width = CGRectGetWidth(iframe);
                CGFloat height = CGRectGetHeight(iframe);
                CGFloat y = CGRectGetMinY(iframe) + CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]) + CGRectGetHeight(weakSelf.navigationController.navigationBar.frame);
                CGRect tframe = CGRectMake(CGRectGetMinX(iframe), y, width, height);
                cutImageView.frame = tframe;
            } completion:^(BOOL finished) {
                weakSelf.contentImageView.hidden = NO;
                [cutImageView removeFromSuperview];
            }];
    }];
}

- (void)completionAction {
    self.contentImageView.hidden = NO;
}

- (void)shareToSinaWB:(UIButton *)sender {
    [self.contentTextView resignFirstResponder];
    NSString *str = self.contentTextView.text.length > 0?self.contentTextView.text:@"请输入微博内容";
    [self showAlertViewWithoutCancelAction:@"新浪微博" message:str handle:^{
        
    }];
}

- (void)handleTapFrom:(UITapGestureRecognizer *)recognizer {
    if (self.scrollView == nil) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, IPHONE_WIDTH, IPHONE_HEIGHT-20)];
        self.scrollView.backgroundColor = [UIColor blackColor];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:self.contentImage];
        [self.scrollView addSubview:imgView];
        self.scrollView.contentSize = CGSizeMake(imgView.frame.size.width, imgView.frame.size.height+1);
        imgView.userInteractionEnabled = YES;
        
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
        [self.scrollView addGestureRecognizer:recognizer];
        self.scrollView.userInteractionEnabled = YES;
        self.scrollView.alpha = 0.0;
        
    }
    if (self.scrollView.alpha <0.01) {
        [[UIApplication sharedApplication].keyWindow addSubview:self.scrollView];
        [UIView animateWithDuration:0.3 animations:^{
            self.scrollView.alpha = 1.0;
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            self.scrollView.alpha = 0.0;
        } completion:^(BOOL finished){
            [self.scrollView removeFromSuperview];
        }];
    }
}


//**********************************************
typedef void(^alertViewHandler)();
- (void)showAlertViewWithoutCancelAction:(NSString *)title message:(NSString *)message handle:(alertViewHandler)handle{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK",@"确定") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (handle) {
            handle();
        }
    }];
    [alertVC addAction:action];
    [[GPTools getCurrentViewController] presentViewController:alertVC animated:true completion:nil];
}

#pragma mark - UITextViewDelegate Methods

- (void)textViewDidChange:(UITextView *)textView{
	[self calculateTextLength];
}

#pragma mark Text Length
- (int)textLength:(NSString *)text{
    float number = 0.0;
    for (int index = 0; index < [text length]; index++){
        NSString *character = [text substringWithRange:NSMakeRange(index, 1)];
        if ([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3){
            number++;
        }else{
            number = number + 0.5;
        }
    }
    return ceil(number);
}

- (void)calculateTextLength{
    if (self.contentTextView.text.length > 0){
		[self.sendButton setEnabled:YES];
		[self.sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	}else{
		[self.sendButton setEnabled:NO];
		[self.sendButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
	}
	int wordcount = [self textLength:self.contentTextView.text];
	NSInteger count  = 140 - wordcount;
	if (count < 0){
		[self.wordCountLabel  setTextColor:[UIColor redColor]];
		[self.sendButton  setEnabled:NO];
		[self.sendButton  setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
	}else{
		[self.wordCountLabel  setTextColor:[UIColor darkGrayColor]];
		[self.sendButton  setEnabled:YES];
		[self.sendButton  setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	}
	
	[self.wordCountLabel  setText:[NSString stringWithFormat:@"%li",(long)count]];
}
@end
