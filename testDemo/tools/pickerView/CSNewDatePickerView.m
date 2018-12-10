//
//  CSNewDatePickerView.m
//  CSMBP
//
//  Created by lignpeng on 2017/7/28.
//   
//

#import "CSNewDatePickerView.h"
#import "Masonry.h"
#import "NSDate+Display.h"
#import "NSDate+CSCalendar.h"
#import "HexColor.h"

static const CGFloat kHolderViewHeight = 250.0f;//选择器总高度
static const CGFloat kBarViewHeight = 50.0f;//bar条高度
static const CGFloat kButtonWidth = 72.0f;//按钮宽度
static const NSTimeInterval kAnimationDuration = 0.25f;
static const CGFloat kPickerViewHeight = 42.0f;//选择器高度
#import "GGMacors.h"
#define kBackViewWidth IPHONE_WIDTH
#define kBackViewHeight IPHONE_HEIGHT-20
#define kMinYear 1800
#define kMaxYear 2200
#define kCycleNum 9000
#define kPicker(_N_) [self.pickerView selectedRowInComponent:_N_]
#define kYearInt [self yearFromRow: [self.pickerView selectedRowInComponent:myYearComponent]]
#define kMonthInt [self monthFromRow: [self.pickerView selectedRowInComponent:myMonthComponent]]

@interface CSNewDatePickerView()<UIPickerViewDelegate,UIPickerViewDataSource>{
    NSDate *_presentDate, *_minDate, *_maxDate;
    NSInteger myYearComponent, myMonthComponent, myDayComponent;
    CGFloat myYearWidth, myMonthWidth, myDayWidth;
    NSLocale *currentLocale;
    NSString *_customFlag;
}

@property(nonatomic, strong) UIPickerView *pickerView;
@property(nonatomic, strong) UILabel  *titleLabel;
@property(nonatomic, strong) UIButton *cancelButton;
@property(nonatomic, strong) UIButton *okButton;
@property(nonatomic, strong) UIView *holderView;
@property(nonatomic, strong) NSArray *dataSource;
@property(nonatomic, strong) NSString *key;
@property(nonatomic, assign) BOOL isDictionary;

@property(nonatomic, strong) NSDate *presentDate, *minDate, *maxDate;
@property(nonatomic, assign) BOOL noDayColumns;
@property(nonatomic, strong) NSString *customFlag;

@property(nonatomic, assign) BOOL isNewFlihtBooking;//新版预定流用属性

@end

@implementation CSNewDatePickerView

+ (instancetype)datePickerView {
    CSNewDatePickerView *view = [[CSNewDatePickerView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [view show];
    return view;
}

+ (instancetype)datePickerViewWithPresentDate:(NSDate *)presentDate andMinDate:(NSDate *)minDate andMaxDate:(NSDate *)maxDate andTitle:(NSString *)title andFlag:(NSString *)aFlag complishBlock:(void (^)(NSDate *, NSString *))complishBlock {
    CSNewDatePickerView *view = [self datePickerView];
    view.complishBlock = complishBlock;
    if(!presentDate) {
        presentDate = [[NSDate date] dateByAddingTimeInterval:(24*3600l)];
    }
    view.presentDate = presentDate;
    view.minDate = minDate ? minDate:view.minDate;
    view.maxDate = maxDate ? maxDate:view.maxDate;
    view.customFlag = aFlag;
    view.titleLabel.text = title;
    [view initPickerWithDate:view.presentDate];
    [view.pickerView reloadAllComponents];
    return view;
}

+ (instancetype)datePickerViewWithPresentDate:(NSDate *)presentDate andMinDate:(NSDate *)minDate andMaxDate:(NSDate *)maxDate andFlag:(NSString *)aFlag isNewFlightBooking:(BOOL)isNewFlightBooking complishBlock:(void(^)(NSDate *aDate, NSString *aFlag))complishBlock {
    
    CSNewDatePickerView *view = [self datePickerView];
    view.isNewFlihtBooking = isNewFlightBooking;
    view.complishBlock = complishBlock;
    if(!presentDate) {
        presentDate = [[NSDate date] dateByAddingTimeInterval:(24*3600l)];
    }
    view.presentDate = presentDate;
    view.minDate = minDate ? minDate:view.minDate;
    view.maxDate = maxDate ? maxDate:view.maxDate;
    view.customFlag = aFlag;
    [view initPickerWithDate:view.presentDate];
    [view.pickerView reloadAllComponents];
    return view;
}

+ (void)dissmiss {
    UIWindow *windowView = [[UIApplication sharedApplication] keyWindow];
    for (UIView *subView in windowView.subviews) {
        if ([subView isMemberOfClass:[CSNewDatePickerView class]]) {
            [(CSNewDatePickerView *)subView dismiss];
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

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor colorWithHexString:@"798691"];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
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
        [_okButton setTitle:NSLocalizedString(@"Confirm Done",@"完成") forState:UIControlStateNormal];
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
    [self initData];
    [self.holderView addSubview:self.cancelButton];
    [self.holderView addSubview:self.okButton];
    [self.holderView addSubview:self.titleLabel];
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
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.holderView);
        make.bottom.mas_equalTo(self.pickerView.mas_top);
        make.left.mas_equalTo(self.cancelButton.mas_right);
        make.right.mas_equalTo(self.okButton.mas_left);
    }];
}

