//
//  UINameListView.m
//
//  Created by lignpeng on 2017/7/26.
//


#import "UINameListView.h"
#import "Masonry.h"
#import "GGMacors.h"
static const CGFloat kHolderViewHeight = 250.0f;//选择器总高度
static const CGFloat kBarViewHeight = 50.0f;//bar条高度
static const CGFloat kButtonWidth = 72.0f;//按钮宽度
static const NSTimeInterval kAnimationDuration = 0.25f;
static const CGFloat kPickerViewHeight = 42.0f;//选择器高度

@interface UINameListView()<UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic, strong) UIPickerView *pickerView;
@property(nonatomic, strong) UIButton *cancelButton;
@property(nonatomic, strong) UIButton *okButton;
@property(nonatomic, strong) UIView *holderView;
@property(nonatomic, strong) NSArray *dataSource;
@property(nonatomic, strong) NSString *key;
@property(nonatomic, assign) BOOL isDictionary;

@end

@implementation UINameListView

+ (instancetype)airNameListView {
    UINameListView *view = [[UINameListView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [view show];
    return view;
}

+ (instancetype)airNameListView:(void (^)(NSInteger index, NSString *name))complishBlock {
    UINameListView *view = [self airNameListView];
    view.complishBlock = complishBlock;
    return view;
}

+ (instancetype)airNameListView:(NSArray *)dataSource complish:(void(^)(NSInteger index, NSString *name))complishBlock {
    UINameListView *view = [self airNameListView:complishBlock];
    view.dataSource = dataSource;
    return view;
}

+ (instancetype)airNameListView:(NSArray *)dataSource selectedIndex:(NSInteger )selectedIndex complish:(void(^)(NSInteger index, NSString *name))complishBlock {
    UINameListView *view = [[UINameListView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.dataSource = dataSource;
    view.selectRow = selectedIndex;
    view.complishBlock = complishBlock;
    [view show];
    return view;
}

+ (instancetype)airNameListView:(NSArray *)dataSource key:(NSString *)key selectedIndex:(NSInteger )selectedIndex complish:(void(^)(NSInteger index, NSString *name))complishBlock {
    UINameListView *view = [[UINameListView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.dataSource = dataSource;
    view.selectRow = selectedIndex;
    view.complishBlock = complishBlock;
    view.key = key;
    view.isDictionary = YES;
    [view show];
    return view;
}

+ (void)dissmiss {
    UIWindow *windowView = [[UIApplication sharedApplication] keyWindow];
    for (UIView *subView in windowView.subviews) {
        if ([subView isMemberOfClass:[UINameListView class]]) {
            [(UINameListView *)subView dismiss];
        }
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (NSArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSArray array];
    }
    return _dataSource;
}

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [UIPickerView new];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.showsSelectionIndicator = YES;
        _pickerView.backgroundColor = [UIColor whiteColor];
    }
    return _pickerView;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_cancelButton setTitleColor:[UIColor colorWithRed:0.0/255.0 green:138.0/255.0 blue:203.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_cancelButton setTitle:NSLocalizedString(@"Cancel", @"取消") forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}
- (UIButton *)okButton {
    if (!_okButton) {
        _okButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _okButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_okButton setTitleColor:[UIColor  colorWithRed:0.0/255.0 green:138.0/255.0 blue:203.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_okButton setTitle:NSLocalizedString(@"OK_confirm", @"确定") forState:UIControlStateNormal];
        [_okButton addTarget:self action:@selector(okAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _okButton;
}

- (UIView *)holderView {
    if (!_holderView) {
        _holderView = [UIView new];
        _holderView.backgroundColor = [UIColor colorWithRed:209.0/255.0 green:217.0/255.0 blue:224.0/255.0 alpha:1.0];
    }
    return _holderView;
}

- (void)initView {
    [self.holderView addSubview:self.cancelButton];
    [self.holderView addSubview:self.okButton];
    [self.holderView addSubview:self.pickerView];
    [self addSubview:self.holderView];
    
    [self.holderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self);
        make.trailing.equalTo(self);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(kHolderViewHeight);
    }];
    
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.holderView);
        make.trailing.equalTo(self.holderView);
        make.bottom.equalTo(self.holderView);
        make.height.mas_equalTo(kHolderViewHeight - kBarViewHeight);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.holderView);
        make.leading.equalTo(self.holderView);
        make.bottom.equalTo(self.pickerView.mas_top);
        make.width.mas_equalTo(kButtonWidth);
    }];
    
    [self.okButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.holderView);
        make.trailing.equalTo(self.holderView);
        make.bottom.equalTo(self.pickerView.mas_top);
        make.width.mas_equalTo(kButtonWidth);
    }];
}

- (void)cancelAction {
    [self dismiss];
}

- (void)okAction {    
    if (self.dataSource.count > self.selectRow && self.complishBlock) {
        NSString *name;
        if (self.isDictionary) {
            NSDictionary *dic = self.dataSource[self.selectRow];
            name = [dic objectForKey:self.key];
        }else {
            name = self.dataSource[self.selectRow];
        }
        self.complishBlock(self.selectRow, name);
    }
    [self dismiss];
}

- (void)show {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0f];
    CGRect hframe = self.holderView.frame;
    hframe.origin.y -= kHolderViewHeight;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:kAnimationDuration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        weakSelf.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6f];
        weakSelf.holderView.frame = hframe;
    } completion:^(BOOL finished) {
        
    }];
    [self.pickerView selectRow:self.selectRow inComponent:0 animated:YES];
}

- (void)dismiss {
    CGRect hframe = self.holderView.frame;
    hframe.origin.y += kHolderViewHeight;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:kAnimationDuration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        weakSelf.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0f];
        weakSelf.holderView.frame = hframe;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectRow = row;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dataSource.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [UILabel new];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:16]];
        pickerLabel.textColor = RgbColor(0, 35, 78);
    }    
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    for (UIView *subView in pickerView.subviews) {
        if (CGRectGetHeight(subView.frame) < 1) {
            subView.backgroundColor = RgbColor(209, 217, 224);
        }
    }
    return pickerLabel;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (self.isDictionary) {
        NSDictionary *dic = self.dataSource[row];
        return [dic objectForKey:self.key];
    }
    return self.dataSource[row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return kPickerViewHeight;
}

@end
