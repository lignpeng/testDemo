//
//  RiseUpCalcViewController.m
//  testDemo
//
//  Created by lignpeng on 2018/7/10.
//  Copyright © 2018年 genpeng. All rights reserved.
//
//1）起始值：输入框
//2）利率：输入框，滑杆
//3）次数：输入框，滑杆
//4）输出：列表，多少次就多少条
#import "RiseUpCalcViewController.h"
#import "RiseupCalcHeaderView.h"

@interface RiseUpCalcViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSString *resultStr;
@property(nonatomic, assign) float sum;
@property(nonatomic, assign) float rise;
@property(nonatomic, assign) NSUInteger num;

@end

@implementation RiseUpCalcViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initData {
    self.sum = 0;
    self.rise = 0;
    self.num = 0;
}

- (void)calc {
    float ss = self.sum;
    self.resultStr = @"";
    float dd = 1.0;
    for (int i = 1; i <= self.num; i++) {
        ss = ss * (1 + self.rise/100.0);
        dd = ss/self.sum;
        self.resultStr = [self.resultStr stringByAppendingFormat:@"%d）倍:%.3f 总:%.2f\n",i,dd,ss];
    }
    NSLog(@"-- %@",self.resultStr);
//    [self.tableView reloadData];
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
//    CGFloat margin = 32;
//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(margin, margin * 3, CGRectGetWidth([UIScreen mainScreen].bounds) - margin * 2, 42)];
//    [button addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
//    [button setTitle:@"action" forState:UIControlStateNormal];
//    button.backgroundColor = [UIColor colorWithRed:3/255.0 green:223/255.0 blue:71/255.0 alpha:1];
//    button.layer.cornerRadius = 5;
//    button.clipsToBounds = YES;
//    [self.view addSubview:button];
//
//    RiseupCalcHeaderView *headerView = [RiseupCalcHeaderView riseupCalcHeaderView];
//    CGFloat swidht = CGRectGetWidth([UIScreen mainScreen].bounds);
//    headerView.frame = (CGRect){0,100,swidht,120};
    [self.view addSubview:self.tableView];
    self.tableView.frame = self.view.bounds;
}

- (void)action {
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    RiseupCalcHeaderView *headerView = [RiseupCalcHeaderView riseupCalcHeaderView];
    CGFloat swidht = CGRectGetWidth([UIScreen mainScreen].bounds);
    headerView.frame = (CGRect){0,100,swidht,120};
    __weak typeof(self) weakSelf = self;
    headerView.editBlock = ^(NSString *sumStr, NSString *riseStr, NSString *numStr,BOOL flag) {
        weakSelf.sum = [sumStr floatValue];
        weakSelf.rise = [riseStr floatValue];
        weakSelf.num = [numStr integerValue];
        [weakSelf calc];
        if (flag) {
            [weakSelf.view endEditing:YES];
        }
    };
//    headerView.actionBlock = ^(NSString *sumStr, NSString *riseStr, NSString *numStr){
//        weakSelf.sum = [sumStr floatValue];
//        weakSelf.rise = [riseStr floatValue];
//        weakSelf.num = [numStr integerValue];
//        [weakSelf calc];
//    };
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = [UIColor grayColor];
    cell.textLabel.text = self.resultStr;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UIFont *font = [UIFont systemFontOfSize:14];
    CGSize titleSize = [self.resultStr boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.view.frame) -16*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
//    NSLog(@"height = %f",titleSize.height);
    return titleSize.height + 16;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 120;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = [UIView new];
        _tableView.tableFooterView = [self footerview];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 32;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

- (UIView *)footerview {
    CGFloat height = 24;
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,CGRectGetWidth([UIScreen mainScreen].bounds),height}];
    
//    UIView *sepView = [[UIView alloc] initWithFrame:(CGRect){0,height - 1,CGRectGetWidth([UIScreen mainScreen].bounds),1}];
//    sepView.backgroundColor = [UIColor darkTextColor];
//    [view addSubview:sepView];
    return view;
}

@end
