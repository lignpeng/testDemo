//
//  UISelectListView.m
//  testDemo
//
//  Created by lignpeng on 2017/9/5.
//  Copyright © 2017年 genpeng. All rights reserved.
//

#import "UISelectListView.h"
#import "Masonry.h"

#define viewAlpha 0.1
#define viewMargin 0
#define cellHeight 42
#define tableviewWidht 180

static UISelectListView *g_SelectListView;

@interface UISelectListView()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGSize preferredContentSize;
@property (nonatomic, strong) NSArray *dataSource;
@property(nonatomic, weak) UIViewController *delegate;
@property(nonatomic, copy) void(^complishBlock)(NSString *str);

@end

@implementation UISelectListView

+ (void)showSelectListViewWithDataSoucre:(NSArray *)dataSource SourceRect:(CGRect)sourceRect delegate:(UIViewController *)delegate complishBlock:(void(^)(NSString *str))complishBlock {
    [self removeSelectListView:delegate];
    if (dataSource.count <= 0) {
        return;
    }
    UISelectListView *view = [UISelectListView new];
    view.dataSource = dataSource;
    view.delegate = delegate;
    view.complishBlock = complishBlock;
    [view showWithSourceRect:sourceRect];
}

+ (void)showSelectListViewWithSourceRect:(CGRect)sourceRect delegate:(UIViewController *)delegate complishBlock:(void(^)(NSString *str))complishBlock {
    [self removeSelectListView:delegate];
    UISelectListView *view = [UISelectListView new];
    view.delegate = delegate;
    view.complishBlock = complishBlock;
    [view showWithSourceRect:sourceRect];
}

+ (void)showSelectListViewWithSourceRect:(CGRect )sourceRect {
    UISelectListView *view = [UISelectListView new];
    [view showWithSourceRect:sourceRect];
}

+ (void)removeSelectListView:(UIViewController *)delegate {
    NSArray *subViews = delegate.view.subviews;
    for (UIView *view in subViews) {
        if ([view isKindOfClass:[UISelectListView class]]) {
            [view removeFromSuperview];
        }
    }
}

+ (BOOL)isHasShow {
    return g_SelectListView != nil;
}

+ (void)showSelectListView:(UISelectListView *)selectListView {
    g_SelectListView = selectListView;
    [selectListView show];
}

+ (void)dismissSelectListView {
    [g_SelectListView dismiss];
    g_SelectListView = nil;
}

- (instancetype)init {
    if (self = [super init]) {
        [self initView];
    }
    return self;
}

- (void)dealloc {
    g_SelectListView = nil;
}

- (void)showWithSourceRect:(CGRect )sourceRect {
    [self updateData];
    [self updateViewWithSourceRect:sourceRect];
    [UISelectListView showSelectListView:self];
}

- (void)updateViewWithSourceRect:(CGRect )sourceRect {
    CGRect sframe = [UIScreen mainScreen].bounds;
    CGRect frame = CGRectZero;
    frame.size.width = self.preferredContentSize.width;
    frame.size.height = self.preferredContentSize.height;
    frame.origin.x = CGRectGetMinX(sourceRect);
    if (CGRectGetWidth(frame) + CGRectGetMinX(frame) > CGRectGetWidth(sframe)) {
        frame.origin.x -= CGRectGetWidth(frame) + CGRectGetMinX(frame) - CGRectGetWidth(sframe);
    }
    if (CGRectGetMinX(frame) < 0) {
        frame.origin.x = 0;
    }
    frame.origin.y = CGRectGetMinY(sourceRect) + CGRectGetHeight(sourceRect) + viewMargin;
    self.tableView.frame = frame;
}

- (void)show {
    if (self.delegate) {
        [self.delegate.view addSubview:self];
    }else {
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        [window addSubview:self];
    }
}

- (void)dismiss {    
    [UIView animateWithDuration:0.2 animations:^{
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)updateData {
    self.preferredContentSize = CGSizeMake(tableviewWidht, cellHeight * self.dataSource.count);
    [self.tableView reloadData];
}

- (void)initView {
    self.frame = [UIScreen mainScreen].bounds;
    self.backButton.frame = [UIScreen mainScreen].bounds;
    [self addSubview:self.backButton];
    [self addSubview:self.tableView];
}

- (NSArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSArray new];
    }
    return _dataSource;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [[UIButton alloc] init];
        [_backButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        _backButton.backgroundColor = [UIColor clearColor];
    }
    return _backButton;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
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
    cell.backgroundColor = [UIColor clearColor];
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
