//
//  SelectPanViewController.m
//  testDemo
//
//  Created by lignpeng on 2018/7/11.
//  Copyright © 2018年 genpeng. All rights reserved.
//

#import "SelectPanViewController.h"
#import "Masonry.h"
#import "UILabelsViewController.h"
#import "UIButtonView.h"
#import <CoreMotion/CoreMotion.h>
#import "GPTools.h"
#import "FileTools.h"
#import "HexColor.h"
#import "DataTools.h"
#import "UIEditTextFieldView.h"

@interface SelectPanViewController ()

@property(nonatomic, strong) NSMutableArray *dataSource;

@property(nonatomic, copy) void (^selectActionBlock)();//执行筛选操作
@property(nonatomic, strong) NSMutableArray *itemsArray;//所有数据
@property(nonatomic, strong) NSMutableArray *selectedItemsArray;//筛选出来的数据
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIView *listView;
@property(nonatomic, strong) UIView *resultView;
@property(nonatomic, strong) UIButton *actionButton;//执行按钮
@property(nonatomic, strong) UIButton *labelsButton;//标签管理按钮
@property(nonatomic, strong) UIStepper *stepper;//加减次数
@property(nonatomic, strong) UILabel *numLabel;//展示次数
@property(nonatomic, assign) int actionCount;//次数
@property(nonatomic, strong) dispatch_source_t timer;//定时器
@property(nonatomic, strong) UILabel *bestLabel;//最佳提示
@property(nonatomic, strong) NSMutableArray *bestArray;
@property(nonatomic, assign) BOOL isTurnOnShakeAction;

//动画部分
//列表部分
@property (nonatomic, strong) UIGravityBehavior *listGravity;//重力
@property (nonatomic, strong) UICollisionBehavior *listCollision;//碰撞
@property (nonatomic, strong) UIDynamicAnimator *listAnimator;//动画
@property (nonatomic, strong) UIDynamicItemBehavior *listDynamicItemBehavior;//弹性
//结果部分
@property (nonatomic, strong) UIGravityBehavior *resultGravity;
@property (nonatomic, strong) UICollisionBehavior *resultCollision;
@property (nonatomic, strong) UIDynamicAnimator *resultAnimator;
@property (nonatomic, strong) UIDynamicItemBehavior *resultDynamicItemBehavior;
@property (nonatomic) CMMotionManager *motionManager;
@end

@implementation SelectPanViewController

- (void)initData {
    self.actionCount = 1;
    self.listAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.listView];
    self.listGravity = [[UIGravityBehavior alloc] init];
    [self.listAnimator addBehavior:self.listGravity];
    self.listCollision = [UICollisionBehavior new];
    self.listCollision.translatesReferenceBoundsIntoBoundary = YES;
    [self.listAnimator addBehavior:self.listCollision];
    self.listDynamicItemBehavior = [UIDynamicItemBehavior new];
    self.listDynamicItemBehavior.allowsRotation = YES;//允许旋转
    self.listDynamicItemBehavior.elasticity = 1.0;//弹性
    [self.listAnimator addBehavior:self.listDynamicItemBehavior];
    
    self.resultAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.resultView];
    self.resultGravity = [[UIGravityBehavior alloc] init];
    [self.resultAnimator addBehavior:self.resultGravity];
    self.resultCollision = [UICollisionBehavior new];
    self.resultCollision.translatesReferenceBoundsIntoBoundary = YES;
    [self.resultAnimator addBehavior:self.resultCollision];
    self.resultDynamicItemBehavior = [UIDynamicItemBehavior new];
    self.resultDynamicItemBehavior.allowsRotation = YES;//允许旋转
    self.resultDynamicItemBehavior.elasticity = 1.0;//弹性
    [self.resultAnimator addBehavior:self.resultDynamicItemBehavior];
    [self useGyroPush];
    [self updateActionNum];
    
    if (self.actionResult) {
        for (LabelModel *model in self.actionResult.labels) {
            [self.itemsArray addObject:model];
        }
        for (LabelModel *model in self.actionResult.resultLabels) {
            [self.selectedItemsArray addObject:model];
        }
        [self updateViews];
        self.bestLabel.text = self.actionResult.bestStr;
    }    
}