- (void)initData {
    self.presentDate = [NSDate date];
    self.minDate = [self dateFromYear:kMinYear month:01 day:01];
    self.maxDate = [self dateFromYear:kMaxYear month:12 day:31];
    NSString *localeStr = @"";
    localeStr = localeStr? localeStr: @"zh-Hans";
    currentLocale = [[NSLocale alloc] initWithLocaleIdentifier:localeStr];
    if ([localeStr isEqualToString:@"zh-Hans"]) {
        //中文简体
        myYearComponent = 0;
        myMonthComponent = 1;
        myDayComponent = 2;
        myYearWidth = 120;
        myMonthWidth = 90;
        myDayWidth = 70;
    }else if ([localeStr isEqualToString:@"en"]) {
        myMonthComponent = 0;
        myDayComponent = 1;
        myYearComponent = 2;
        myMonthWidth = 140;
        myDayWidth = 50;
        myYearWidth = 90;
    }
    self.noDayColumns = NO;
}

- (void)cancelAction {
    [self dismiss];
}

- (void)okAction {
    if (self.complishBlock) {
        self.complishBlock(self.presentDate, self.customFlag);
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
    //    [self.pickerView selectRow:self.selectRow inComponent:0 animated:YES];
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


-(void)setPresentDate:(NSDate *)presentDate {
    NSString *str = [NSDate stringFromDate:presentDate format:@"yyyy-MM-dd"];
    _presentDate = [NSDate dateFromString:str format:@"yyyy-MM-dd"];
}

-(void)setMinDate:(NSDate *)minDate {
    NSString *str = [NSDate stringFromDate:minDate format:@"yyyy-MM-dd"];
    _minDate = [NSDate dateFromString:str format:@"yyyy-MM-dd"];
}

-(void)setMaxDate:(NSDate *)maxDate {
    NSString *str = [NSDate stringFromDate:maxDate format:@"yyyy-MM-dd"];
    _maxDate = [NSDate dateFromString:str format:@"yyyy-MM-dd"];
}

- (void)configureWithPresentDate:(NSDate *)presentDate andMinDate:(NSDate *)minDate andMaxDate:(NSDate *)maxDate andFlag:(NSString *)aFlag{
    if(!presentDate)
        presentDate = [[NSDate date] dateByAddingTimeInterval:(24*3600l)];
    self.presentDate = presentDate;
    self.minDate = minDate? minDate: self.minDate;
    self.maxDate = maxDate? maxDate:self.maxDate;
    self.customFlag = aFlag;
    [self initPickerWithDate:self.presentDate];
    [self.pickerView reloadAllComponents];
}

#pragma mark 本地化相关
- (NSString *)localYear:(NSInteger)yearInt {
    NSString *yearStr = [NSString stringWithFormat:@"%04ld", yearInt];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    [formatter setCalendar:[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian]];
    NSDate *aDate = [formatter dateFromString:yearStr];
    
    [formatter setLocale:currentLocale];
    [formatter setDateFormat:@"yyyy"];
    yearStr = [formatter stringFromDate:aDate];
    
    if ([[currentLocale localeIdentifier] isEqualToString:@"zh-Hans"]) {
        yearStr = [yearStr stringByAppendingString:@"年"];
    }
    return yearStr;
}
- (NSString *)localMonth:(NSInteger)monthInt {
    NSString *monthStr = [NSString stringWithFormat:@"%02ld", monthInt];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setCalendar:[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian]];
    [formatter setDateFormat:@"MM"];
    NSDate *aDate = [formatter dateFromString:monthStr];
    
    if (self.isNewFlihtBooking) {
        [formatter setLocale:currentLocale];
        [formatter setDateFormat:@"M"];
        monthStr = [formatter stringFromDate:aDate];
        monthStr = [monthStr stringByAppendingString:@"月"];
    }
    else {
        [formatter setLocale:currentLocale];
        [formatter setDateFormat:@"MMMM"];
        monthStr = [formatter stringFromDate:aDate];
    }
    
    return monthStr;
}
- (NSString *)localDay:(NSInteger)dayInt {
    NSString *dayStr = [NSString stringWithFormat:@"%02ld", dayInt];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setCalendar:[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian]];
    [formatter setDateFormat:@"DD"];
    NSDate *aDate = [formatter dateFromString:dayStr];
    
    [formatter setLocale:currentLocale];
    [formatter setDateFormat:@"DD"];
    dayStr = [formatter stringFromDate:aDate];
    
    if ([[currentLocale localeIdentifier] isEqualToString:@"zh-Hans"]) {
        dayStr = [dayStr stringByAppendingString:@"日"];
    }
    return dayStr;
}
#pragma Other
//实际Row与表现‘年月日’之间的数值转换
- (NSInteger)yearFromRow:(NSInteger)aRow {
    return (kMinYear +aRow);
}
- (NSInteger)monthFromRow:(NSInteger)aRow {
    return (aRow%12 +1);
}
- (NSInteger)dayFromRow:(NSInteger)aRow {
    return (aRow%31 +1);
}

