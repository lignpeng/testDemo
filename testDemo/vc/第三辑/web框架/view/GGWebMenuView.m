//
//  GGWebMenuView.m
//  testDemo
//
//  Created by lignpeng on 2019/1/18.
//  Copyright © 2019年 genpeng. All rights reserved.
//

#import "GGWebMenuView.h"
#import "Masonry.h"
#import "GGMacors.h"
#import "GGWebMenuViewCell.h"
#import "TxetTools.h"

static const CGFloat kHolderViewHeight = 250.0f;//选择器总高度
static const CGFloat kBarViewHeight = 50.0f;//bar条高度
static const CGFloat kTitleHeigh = 36.0f;//按钮宽度
static const NSTimeInterval kAnimationDuration = 0.25f;
static const CGFloat kCollectionViewHeight = 72.0f;//选择器高度
static const CGFloat kCellMargin = 2;
@interface GGWebMenuView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong) UIButton *cancelButton;
@property(nonatomic, strong) UIView *holderView;
@property(nonatomic, strong) UICollectionView *firstCollectionView;
@property(nonatomic, strong) UICollectionView *secondCollectionView;
@property(nonatomic, strong) NSArray *dataSource;
@property(nonatomic, copy) void(^complishBlock)(WebMenuType index);

@end

@implementation GGWebMenuView

+ (instancetype)webMenuView {
    GGWebMenuView *view = [[GGWebMenuView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    return view;
}

+ (void)show {
    [[GGWebMenuView webMenuView] show];
}

+ (void)showComplish:(void(^)(NSInteger index))complishBlock {
    GGWebMenuView *view = [self webMenuView];
    view.complishBlock = complishBlock;
    [view show];
}

+ (void)dissmiss {
    UIWindow *windowView = [[UIApplication sharedApplication] keyWindow];
    for (UIView *subView in windowView.subviews) {
        if ([subView isMemberOfClass:[self class]]) {
            [(GGWebMenuView *)subView dismiss];
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
        _dataSource = [GGWebMenuModel webMenus];
    }
    return _dataSource;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.titleLabel.font = [TxetTools pingFangFont:16];
        [_cancelButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        [_cancelButton setTitle:NSLocalizedString(@"取消",@"Cancel") forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton.backgroundColor = [UIColor whiteColor];
    }
    return _cancelButton;
}


- (UIView *)holderView {
    if (!_holderView) {
        _holderView = [UIView new];
        _holderView.backgroundColor = [UIColor colorWithRed:209.0/255.0 green:217.0/255.0 blue:224.0/255.0 alpha:1.0];
    }
    return _holderView;
}

- (UICollectionView *)firstCollectionView {
    if (!_firstCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize= CGSizeMake(60 , 80);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _firstCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _firstCollectionView.backgroundColor = [UIColor clearColor];
        _firstCollectionView.delegate = self;
        _firstCollectionView.dataSource = self;
        _firstCollectionView.alwaysBounceHorizontal = YES;
        _firstCollectionView.showsHorizontalScrollIndicator = NO;
        [_firstCollectionView registerClass:[GGWebMenuViewCell class] forCellWithReuseIdentifier:webMenuViewCellId];
    }
    return _firstCollectionView;
}

- (UICollectionView *)secondCollectionView {
    if (!_secondCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize= CGSizeMake(60 , 80);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _secondCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _secondCollectionView.backgroundColor = [UIColor clearColor];
        _secondCollectionView.delegate = self;
        _secondCollectionView.dataSource = self;
        _secondCollectionView.alwaysBounceHorizontal = YES;
        _secondCollectionView.showsHorizontalScrollIndicator = NO;
        [_secondCollectionView registerClass:[GGWebMenuViewCell class] forCellWithReuseIdentifier:webMenuViewCellId];
    }
    return _secondCollectionView;
}

- (void)initView {
    [self.holderView addSubview:self.cancelButton];
    UIView *subHolderView = [UIView new];
    [self.holderView addSubview:subHolderView];
    [subHolderView addSubview:self.firstCollectionView];
    [subHolderView addSubview:self.secondCollectionView];
    UILabel *titleLabel = ({
        UILabel *label = [UILabel new];
        label.text = @"请选择";
        label.font = [TxetTools pingFangFont:14];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor grayColor];
        label;
    });
    [self.holderView addSubview:titleLabel];
    
    [self addSubview:self.holderView];
    
    CGFloat gap = 3;
    CGFloat collectionHeight = (kCollectionViewHeight + gap)* self.dataSource.count;
    CGFloat height = kTitleHeigh + kBarViewHeight + collectionHeight;
    [self.holderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self);
        make.trailing.equalTo(self);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(height);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.holderView);
        make.height.mas_equalTo(kTitleHeigh);
    }];
    
    [subHolderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.holderView);
        make.bottom.equalTo(self.cancelButton.mas_top);
        make.height.mas_equalTo(collectionHeight);
    }];
    
    [self.firstCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(subHolderView);
        make.height.mas_equalTo(kCollectionViewHeight);
    }];
    
    [self.secondCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(subHolderView);
        make.top.equalTo(self.firstCollectionView.mas_bottom).offset(gap);
        make.bottom.equalTo(subHolderView.mas_bottom).offset(-gap);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.holderView);
        make.bottom.equalTo(self.holderView.mas_bottom);
        make.height.mas_equalTo(kBarViewHeight);
    }];
    
}

- (void)cancelAction {
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

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.firstCollectionView) {
        return ((NSArray *)self.dataSource.firstObject).count;
    }
    return ((NSArray *)self.dataSource.lastObject).count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GGWebMenuViewCell *cell = [GGWebMenuViewCell cellForCollectionView:collectionView IndexPath:indexPath];
    NSArray *array = self.dataSource.firstObject;
    if (collectionView == self.secondCollectionView) {
        array = self.dataSource.lastObject;
    }
    GGWebMenuModel *model = array[indexPath.row];
    [cell configCell:model];
    return cell;
}

- ( CGSize )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:( NSIndexPath *)indexPath {
    return (CGSize){60, 80};
}

//内边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(kCellMargin, kCellMargin, kCellMargin, kCellMargin);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return kCellMargin;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return kCellMargin;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    GGWebMenuViewCell *cell = (GGWebMenuViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (self.complishBlock) {
        GGWebMenuModel *model = [cell getWebMenuModel];
        [self dismiss];
        self.complishBlock(model.type);
    }
}

@end
