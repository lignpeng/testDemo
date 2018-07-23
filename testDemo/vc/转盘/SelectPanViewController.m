//
//  SelectPanViewController.m
//  testDemo
//
//  Created by lignpeng on 2018/7/11.
//  Copyright © 2018年 genpeng. All rights reserved.
//

#import "SelectPanViewController.h"
#import "LabelModel.h"
#import "Masonry.h"
#import "UILabelsViewController.h"
#import "UIButtonView.h"
#import <CoreMotion/CoreMotion.h>
#import "GPTools.h"

@interface SelectPanViewController ()

@property(nonatomic, strong) NSMutableArray *dataSource;

@property(nonatomic, copy) void (^selectActionBlock)();//执行筛选操作
@property(nonatomic, strong) NSMutableArray *itemsArray;//所有数据
@property(nonatomic, strong) NSMutableArray *selectedItemsArray;//筛选出来的数据
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIView *listView;
@property(nonatomic, strong) UIView *resultView;
@property(nonatomic, strong) UIButton *actionButton;
@property(nonatomic, strong) UIButton *labelsButton;
@property(nonatomic, strong) UIStepper *stepper;
@property(nonatomic, strong) UILabel *numLabel;
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
}

- (void)initView {
    self.title = @"试一试";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAction)];
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
    
    [self.scrollView addSubview:self.actionButton];
    [self.actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.listView.mas_bottom).offset(margin * 0.5);
        make.left.equalTo(self.scrollView).offset(margin*3);
        make.width.mas_equalTo(widht*0.5 - margin*4);
        make.height.mas_equalTo(42);
    }];
    
    [self.scrollView addSubview:self.numLabel];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.actionButton);
        make.left.equalTo(self.actionButton.mas_right).offset(margin);
        make.width.mas_equalTo(margin*2);
        make.height.mas_equalTo(42);
    }];
    
    [self.scrollView addSubview:self.stepper];
    [self.stepper mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.actionButton);
        make.right.equalTo(self.scrollView).offset(margin*2);
        make.left.equalTo(self.numLabel.mas_right).offset(margin);
//        make.width.mas_equalTo(widht*0.5 - margin*4);
        make.height.mas_equalTo(28);
    }];
    
    [self.scrollView addSubview:self.resultView];
    [self.resultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.actionButton.mas_bottom).offset(margin * 0.5);
        make.left.equalTo(self.scrollView).offset(margin);
        make.width.mas_equalTo(widht - margin*2);
        make.height.mas_equalTo(120);
    }];
    [self.view layoutIfNeeded];
}

- (void)viewDidLayoutSubviews {
    CGRect rframe = self.resultView.frame;
    CGRect sframe = self.scrollView.frame;
    CGFloat height = CGRectGetHeight(rframe) + CGRectGetMinY(rframe);
    self.scrollView.contentSize = (CGSize){CGRectGetWidth(sframe),height};
}

//添加标签
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

- (void)selectAction {
    [self.selectedItemsArray removeAllObjects];
    [self updateResultViews];
    __weak typeof(self) weakSelf = self;
    self.selectActionBlock = dispatch_block_create(0, ^{
        [weakSelf dealWithSelect];
    });
    [self.selectedItemsArray removeAllObjects];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5 * NSEC_PER_SEC),dispatch_get_main_queue(), self.selectActionBlock);
}

- (void)dealWithSelect {
    NSLog(@"----- log -----");
    if (self.itemsArray.count <=0) {
        return;
    }
    LabelModel *label = self.itemsArray[arc4random() % self.itemsArray.count];
    [self.selectedItemsArray addObject:label];
    [self createBullWith:label superView:self.resultView action:@selector(addResultBehavior:)];
}

- (void)stopSelectAction {
    dispatch_cancel(self.selectActionBlock);
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
        _listView.backgroundColor = [UIColor lightGrayColor];
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