//设置Picker选中时间为aDate
- (void)initPickerWithDate:(NSDate *)aDate {
    //设置显示的日期
    NSInteger newYear = [aDate year];
    NSInteger newMonth = [aDate month];
    NSInteger newDay = [aDate day];
    
    [self.pickerView selectRow:(newYear - kMinYear) inComponent:myYearComponent animated:NO];
    [self.pickerView selectRow:(newMonth + kCycleNum/2 - (kCycleNum/2)%12 -1) inComponent:myMonthComponent animated:NO];
    
    if(!self.noDayColumns){
        [self.pickerView selectRow:(newDay + kCycleNum/2 - (kCycleNum/2)%31 -1) inComponent:myDayComponent animated:NO];
    }
}

//判断aDay超过当点Picker显示的月份中最大日期多少天
- (NSInteger)beyondDay:(NSInteger)aDay {
    NSInteger maxDay = [self numDaysInMonth:self.presentDate.month andYear:self.presentDate.year];;
    return aDay - maxDay;
}

//由年月日，返回Date对象
- (NSDate *)dateFromYear:(NSInteger)aYear month:(NSInteger)aMonth day:(NSInteger)aDay {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyyMMdd"];
    [df setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    [df setCalendar:[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian]];
    
    NSInteger maxDay = [self numDaysInMonth:aMonth andYear:aYear];
    aDay = aDay > maxDay? maxDay: aDay;
    
    NSString *dateStr = [NSString stringWithFormat:@"%04ld%02ld%02ld", aYear, aMonth, aDay];
    NSDate *date = [df dateFromString:dateStr];
    
    return date;
}

//aYear年aMonth月中有多少天
- (NSInteger)numDaysInMonth:(NSInteger)aMonth andYear:(NSInteger)aYear {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyyMMdd"];
    [df setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    [df setCalendar:[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian]];
    
    NSString *tempDateStr = [NSString stringWithFormat:@"%04ld%02ld15", aYear, aMonth];
    NSDate *tempDate = [df dateFromString:tempDateStr];
    return [NSDate numberOfDaysInMonth:tempDate];
}

#pragma mark UIPickerViewDataSource
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return self.noDayColumns ? 2 : 3;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == myYearComponent) {
        return kMaxYear - kMinYear;
    }else if (component == myMonthComponent) {
        return kCycleNum;
    }else {
        return kCycleNum;
    }
}

