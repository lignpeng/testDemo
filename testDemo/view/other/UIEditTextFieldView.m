//
//  UIEditTextFieldView.m
//  testDemo
//
//  Created by lignpeng on 2018/8/1.
//  Copyright © 2018年 genpeng. All rights reserved.
//
#import "HexColor.h"
#import "UIEditTextFieldView.h"
#import "GPTools.h"

@interface UIEditTextFieldView()

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIView *holdView;
@property (nonatomic, strong) UIView *sepLine;
@property (nonatomic, strong) UIView *sepT;
@property(nonatomic, strong) UILabel *tipLabel;
@property(nonatomic, strong) UIButton *okButton;
@property(nonatomic, strong) UIButton *cancelButton;
@property(nonatomic, copy) void (^complishBlock)(NSString *text);
@property(nonatomic, copy) void (^cancelBlock)();
@end

@implementation UIEditTextFieldView

+ (void)editTextFieldWithTitle:(NSString *) title editStr:(NSString *)editStr complish:(void(^)(NSString *text))complishBlock cancelBlock:(void(^)())cancelBlock {
    UIEditTextFieldView *vc = [[UIEditTextFieldView alloc] init];
    vc.complishBlock = complishBlock;
    vc.cancelBlock = cancelBlock;
    if (title.length > 0) {
        vc.tipLabel.text = title;
    }
    if (editStr.length > 0) {
        vc.textField.text = editStr;
    }
    vc.view.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.1];
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [[GPTools getCurrentViewController] presentViewController:vc animated:YES completion:nil];
}

- (void)viewDidLoad {
    [self initView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyBoardHiden)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    [self addNoticeForKeyboard];
}

- (void)keyBoardHiden {
    [self.view endEditing:YES];
}
#pragma mark - 键盘通知
- (void)addNoticeForKeyboard {
        //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self                                             selector:@selector(keyboardWillShow:)                                                 name:UIKeyboardWillShowNotification object:nil];    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self                                             selector:@selector(keyboardWillHide:)                                                 name:UIKeyboardWillHideNotification object:nil];
}

//键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {
        //获取键盘高度，在不同设备上，以及中英文下是不同的
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
        //计算要偏移的距离
    CGFloat offset =  CGRectGetHeight(self.view.frame) - (CGRectGetMinY(self.holdView.frame) + CGRectGetHeight(self.holdView.frame)) - kbHeight;
        // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        //将视图上移计算好的偏移
    if(offset > 0) {
        return;
    }
    CGRect sframe = self.holdView.frame;
    sframe.origin.y += (offset - 18);
    
    [UIView animateWithDuration:duration animations:^{
        self.holdView.frame = sframe;
    }];
}

//键盘消失事件
- (void) keyboardWillHide:(NSNotification *)notify {
        // 键盘动画时间
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        //视图恢复原状
    [UIView animateWithDuration:duration animations:^{
        self.holdView.center = self.view.center;
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.frame = [UIScreen mainScreen].bounds;
    self.holdView.layer.cornerRadius = 14;
    self.holdView.layer.masksToBounds = YES;
    [self.holdView addSubview:self.tipLabel];
    [self.holdView addSubview:self.textField];
    [self.holdView addSubview:self.sepLine];
    [self.holdView addSubview:self.sepT];
    [self.holdView addSubview:self.okButton];
    [self.holdView addSubview:self.cancelButton];
    [self.view addSubview:self.holdView];
    
}

- (void)viewDidLayoutSubviews {
    CGFloat margin = 16;
    CGFloat buttonHeight = 44;
    CGFloat textFieldHeight = 32;
    CGFloat labelHeight = 20;
    //16+20++16+3016+1+44
    
    CGFloat vHeight = margin+ labelHeight +margin+textFieldHeight+1+margin+1+buttonHeight;
    
    CGRect frame = (CGRect){0,margin*2,CGRectGetWidth(self.view.frame)-margin*4,vHeight};
    self.holdView.frame = frame;
    self.holdView.center = self.view.center;
    
    CGRect lframe = (CGRect){0,margin,CGRectGetWidth(frame),labelHeight};
    self.tipLabel.frame = lframe;
    
    lframe.origin.y += CGRectGetHeight(lframe) + margin;
    lframe.origin.x += margin;
    lframe.size.height = textFieldHeight;
    lframe.size.width -= margin*2;
    self.textField.frame = lframe;
    lframe.origin.y += CGRectGetHeight(lframe);
    lframe.size.height = 1;
    self.sepT.frame = lframe;
    
    lframe.origin.y += CGRectGetHeight(lframe) + margin;
    lframe.origin.x -= margin;
    lframe.size.height = 1;
    lframe.size.width += margin*2;
    self.sepLine.frame = lframe;
    
    lframe.origin.y += CGRectGetHeight(lframe);
    lframe.size.height = buttonHeight;
    lframe.size.width *= 0.5;
    self.okButton.frame = lframe;
    lframe.origin.x += lframe.size.width;
    self.cancelButton.frame = lframe;
}

- (void)okAction {
    [self dismiss];
    if (self.textField.text.length == 0) {
        return;
    }
    if (self.complishBlock) {
        self.complishBlock(self.textField.text);
    }
}

- (void)cancelAction {
    [self dismiss];
    if (self.cancelBlock) {
        self.cancelBlock();
    }    
}

- (void)dismiss {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIView *)holdView {
    if (!_holdView) {
        _holdView = [[UIView alloc] init];
        _holdView.backgroundColor = [UIColor whiteColor];
        _holdView.frame = (CGRect){0,0,120,64};
    }
    return _holdView;
}

- (UIView *)sepLine {
    if (!_sepLine) {
        _sepLine = [UIView new];
        _sepLine.frame = (CGRect){0,0,1,1};
        _sepLine.backgroundColor = [UIColor grayColor];
    }
    return _sepLine;
}

- (UIView *)sepT {
    if (!_sepT) {
        _sepT = [UIView new];
        _sepT.frame = (CGRect){0,0,1,1};
        _sepT.backgroundColor = [UIColor grayColor];
    }
    return _sepT;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.font = [UIFont systemFontOfSize:14];
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.textColor = [UIColor blackColor];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.placeholder = @"请输入标题";
    }
    return _textField;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.font = [UIFont systemFontOfSize:15];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.text = @"提示";
        _tipLabel.textColor = [UIColor blackColor];
    }
    return _tipLabel;
}

- (UIButton *)okButton {
    if (!_okButton) {
        _okButton = [UIButton new];
        _okButton.backgroundColor = [UIColor colorWith8BitRed:89 green:189 blue:249];
        [_okButton setTitle:@"确定" forState:UIControlStateNormal];
        [_okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _okButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [_okButton addTarget:self action:@selector(okAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _okButton;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton new];
        _cancelButton.backgroundColor = [UIColor whiteColor];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [_cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

@end
