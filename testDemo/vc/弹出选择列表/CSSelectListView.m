//
//  CSSelectListView.m
//  testDemo
//
//  Created by lignpeng on 2017/9/5.
//  Copyright © 2017年 genpeng. All rights reserved.
//

#import "CSSelectListView.h"
#import "Masonry.h"

#define viewAlpha 0.3
#define viewMargin 0
#define cellHeight 45
#define tableviewWidht 150

@interface CSSelectListView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGSize preferredContentSize;
@property (nonatomic, strong) NSArray *dataSource;
@property(nonatomic, weak) UIViewController *delegate;
@property(nonatomic, copy) void(^complishBlock)(NSString *str);

@end

@implementation CSSelectListView

+ (void)showSelectListViewWithDataSoucre:(NSArray *)dataSource SourceRect:(CGRect)sourceRect delegate:(UIViewController *)delegate complishBlock:(void(^)(NSString *str))complishBlock {
    [self removeSelectListView:delegate];
    if (dataSource.count <= 0) {
        return;
    }
    CSSelectListView *view = [CSSelectListView new];
    view.dataSource = dataSource;
    view.delegate = delegate;
    view.complishBlock = complishBlock;
    [view showWithSourceRect:sourceRect];
}

+ (void)showSelectListViewWithSourceRect:(CGRect)sourceRect delegate:(UIViewController *)delegate complishBlock:(void(^)(NSString *str))complishBlock {
    [self removeSelectListView:delegate];
    CSSelectListView *view = [CSSelectListView new];
    view.delegate = delegate;
    view.complishBlock = complishBlock;
    [view showWithSourceRect:sourceRect];
}

+ (void)showSelectListViewWithSourceRect:(CGRect )sourceRect {
    CSSelectListView *view = [CSSelectListView new];
    [view showWithSourceRect:sourceRect];
}

+ (void)removeSelectListView:(UIViewController *)delegate {
    for (UIView *view in delegate.view.subviews) {
        if ([view isKindOfClass:[self class]]) {
            [view removeFromSuperview];
        }
    }
}

- (instancetype)init {
    if (self = [super init]) {
        [self initView];
    }
    return self;
}

- (void)showWithSourceRect:(CGRect )sourceRect {
    [self updateData];
    [self updateViewWithSourceRect:sourceRect];
    [self show];
}

- (void)updateViewWithSourceRect:(CGRect )sourceRect {
    CGRect sframe = [UIScreen mainScreen].bounds;
    CGRect frame = CGRectZero;
    frame.size.width = self.preferredContentSize.width;
    frame.size.height = self.preferredContentSize.height;
    self.tableView.frame = frame;
    
    frame.origin.x = CGRectGetMinX(sourceRect) + (CGRectGetWidth(sourceRect) - CGRectGetWidth(frame)) * 0.5;
    if (CGRectGetWidth(frame) + CGRectGetMinX(frame) > CGRectGetWidth(sframe)) {
        frame.origin.x -= CGRectGetWidth(frame) + CGRectGetMinX(frame) - CGRectGetWidth(sframe);
    }
    if (CGRectGetMinX(frame) < 0) {
        frame.origin.x = 0;
    }
    frame.origin.y = CGRectGetMinY(sourceRect) + CGRectGetHeight(sourceRect) + viewMargin;
    if (CGRectGetMinY(frame) + CGRectGetHeight(frame) > CGRectGetHeight(sframe)) {
        frame.origin.y -= CGRectGetMinY(frame) + CGRectGetHeight(frame) - CGRectGetHeight(sframe);
    }
    self.frame = frame;
}

- (void)show {
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    if (self.delegate) {
        [self.delegate.view addSubview:self];
    }else {
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        [window addSubview:self];
    }
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:viewAlpha];
    }];
}

- (void)dismiss {    
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)updateData {
    self.preferredContentSize = CGSizeMake(tableviewWidht, cellHeight * self.dataSource.count);
    [self.tableView reloadData];
}

- (void)initView {
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    self.frame = [UIScreen mainScreen].bounds;
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
//    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
//    [self addGestureRecognizer:gesture];
    [self addSubview:self.tableView];
}

- (NSArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSArray new];
    }
    return _dataSource;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.layer.cornerRadius = 5;
        _tableView.clipsToBounds = YES;
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"master"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"master"];
    }
    cell.textLabel.text = self.dataSource[indexPath.row];
//    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, CGRectGetWidth(self.frame));
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.actionBlock) {
        self.actionBlock(self.dataSource[indexPath.row]);
    }
    if (self.complishBlock) {
        self.complishBlock(self.dataSource[indexPath.row]);
    }
    [self dismiss];
}

@end
