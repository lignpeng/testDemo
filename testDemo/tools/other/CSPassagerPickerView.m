//


#import "CSPassagerPickerView.h"
#import "Masonry.h"

#define kMaxTotalNumber 9
CGFloat kShowViewHeight = 250; // 整个自定义pickerView的高度
CGFloat kPassengerLabelHeight = 30;

@interface CSPassagerPickerView()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic,strong) UIView *topView;  // 高250
@property (nonatomic,strong) UIButton *conformBtn; // 高35
@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UIPickerView *pickerView;
@property(nonatomic, strong) UIView *passagerView;
// 成人/儿童/婴儿 所选乘机人数
@property (nonatomic,copy) NSString *adtNumber;
@property (nonatomic,copy) NSString *childNumber;
@property (nonatomic,copy) NSString *infantNumber;
// 成人/儿童/婴儿 可选乘机人数
@property (nonatomic,strong) NSArray *adtArrs;
@property (nonatomic,strong) NSMutableArray *childArrs;
@property (nonatomic,strong) NSMutableArray *infantArrs;

@property(nonatomic, copy) void (^selectBlock)(NSMutableArray *numberArrs);

@end

@implementation CSPassagerPickerView

+ passagerPickerViewSelectBlock:(void(^)(NSMutableArray *numberArrs))selectBlock {
    CSPassagerPickerView *picker = [[CSPassagerPickerView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    picker.selectBlock = selectBlock;
    [picker initView];
    [picker showPickerView];
    return picker;
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = kbgColorAlpha(0, 0, 0, 0.4);
        self.backgroundColor = [UIColor lightTextColor];
        self.userInteractionEnabled = YES;
        // 默认乘机人数：成人:1，儿童:0，婴儿:0
        self.adtNumber = @"1";
        self.childNumber = @"0";
        self.infantNumber = @"0";
        // 根据乘机人联动规则--》默认可选乘机人范围
        self.adtArrs = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9", nil];
        self.childArrs = [NSMutableArray arrayWithObjects:@"0",@"1",@"2", nil];
        self.infantArrs = [NSMutableArray arrayWithObjects:@"0",@"1", nil];
        UITapGestureRecognizer *tapGesTure = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tapGesTure];
    }
    return self;
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    [self removeFromSuperview];
}

//去除区域内点击事件的影响
- (void)tapNoAction {
    return;
}

- (void)initView {

    [self addSubview:self.topView];
    
    UIView *labelView = [UIView new];
//    labelView.backgroundColor = [UIColor colorFromHexString:@"#7E8B95"];
    labelView.backgroundColor = [UIColor lightGrayColor];
    [self.topView addSubview:labelView];
    [labelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.topView);
        make.height.mas_equalTo(35);
    }];
    
    [labelView addSubview:self.cancelBtn];
    [labelView addSubview:self.conformBtn];
    [labelView addSubview:self.titleLab];
    
    CGFloat buttonWidth = 60;
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(labelView);
        make.bottom.equalTo(labelView.mas_bottom);
        make.width.mas_equalTo(buttonWidth);
    }];
    [self.conformBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.equalTo(labelView);
        make.bottom.equalTo(labelView.mas_bottom);
        make.width.mas_equalTo(buttonWidth);
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labelView);
        make.width.mas_equalTo(80);
        make.centerX.mas_equalTo(0);
        make.bottom.equalTo(labelView.mas_bottom);
    }];
    
    [self.topView addSubview:self.passagerView];
    [self.passagerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.trailing.equalTo(self.topView);
        make.top.equalTo(labelView.mas_bottom);
        make.height.mas_equalTo(kPassengerLabelHeight);
    }];
    
    [self.topView addSubview:self.pickerView];
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.topView);
        make.top.equalTo(self.passagerView.mas_bottom);
        make.bottom.equalTo(self.topView.mas_bottom);
    }];
    [self initPassager];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0 ) {
        return self.adtArrs.count;
    } else if (component == 1) {
        return self.childArrs.count;
    } else {
        return self.infantArrs.count;
    }
}

#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return self.adtArrs[row];
    } else if (component == 1) {
        return self.childArrs[row];
    } else {
        return self.infantArrs[row];
    }
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
}

/**
 乘机人数联动规则： 1个成人最多可携带2个儿童1个婴儿；且成人数+儿童数+婴儿数 <= 9;
 假设成人数为x，儿童数为y，婴儿数为z；则需满足下面三个条件：
 x+y+z<=9 && y<=2x && z<=x
 */
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.adtNumber = self.adtArrs[row];
        NSInteger curTotal = [self.adtNumber integerValue] + [self.childNumber integerValue] + [self.infantNumber integerValue];
        [self.childArrs removeAllObjects];
        [self.infantArrs removeAllObjects];
        if (curTotal >= 9) {
            if (([self.adtNumber integerValue] + [self.childNumber integerValue]) <=9 ) {
                NSInteger maxChild = kMaxTotalNumber - [self.adtNumber integerValue];
                [self resetChildArrWithMax:maxChild];
                NSInteger maxInfant = kMaxTotalNumber - [self.adtNumber integerValue] - [self.childNumber integerValue];
                [self resetInfantArrWithMax:maxInfant];
                [self reloadPickViewComponent];
                [pickerView selectRow:0 inComponent:2 animated:YES];
            } else {
                NSInteger maxChild = kMaxTotalNumber - [self.adtNumber integerValue];
                [self resetChildArrWithMax:maxChild];
                NSInteger maxInfant = kMaxTotalNumber - [self.adtNumber integerValue];
                [self resetInfantArrWithMax:maxInfant];
                [self reloadPickViewComponent];
                [pickerView selectRow:0 inComponent:1 animated:YES];
                [pickerView selectRow:0 inComponent:2 animated:YES];
            }
        } else {// 只需要更新儿童和婴儿的数据源
            NSInteger maxChild = kMaxTotalNumber - [self.adtNumber integerValue];
            NSInteger maxInfant = kMaxTotalNumber - [self.adtNumber integerValue] - [self.childNumber integerValue];
            [self resetChildArrWithMax:maxChild];
            [self resetInfantArrWithMax:maxInfant];
            [self reloadPickViewComponent];
        }
        //reloadComponent后：由于数据源变了--> 需要获取新的选中值
        self.childNumber = self.childArrs[[pickerView selectedRowInComponent:1]];
        self.infantNumber = self.infantArrs[[pickerView selectedRowInComponent:2]];
    } else if(component == 1) {
        self.childNumber = self.childArrs[row];
        // 此处只需要考虑选择儿童后婴儿数的范围；
        [self.infantArrs removeAllObjects];
        NSInteger curMaxInfant = kMaxTotalNumber - [self.adtNumber integerValue] - [self.childNumber integerValue];
        [self resetInfantArrWithMax:curMaxInfant];
        [pickerView reloadComponent:2];
        self.infantNumber = self.infantArrs[[pickerView selectedRowInComponent:2]];
    } else {
        self.infantNumber = self.infantArrs[row];
    }
}