- (void)updateActionNum {
    self.numLabel.text = [NSString stringWithFormat:@"次数：%2d",self.actionCount];
}

- (void)useGyroPush {
        //初始化全局管理对象
    self.motionManager = [[CMMotionManager alloc]init];
    self.motionManager.deviceMotionUpdateInterval = 0.05;
    
    __weak typeof(self) weakSelf = self;
    [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion *_Nullable motion,NSError * _Nullable error) {
        
//        NSString *yaw = [NSString stringWithFormat:@"%f",motion.attitude.yaw];
//        NSString *pitch = [NSString stringWithFormat:@"%f",motion.attitude.pitch];
//        NSString *roll = [NSString stringWithFormat:@"%f",motion.attitude.roll];
        
        double rotation = atan2(motion.attitude.pitch, motion.attitude.roll);
            //重力角度
        weakSelf.resultGravity.angle = rotation;
        weakSelf.listGravity.angle = rotation;
//        NSLog(@"yaw = %@,pitch = %@, roll = %@,rotation = %fd",yaw,pitch,roll,rotation);
        
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initData];
    
    NSLog(@"%@",[RLMRealmConfiguration defaultConfiguration].fileURL.absoluteString);
    [self startShakeAction];
}

- (void)initView {
    self.title = @"试一试";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAction)];
    CGFloat widht = CGRectGetWidth(self.view.frame);
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    [self.scrollView addSubview:self.listView];
    CGFloat margin = 16;
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(margin);
        make.left.equalTo(self.scrollView).offset(margin);
        make.width.mas_equalTo(widht - margin*2);
        make.height.mas_equalTo(300);
    }];
    
    [self.scrollView addSubview:self.labelsButton];
    [self.labelsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.listView);
        make.right.equalTo(self.listView);
        make.width.mas_equalTo(72);
        make.height.mas_equalTo(32);
    }];
    CGFloat btheight = 42;
    [self.scrollView addSubview:self.actionButton];
    [self.actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.listView.mas_bottom).offset(margin * 0.5);
        make.left.equalTo(self.scrollView).offset(margin*1.5);
        make.width.mas_equalTo(widht*0.5 - margin*3.5);
        make.height.mas_equalTo(btheight);
    }];
    
    [self.scrollView addSubview:self.numLabel];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.actionButton);
        make.left.equalTo(self.actionButton.mas_right).offset(margin*0.5);
        make.height.mas_equalTo(btheight);
    }];
    
    
    [self.scrollView addSubview:self.stepper];
    [self.stepper mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.listView.mas_bottom).offset(margin * 0.5 + (btheight - 28)*0.5);
        make.trailing.equalTo(self.scrollView);
        make.left.equalTo(self.numLabel.mas_right).offset(margin*0.5);
        make.width.mas_equalTo(margin*4);
        make.height.mas_equalTo(28);
    }];
    
    [self.scrollView addSubview:self.resultView];
    [self.resultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.actionButton.mas_bottom).offset(margin * 0.5);
        make.left.equalTo(self.scrollView).offset(margin);
        make.width.mas_equalTo(widht - margin*2);
        make.height.mas_equalTo(120);
    }];
    
    [self.scrollView addSubview:self.bestLabel];
    [self.bestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.resultView);
        make.right.equalTo(self.resultView).offset(-56);
        make.height.mas_equalTo(32);
    }];
    
    UIButton *clearButton = [GPTools createButton:@"清空" titleFont:[UIFont systemFontOfSize:14] corner:5 target:self action:@selector(clearResult)];
    [self.scrollView addSubview:clearButton];
    [clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.resultView);
        make.right.equalTo(self.resultView);
        make.width.mas_equalTo(72);
        make.height.mas_equalTo(32);
    }];
    [self.view layoutIfNeeded];
}

- (void)viewDidLayoutSubviews {
    CGRect rframe = self.resultView.frame;
    CGRect sframe = self.scrollView.frame;
    CGFloat height = CGRectGetHeight(rframe) + CGRectGetMinY(rframe);
    self.scrollView.contentSize = (CGSize){CGRectGetWidth(sframe),height};
}

