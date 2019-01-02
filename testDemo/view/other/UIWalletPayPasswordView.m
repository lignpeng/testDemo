//
//  UIWalletPayPasswordView.m
//
//  Created by lignpeng on 2018年12月12日.
//


#import "UIWalletPayPasswordView.h"
#import "Masonry.h"
#import "UIInputPassWordView.h"
#import "HexColor.h"
#import "GPTools.h"
static const CGFloat kPayHolderViewHeight = 184.0f;//选择器总高度
static const CGFloat kPayBarViewHeight = 44.0f;//bar条高度
static const CGFloat kButtonWidth = 72.0f;//按钮宽度
static const NSTimeInterval kAnimationDuration = 0.25f;

@interface UIWalletPayPasswordView()<UITextFieldDelegate>

@property(nonatomic, strong) UIButton *cancelButton;
@property(nonatomic, strong) UIView *holderView;
@property(nonatomic, strong) UIInputPassWordView *passwordView;
@property(nonatomic, strong) NSString *password;
@property(nonatomic, strong) UILabel *errorLabel;
@property(nonatomic, strong) UIButton *forgetButton;
@property(nonatomic, strong) UITextField *textField;
@property(nonatomic, copy) void (^forgetPasswordBlock)(void);

@end

@implementation UIWalletPayPasswordView

+ (instancetype)walletPayPasswordView {
    UIWalletPayPasswordView *view = [[UIWalletPayPasswordView alloc] init];
    view.modalPresentationStyle = UIModalPresentationOverFullScreen;
    UIViewController *superVC = [GPTools getCurrentViewController];
    [superVC presentViewController:view animated:YES completion:nil];
    return view;
}

+ (instancetype)walletPayPasswordView:(void (^)(NSString *name))complishBlock {
    UIWalletPayPasswordView *view = [self walletPayPasswordView];
    view.complishBlock = complishBlock;
    return view;
}

+ (instancetype)walletPayPasswordView:(void(^)(NSString *string))complishBlock forgetPassword:(void(^)(void))forgetPasswordBlock {
    UIWalletPayPasswordView *view = [self walletPayPasswordView];
    view.complishBlock = complishBlock;
    view.forgetPasswordBlock = forgetPasswordBlock;
    return view;
}

- (void)viewDidLoad {
    [self addNoticeForKeyboard];
    self.view.backgroundColor = [UIColor whiteColor];
    self.inputTime = 6;
    [self initView];
    [self show];
}

- (void)initView {
    UIView *headerBar = [UIView new];
    headerBar.backgroundColor = [UIColor colorWithHexString:@"#7E8B95"];
    [self.holderView addSubview:headerBar];
    UILabel *titleLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:16];
        label.text = @"请输入支付密码";
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label;
    });
    [headerBar addSubview:titleLabel];
    [headerBar addSubview:self.cancelButton];
    [self.holderView addSubview:self.passwordView];
    [self.holderView addSubview:self.errorLabel];
    [self.holderView addSubview:self.forgetButton];
    [self.view addSubview:self.holderView];
    [self.holderView addSubview:self.textField];
    
    [headerBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.holderView);
        make.height.mas_equalTo(kPayBarViewHeight);
    }];
    
    [self.passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerBar.mas_bottom).offset(34);
        make.left.equalTo(self.holderView).offset(15);
        make.right.equalTo(self.holderView).offset(-15);
        make.height.mas_equalTo(48);
    }];
    
    [self.forgetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.errorLabel.mas_centerY);
        make.right.equalTo(self.holderView).offset(-15);
        make.height.mas_equalTo(43);
        make.width.mas_equalTo(64);
    }];
    
    [self.errorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordView.mas_bottom);
        make.bottom.equalTo(self.holderView.mas_bottom);
        make.left.equalTo(self.holderView).offset(15);
        make.right.equalTo(self.forgetButton.mas_left).offset(-6);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerBar);
        make.top.bottom.equalTo(headerBar);
        make.width.mas_equalTo(180);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerBar);
        make.leading.equalTo(headerBar);
        make.bottom.equalTo(headerBar);
        make.width.mas_equalTo(kButtonWidth);
    }];
    
    [self updateView:NO];
    [self.holderView addSubview:self.textField];
    [self.textField becomeFirstResponder];
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backViewAction)];
    ges.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:ges];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyBoardAction)];
    tap.numberOfTapsRequired = 1;
    [self.holderView addGestureRecognizer:tap];
}

- (void)backViewAction {
    //键盘没有弹起的情况
    CGPoint hpoint = self.holderView.frame.origin;
    if (hpoint.x>=CGRectGetWidth([UIScreen mainScreen].bounds) || hpoint.y >= CGRectGetHeight([UIScreen mainScreen].bounds)) {
        [self dismiss];
    }
}