- (void)resetChildArrWithMax:(NSInteger )max {
    if (max > [self.adtNumber integerValue] *2) {
        max = [self.adtNumber integerValue] *2;
    }
    for (int i = 0; i < max + 1; i++) {
        [self.childArrs addObject:[NSString stringWithFormat:@"%ld",i]];
    }
}
- (void)resetInfantArrWithMax:(NSInteger )max {
    if (max > [self.adtNumber integerValue]) {
        max = [self.adtNumber integerValue];
    }
    for (int i = 0; i < max + 1; i++) {
        [self.infantArrs addObject:[NSString stringWithFormat:@"%ld",i]];
    }
}
- (void)reloadPickViewComponent {
    [self.pickerView reloadComponent:1];
    [self.pickerView reloadComponent:2];
}
- (void)showPickerView {
    [self showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)showInView:(UIView *)view {
    [UIView animateWithDuration:0.3 animations:^{
        CGPoint point = self.topView.center;
        point.y -= kShowViewHeight;
        self.topView.center = point;
    } completion:^(BOOL finished) {
    }];
    [view addSubview:self];
}

- (void)cancelChoose:(UIButton *)sender {
    NSMutableDictionary *talkParam = [[NSMutableDictionary alloc] init];
    [talkParam setObject:@"cancel" forKey:@"button"];
    [UIView animateWithDuration:0.2 animations:^{
        CGPoint point = self.topView.center;
        point.y += kShowViewHeight;
        self.topView.center = point;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (void)confirmChoose:(UIButton *)sender {
    NSMutableDictionary *talkParam = [[NSMutableDictionary alloc] init];
    [talkParam setObject:@"ok" forKey:@"button"];
    [UIView animateWithDuration:0.2 animations:^{
        CGPoint point = self.topView.center;
        point.y += kShowViewHeight;
        self.topView.center = point;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        NSMutableArray *passagerArr = [NSMutableArray array];
        [passagerArr addObject:self.adtNumber];
        [passagerArr addObject:self.childNumber];
        [passagerArr addObject:self.infantNumber];
        
        if (self.selectBlock) {
            self.selectBlock(passagerArr);
        }
    }];
}

- (void)initPassager {
    // 乘客类型: 三种
    NSArray *passagerArr = @[@"成人(≥12岁)",@"儿童(2-12岁)",@"婴儿(2周-2岁)"];
    NSMutableArray *labArr = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
//        UILabel *lab = [UIView createLabel:CGRectZero text:passagerArr[i] font:SysFont14 textAligment:NSTextAlignmentCenter textColor:[UIColor grayColor]];
//        [self.passagerView addSubview:lab];
//        [labArr addObject:lab];
    }
    [labArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:CGRectGetWidth([UIScreen mainScreen].bounds)/3 leadSpacing:0 tailSpacing:0];
    [labArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(kPassengerLabelHeight);
    }];
}

#pragma mark - lazy Methods

- (UIView *)passagerView {
    if (!_passagerView) {
        _passagerView = [UIView new];
        _passagerView.backgroundColor = [UIColor clearColor];
    }
    return _passagerView;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
//        _cancelBtn = [UIView createButton:CGRectZero title:@"取消" titleColor:[UIColor whiteColor] font:SysFont16 target:self action:@selector(cancelChoose:)];
    }
    return _cancelBtn;
}
- (UIButton *)conformBtn {
    if (!_conformBtn) {
//        _conformBtn = [UIView createButton:CGRectZero title:@"确定" titleColor:[UIColor whiteColor] font:SysFont16 target:self action:@selector(confirmChoose:)];
    }
    return _conformBtn;
}
- (UILabel *)titleLab {
    if (!_titleLab) {
//        _titleLab = [UIView createLabel:CGRectZero text:@"乘机人选择" font:SysFont16 textAligment:NSTextAlignmentCenter textColor:[UIColor whiteColor]];
        _titleLab.alpha = 0.8;
    }
    return _titleLab;
}

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        [_pickerView setBackgroundColor:[UIColor clearColor]];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.userInteractionEnabled = YES;
        [_pickerView selectRow:0 inComponent:0 animated:YES];
    }
    return _pickerView;
}

- (UIView *)topView {
    if (!_topView) {
//        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, IPHONE_HEIGHT, IPHONE_WIDTH, kShowViewHeight)];
        _topView.backgroundColor = [UIColor whiteColor];
        _topView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesTure = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapNoAction)];
        [_topView addGestureRecognizer:tapGesTure];
    }
    return _topView;
}

@end