#pragma mark - 摇一摇
- (void)startShakeAction {
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    [self becomeFirstResponder];
    self.isTurnOnShakeAction = YES;
}

- (void)endShakeAction {
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = NO;
    [self resignFirstResponder];
    self.isTurnOnShakeAction = NO;
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.subtype == UIEventSubtypeMotionShake && self.isTurnOnShakeAction) { // 判断是否是摇动结束
        NSLog(@"摇动结束");
        [self dealWithSelect];
    }
}

//保存到数据库



- (void)saveAction {
    if (self.itemsArray.count == 0) {
        return;
    }
    
    if (self.actionResult == nil || self.actionResult.name.length == 0) {
        __weak typeof(self) weakSelf = self;
        [UIEditTextFieldView editTextFieldWithTitle:@"起个名吧~！" editStr:self.bestLabel.text complish:^(NSString *text) {
            [weakSelf saveAction:text];
        } cancelBlock:^{
            [weakSelf saveAction:nil];
        }];
    }else {
        [self saveAction:nil];
    }
}

- (void)saveAction:(NSString *)name {
    if (self.actionResult == nil) {
        self.actionResult = [[ActionResult alloc] init];
        NSDate *today = [NSDate date];
        NSDateFormatter *dateFormater = [NSDateFormatter new];
        dateFormater.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        self.actionResult.date = [dateFormater stringFromDate:today];
        if (name.length > 0) {
            self.actionResult.name = name;
        }else {
            self.actionResult.name = self.bestLabel.text.length > 0 ? self.bestLabel.text:@"";
        }
        [self.actionResult.labels addObjects:self.itemsArray];
        [self.actionResult.resultLabels addObjects:self.selectedItemsArray];
    }
    //清理不存在的标签
    [FileTools removeObjOrignArray:self.itemsArray filterArray:self.actionResult.labels];
    [FileTools removeObjOrignArray:self.selectedItemsArray filterArray:self.actionResult.resultLabels];
    //添加新增的标签
    [FileTools addObjOrignArray:self.itemsArray targetArray:self.actionResult.labels];
    [FileTools addObjOrignArray:self.selectedItemsArray targetArray:self.actionResult.resultLabels];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    self.actionResult.bestStr = self.bestLabel.text.length > 0 ? self.bestLabel.text:@"";
    if (self.actionResult.name.length == 0) {
        if (name.length > 0) {
            self.actionResult.name = name;
        }else {
            self.actionResult.name = self.actionResult.bestStr;
        }
    }
    [realm commitWriteTransaction];
    [FileTools addObjectToDB:self.actionResult];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 添加标签
- (void)addAction {
    __weak typeof(self) weakSelf = self;
    UILabelsViewController *vc = [UILabelsViewController labelsViewControllerWith:self.itemsArray complishBlock:^(NSArray *items) {
        [weakSelf.itemsArray removeAllObjects];
        if (items.count > 0) {
            [weakSelf.itemsArray addObjectsFromArray:items];
            [weakSelf updateViews];
        }
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)stepperAction {
    self.actionCount = self.stepper.value + 1;
    [self updateActionNum];
}

- (void)updateViews {
    [self updateListViews];
    [self updateResultViews];
}

- (void)updateListViews {
    NSArray *listItems = [self.listView subviews];
    for (UIView *item in listItems) {
        [item removeFromSuperview];
        [self removeListBehavior:item];
    }

    for (LabelModel *model in self.itemsArray) {
        [self createBullWith:model superView:self.listView action:@selector(addListBehavior:)];
    }
}

- (void)updateResultViews {
    for (UIView *item in [self.resultView subviews]) {
        [item removeFromSuperview];
        [self removeResultBehavior:item];
    }
    for (LabelModel *model in self.selectedItemsArray) {
        [self createBullWith:model superView:self.resultView action:@selector(addResultBehavior:)];
    }
}

- (void)createBullWith:(LabelModel *)model superView:(UIView *)superView action:(nullable SEL)action{
    CGFloat widht = 64;
    CGRect frame = (CGRect){arc4random()%((int)(CGRectGetWidth(superView.frame) - widht)),0,widht,widht};
    UIView *ball = [UIButtonView buttonViewWithFrame:frame Model:model];
    [superView addSubview:ball];
    if ([self respondsToSelector:action]) {
        [self performSelector:action withObject:ball];
    }
}

- (void)removeListBehavior:(id)item {
    [self.listCollision removeItem:item];
    [self.listGravity removeItem:item];
    [self.listDynamicItemBehavior removeItem:item];
}

- (void)addListBehavior:(id)item {
    [self.listCollision addItem:item];
    [self.listGravity addItem:item];
    [self.listDynamicItemBehavior addItem:item];
}

- (void)removeResultBehavior:(id)item {
    [self.resultCollision removeItem:item];
    [self.resultGravity removeItem:item];
    [self.resultDynamicItemBehavior removeItem:item];
}

- (void)addResultBehavior:(id)item {
    [self.resultCollision addItem:item];
    [self.resultGravity addItem:item];
    [self.resultDynamicItemBehavior addItem:item];
}

#pragma mark - 筛选
//清理筛选结果
- (void)clearResult {
    [self.selectedItemsArray removeAllObjects];
    [self.bestArray removeAllObjects];
    self.bestLabel.text = @"最佳：";
    [self updateResultViews];
}

- (void)selectAction {
    if (self.itemsArray.count <=0) {
        return;
    }
    [self endShakeAction];
    self.actionButton.backgroundColor = [UIColor grayColor];
    self.actionButton.enabled = NO;
    [self clearResult];
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, NULL, NULL, dispatch_get_global_queue(0, 0));
    float tt = 1.5;
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, tt * NSEC_PER_SEC);//开始时间:从现在开始1.5秒后开始
    dispatch_source_set_timer(self.timer, start, (int64_t)(tt * NSEC_PER_SEC), 0);
    
//3. 设置定时器的回调
    __block int count = self.actionCount;
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(self.timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf dealWithSelect];
        });
        count--;
        if (count == 0) { // 执行4次,让定时器取消
            dispatch_cancel(weakSelf.timer);
            weakSelf.timer = nil; // 置空,因为是强引用
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.actionButton.backgroundColor = [UIColor colorWithRed:21.0/256.0 green:126.0/256.0 blue:251.0/256.0 alpha:1];
                weakSelf.actionButton.enabled = YES;
                [weakSelf startShakeAction];
            });
        }
    });