- (void)keyBoardAction {
    [self.textField becomeFirstResponder];
}

- (void)updateView:(BOOL)hasError inputTime:(NSInteger)time {
    self.inputTime = time;
    [self updateView:hasError];
}

- (void)updateView:(BOOL)hasError {
    [self.passwordView updateView:self.password.length isError:hasError];
    if (hasError) {
        if (self.inputTime > 0) {
            self.errorLabel.text = [NSString stringWithFormat:@"支付密码有误，您还有%ld次尝试机会",(long)self.inputTime];
        }else {
            self.errorLabel.text = @"您的钱包支付功能已被锁定。";
        }
    }
    self.errorLabel.hidden = !hasError;
}

- (void)updateView:(BOOL)hasError errorStr:(NSString *)errorStr {
    self.textField.text = @"";
    [self.passwordView updateView:0 isError:hasError];
    if (hasError) {
        self.errorLabel.text = errorStr;
    }
    self.errorLabel.hidden = !hasError;
    [self.textField becomeFirstResponder];
}


- (void)cancelAction {
    [self dismiss];
}

- (void)forgetPasswordAction {
    
    [self dismiss];
    if (self.forgetPasswordBlock) {
        self.forgetPasswordBlock();
    }
}

- (void)show {
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect hframe = self.holderView.frame;
    hframe.origin.x -= CGRectGetWidth([UIScreen mainScreen].bounds);
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:kAnimationDuration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        weakSelf.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6f];
        weakSelf.holderView.frame = hframe;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss {
    [self.textField resignFirstResponder];
    CGRect hframe = self.holderView.frame;
    hframe.origin.y += kPayHolderViewHeight;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:kAnimationDuration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        weakSelf.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0f];
        weakSelf.holderView.frame = hframe;
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)textFieldValueChanged:(UITextField *)textField {
    self.password = textField.text;
    [self updateView:NO];
    if (self.password.length == 6 && self.complishBlock) {
        self.complishBlock(self.password);
    }
    NSLog(@"%@",textField.text);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if([string isEqualToString:@" "]) {
        return NO;
    }
    NSString *text = textField.text;
    NSInteger newLenght = text.length + string.length - range.length;
    return newLenght <= 6;
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
    CGFloat offset =  CGRectGetHeight(self.view.bounds) - (CGRectGetMinY(self.holderView.frame) + CGRectGetHeight(self.holderView.frame)) - kbHeight;
        // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        //将视图上移计算好的偏移
    CGRect frame = self.holderView.frame;
    frame.origin.y += offset;
    [UIView animateWithDuration:duration animations:^{
        self.holderView.frame = frame;
    }];
}

//键盘消失事件
- (void) keyboardWillHide:(NSNotification *)notify {
        // 键盘动画时间
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        //视图恢复原状
    CGRect frame = self.holderView.frame;
    frame.origin.y = CGRectGetHeight([UIScreen mainScreen].bounds) - CGRectGetHeight(self.holderView.frame);
    [UIView animateWithDuration:duration animations:^{
        self.holderView.frame = frame;
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



- (UIInputPassWordView *)passwordView {
    if (!_passwordView) {
        _passwordView = [UIInputPassWordView inputPasswordView:6];
    }
    return _passwordView;
}

- (UITextField *)textField {
    if (!_textField){
        _textField = [[UITextField alloc] init];
        _textField.delegate = self;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        [_textField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)forgetButton {
    if (!_forgetButton) {
        _forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _forgetButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_forgetButton setTitleColor:[UIColor colorWithHexString:@"#008ACB"] forState:UIControlStateNormal];
        [_forgetButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
        [_forgetButton addTarget:self action:@selector(forgetPasswordAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetButton;
}

- (UILabel *)errorLabel {
    if (!_errorLabel){
        _errorLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:14];
            label.text = @"支付密码有误，您还有5次尝试机会";
            label.textColor = [UIColor colorWithHexString:@"#E5004E"];
            label.textAlignment = NSTextAlignmentLeft;
            label.numberOfLines = 0;
            label.backgroundColor = [UIColor clearColor];
            label;
        });
    }
    return _errorLabel;
}

- (UIView *)holderView {
    if (!_holderView) {
        _holderView = [UIView new];
        _holderView.backgroundColor = [UIColor whiteColor];
        _holderView.frame = (CGRect){CGRectGetWidth([UIScreen mainScreen].bounds),CGRectGetHeight([UIScreen mainScreen].bounds),CGRectGetWidth([UIScreen mainScreen].bounds),kPayHolderViewHeight};
    }
    return _holderView;
}

@end