#pragma mark UIPickerViewDelegate

// returns width of column and height of row for each component.
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    if (component == myYearComponent) {
        return myYearWidth;
    }else if (component == myMonthComponent) {
        return myMonthWidth;
    }
    return myDayWidth;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    CGRect aRect;
    NSString *titleStr;
    //    NSDate *today = [NSDate date];
    UILabel *aLabel = [[UILabel alloc] init];
    aLabel.backgroundColor = [UIColor clearColor];
    aLabel.textAlignment = NSTextAlignmentCenter;
    aLabel.font = [UIFont systemFontOfSize:16.0];
    aLabel.textColor = RgbColor(0, 35, 78);
    if (component == myYearComponent) {
        aRect = CGRectMake(20, 5, myYearWidth, 30);
        titleStr = [self localYear:[self yearFromRow:row]];
    }else if (component == myMonthComponent) {
        aRect = CGRectMake(20, 5, myMonthWidth, 30);
        titleStr = [self localMonth:[self monthFromRow:row]];
    }else {
        aRect = CGRectMake(20, 5, myDayWidth, 30);
        titleStr = [self localDay:[self dayFromRow:row]];
    }
    for (UIView *subView in pickerView.subviews) {
        if (CGRectGetHeight(subView.frame) < 1) {
            subView.backgroundColor = RgbColor(209, 217, 224);
        }
    }
    aLabel.frame = aRect;
    aLabel.text = titleStr;
    return aLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    NSDate *aDate = [self dateFromYear:kYearInt month:kMonthInt day:[self kDayInt]];
    
    if (aDate.year < self.minDate.year ||
        (aDate.year == self.minDate.year && aDate.month < self.minDate.month) ||
        (aDate.year == self.minDate.year && aDate.month == self.minDate.month && aDate.day < self.minDate.day)) {
        aDate = [self dateFromYear:self.minDate.year month:self.minDate.month day:self.minDate.day];
    }else if (aDate.year > self.maxDate.year ||
              (aDate.year == self.maxDate.year && aDate.month > self.maxDate.month) ||
              (aDate.year == self.maxDate.year && aDate.month == self.maxDate.month && aDate.day > self.maxDate.day)) {
        aDate = [self dateFromYear:self.maxDate.year month:self.maxDate.month day:self.maxDate.day];
    }
    self.presentDate = aDate;
    
    NSInteger selectRow = (kPicker(myYearComponent) - kYearInt + aDate.year);
    [self.pickerView selectRow:selectRow inComponent:myYearComponent animated:YES];
    [self.pickerView selectRow:(kPicker(myMonthComponent) - kMonthInt + aDate.month) inComponent:myMonthComponent animated:YES];
    
    if(!self.noDayColumns){
        [self.pickerView selectRow:(kPicker(myDayComponent) - [self kDayInt] + aDate.day) inComponent:myDayComponent animated:YES];
    }
    
    [self.pickerView reloadAllComponents];
}

- (NSInteger)kDayInt{
    if(!self.noDayColumns)
        return [self dayFromRow: [self.pickerView selectedRowInComponent:myDayComponent]];
    else
        return 01;
}

@end