//4.启动定时器: GCD定时器默认是暂停的
    dispatch_resume(self.timer);
}

//筛选操作
- (void)dealWithSelect {
    NSLog(@"----- log -----");
    if (self.itemsArray.count <= 0) {
        return;
    }
    LabelModel *label = self.itemsArray[arc4random() % self.itemsArray.count];
    [self.selectedItemsArray addObject:label];
    [self createBullWith:label superView:self.resultView action:@selector(addResultBehavior:)];
    self.bestLabel.text = [self bestModel];
}

- (NSString *)bestModel {
    NSArray *array = [DataTools filterMaxItemsArray:self.selectedItemsArray isStringObj:NO filterKey:[LabelModel primaryKey]];
    if (array.count <= 0) {
        return nil;
    }
    //1、选出最大数
    NSInteger max = ((NSArray *)array[0]).count;
    NSInteger index = 0;
    for (int i = 0; i < array.count; i++) {
        NSInteger d = ((NSArray *)array[i]).count;
        if (max < d) {
            max = d;
            index = i;
        }
    }
    //2、相同个数的情况
    NSMutableArray *indexArray = [NSMutableArray array];
    for (int i = 0; i < array.count; i++) {
        NSInteger d = ((NSArray *)array[i]).count;
        if (max == d) {
            [indexArray addObject:@(i)];
        }
    }
    NSString *best = @"最佳：";
    [self.bestArray removeAllObjects];
    for (int i = 0; i < indexArray.count; i++) {
        NSArray *tempArray = (NSArray *)array[i];
        LabelModel *label = tempArray.firstObject;
        [self.bestArray addObject:label];
        best = [best stringByAppendingFormat:@"%@%@",(i == 0)?@"":@"、",label.name];
    }
    return best;
}

