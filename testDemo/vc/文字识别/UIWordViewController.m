//
//  UIWordViewController.m
//  testDemo
//
//  Created by lignpeng on 2018/8/21.
//  Copyright © 2018年 genpeng. All rights reserved.
//

#import "UIWordViewController.h"
#import "DataTools.h"
#import "HexColor.h"
#import "GPTools.h"

@interface UIWordViewController ()

@property(nonatomic, strong) UITextView *textView;
@property(nonatomic, strong) NSString *text;
@property(nonatomic, strong) UIButton *okButton;
@property(nonatomic, strong) UIButton *copyButton;
//@property(nonatomic, strong) UIButton *reviewButton;

@end

@implementation UIWordViewController

+ (instancetype)wordViewControllerWithString:(NSString *)text {
    UIWordViewController *vc = [UIWordViewController new];
    vc.text = text;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.textView];
    self.textView.text = self.text;
    [self.view addSubview:self.okButton];
    [self.view addSubview:self.copyButton];
//    self.navigationItem.rightBarButtonItem
}

- (void)viewDidLayoutSubviews {
    CGFloat margin = 32;
    CGFloat bheight = 42;
    CGRect sframe = [UIScreen mainScreen].bounds;
    CGRect tframe = (CGRect){margin * 0.5,margin,CGRectGetWidth(sframe) - margin,CGRectGetHeight(sframe) - bheight - margin*2};
    self.textView.frame = tframe;
    CGFloat widht = CGRectGetWidth(sframe) - margin * 2.25;
    CGRect bframe = (CGRect){margin,CGRectGetMinY(tframe)+CGRectGetHeight(tframe)+margin *0.5,widht * 0.6,bheight};
    self.okButton.frame = bframe;
    bframe.origin.x += CGRectGetWidth(bframe) + margin * 0.25;
    bframe.size.width = widht * 0.4;
    self.copyButton.frame = bframe;
}

- (void)action {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)copyAction {
    if (self.text.length > 0) {
        UIPasteboard *board = [UIPasteboard generalPasteboard];
        board.string = self.text;
        [GPTools ShowInfoTitle:@"提示" message:@"复制成功！" delayTime:0.2];
    }
    
}

- (void)reviewAction {
    
}

- (void)showString:(NSArray *)array {
    NSString *str = @"";
    for (NSString *string in array) {
        str = [str stringByAppendingFormat:@"\n%@",string];
    }
    self.textView.text = str;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [UITextView new];
        _textView.font = [UIFont systemFontOfSize:14];
        _textView.showsHorizontalScrollIndicator = NO;
        _textView.editable = NO;
        _textView.textAlignment = NSTextAlignmentLeft;
    }
    return _textView;
}

- (UIButton *)copyButton {
    if (!_copyButton) {
        _copyButton = ({
            UIButton *bt = [[UIButton alloc] initWithFrame:CGRectZero];
            [bt addTarget:self action:@selector(copyAction) forControlEvents:UIControlEventTouchUpInside];
            [bt setTitle:@"复制" forState:UIControlStateNormal];
            bt.backgroundColor = [UIColor colorWith8BitRedN:arc4random()%256 green:arc4random()%256 blue:arc4random()%256];
            bt.layer.cornerRadius = 5;
            bt.clipsToBounds = YES;
            bt;
        });
    }
    return _copyButton;
}

- (UIButton *)okButton {
    if (!_okButton) {
        _okButton = ({
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
            [button addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
            [button setTitle:@"确定" forState:UIControlStateNormal];
            button.backgroundColor = [UIColor colorWith8BitRedN:arc4random()%256 green:arc4random()%256 blue:arc4random()%256];
            button.layer.cornerRadius = 5;
            button.clipsToBounds = YES;
            button;
        });
    }
    return _okButton;
}

//- (UIButton *)reviewButton {
//    if (!_reviewButton) {
//        _reviewButton = ({
//            UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
//            [button addTarget:self action:@selector(reviewAction) forControlEvents:UIControlEventTouchUpInside];
//            [button setTitle:@"恢复" forState:UIControlStateNormal];
//            button.backgroundColor = [UIColor colorWith8BitRedN:arc4random()%256 green:arc4random()%256 blue:arc4random()%256];
//            button.layer.cornerRadius = 5;
//            button.clipsToBounds = YES;
//            button;
//        });
//    }
//    return _reviewButton;
//}

@end