- (void)stopSelectAction {
    dispatch_cancel(self.selectActionBlock);
}

#pragma mark - 懒加载

- (void)dealloc {
    if (self.timer) {
        dispatch_cancel(self.timer);
    }
    self.timer = nil; // 置空,因为是强引用
}

- (NSMutableArray *)selectedItemsArray {
    if (!_selectedItemsArray) {
        _selectedItemsArray = [NSMutableArray array];
    }
    return _selectedItemsArray;
}

- (NSMutableArray *)itemsArray {
    if (!_itemsArray) {
        _itemsArray = [NSMutableArray array];
    }
    return _itemsArray;
}

- (NSMutableArray *)bestArray {
    if (!_bestArray) {
        _bestArray = [NSMutableArray array];
    }
    return _bestArray;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (UIStepper *)stepper {
    if (!_stepper) {
        _stepper = [[UIStepper alloc] init];
        _stepper.backgroundColor = [UIColor whiteColor];
        _stepper.continuous = NO;//禁止长按连续触
        _stepper.autorepeat = NO;//一次点击只会改变一次值
        _stepper.minimumValue = 0;
        _stepper.maximumValue = 98;
        _stepper.stepValue = 1;
        [_stepper addTarget:self action:@selector(stepperAction) forControlEvents:UIControlEventValueChanged];
    }
    return _stepper;
}

- (UILabel *)numLabel {
    if (!_numLabel) {
        _numLabel = [UILabel new];
        _numLabel.textColor = [UIColor darkTextColor];
        _numLabel.textAlignment = NSTextAlignmentCenter;
        _numLabel.font = [UIFont systemFontOfSize:14];
        _numLabel.backgroundColor = [UIColor whiteColor];
    }
    return _numLabel;
}

- (UILabel *)bestLabel {
    if (!_bestLabel) {
        _bestLabel = [UILabel new];
        _bestLabel.textColor = [UIColor redColor];
        _bestLabel.textAlignment = NSTextAlignmentCenter;
//        _bestLabel.font = [UIFont systemFontOfSize:14];
        _bestLabel.font = [UIFont boldSystemFontOfSize:14];
        _bestLabel.backgroundColor = [UIColor clearColor];
    }
    return _bestLabel;
}

- (UIButton *)actionButton {
    if (!_actionButton) {
        _actionButton = [GPTools createButton:@"执行" titleFont:[UIFont systemFontOfSize:14] corner:5 target:self action:@selector(selectAction)];
        _actionButton.backgroundColor = [UIColor colorWithRed:21.0/256.0 green:126.0/256.0 blue:251.0/256.0 alpha:1];
    }
    return _actionButton;
}

- (UIButton *)labelsButton {
    if (!_labelsButton) {
        _labelsButton = [GPTools createButton:@"标签管理" titleFont:[UIFont systemFontOfSize:14] corner:5 target:self action:@selector(addAction)];
    }
    return _labelsButton;
}

- (void)clipCorner:(UIView *)view corner:(CGFloat)radius{
    view.layer.cornerRadius = radius;
    view.clipsToBounds = YES;
}

- (UIView *)listView {
    if (!_listView) {
        _listView = [UIView new];
        _listView.backgroundColor = [UIColor colorWith8BitRedN:153 green:209 blue:141];
        [self clipCorner:_listView corner:5];
    }
    return _listView;
}

- (UIView *)resultView {
    if (!_resultView) {
        _resultView = [UIView new];
        [self clipCorner:_resultView corner:5];
        _resultView.backgroundColor = [UIColor orangeColor];
    }
    return _resultView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.bounces = YES;
        _scrollView.frame = (CGRect){0,0,120,120};
//        _scrollView.contentSize = [UIScreen mainScreen].bounds.size;
        _scrollView.alwaysBounceVertical = YES;
        _scrollView.alwaysBounceHorizontal = NO;
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

@end
