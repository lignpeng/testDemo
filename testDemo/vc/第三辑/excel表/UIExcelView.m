//
//  UIExcelView.m
//  testDemo
//
//  Created by lignpeng on 2018/5/11.
//  Copyright © 2018年 genpeng. All rights reserved.
//

#import "UIExcelView.h"
#import "Masonry.h"
#import "UIExcelTableViewCell.h"
#import "UILeftCollectionCell.h"
#import "ExcelCollectionViewFlowLayout.h"

#define leftheaderID @"leftheader"

@interface UIExcelView()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, assign) CGFloat squareW; //collectionCell宽
@property (nonatomic, assign) CGFloat squareH; //collectionCell高
@property(nonatomic, strong) UIView *leftTopView;//左上角上的view
@property(nonatomic, strong) UITableView *mainTableView;//主列表
@property(nonatomic, strong) UICollectionView *leftCollection;//左边列表
@property(nonatomic, strong) UICollectionView *topCollection;//顶部列表
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIView *squareView;

@end

@implementation UIExcelView

//- (instancetype)init {
//    if (self = [super init]) {
//        [self initView];
//    }
//    return self;
//}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView {
    self.colunm = 0;
    self.row = 0;
    self.squareH = 64;
    self.squareW = 64;
//    self.frame = (CGRect){0,0,100,100};
//    [self addSubview:self.leftCollection];
//    [self addSubview:self.scrollView];
//    [self.scrollView addSubview:self.mainTableView];
//    [self.leftCollection mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.mas_top).offset(self.squareH);
//        make.leading.equalTo(self);
//        make.bottom.equalTo(self.mas_bottom);
//        make.width.mas_equalTo(self.squareW);
//    }];
//    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.mas_top);
//        make.trailing.equalTo(self);
//        make.bottom.equalTo(self.mas_bottom);
//        make.left.equalTo(self.leftCollection.mas_right);
//    }];
}

- (void)updataView {
    [self layoutIfNeeded];
    [self updateData];
}

- (void)updateData {
    [self.leftCollection reloadData];
    [self.topCollection reloadData];
    [self.mainTableView reloadData];
}

- (void)show {
    self.squareW = (self.colunm == 0) ? 64 : CGRectGetWidth(self.frame)/self.colunm;
    self.squareH = (self.row == 0) ? 64 : CGRectGetHeight(self.frame)/self.row;
    CGFloat width = self.topDataSource.count * self.squareW;
    
    [self addSubview:self.leftCollection];
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.mainTableView];
    
    CGRect lframe = self.leftCollection.frame;
    CGFloat height = CGRectGetHeight(self.frame);
    lframe.size = (CGSize){self.squareW,height};
    self.leftCollection.frame = lframe;

    CGRect cframe = self.scrollView.frame;
    cframe.size = (CGSize){CGRectGetWidth(self.frame)-self.squareW,height};
    self.scrollView.frame = cframe;
    
    self.scrollView.contentSize = CGSizeMake(width, CGRectGetHeight(self.scrollView.bounds));
    
    CGRect tframe = self.topCollection.frame;
    tframe.size = (CGSize){width,self.squareH};
    self.topCollection.frame = tframe;
    
    CGRect mframe = self.mainTableView.frame;
    mframe.size = (CGSize){width, CGRectGetHeight(self.frame)};
    self.mainTableView.frame = mframe;
    [self updateData];
}

- (void)layoutSubviews  {
    [super layoutSubviews];
    return;
//    self.squareW = (self.colunm == 0) ? 64 : CGRectGetWidth(self.frame)/self.colunm;
//    self.squareH = (self.row == 0) ? 64 : CGRectGetHeight(self.frame)/self.row;
//    CGFloat width = self.topDataSource.count * self.squareW;
////
//    if (!self.squareView) {
//        self.squareView = [self getSquareView];
//    }
//    CGRect sframe = self.squareView.frame;
//    sframe.size = (CGSize){self.squareW,self.squareH};
//    self.squareView.frame = sframe;
////    CGRect lframe = self.leftCollection.frame;
////    lframe.size.height = CGRectGetHeight(self.bounds);
////    self.leftCollection.frame = lframe;
//
//    [self.leftCollection mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.mas_top).offset(self.squareH);
//        make.width.mas_equalTo(self.squareW);
//    }];
//    CGRect tframe = self.topCollection.frame;
//    tframe.size.width = width;
////    tframe.size = (CGSize){width, CGRectGetHeight(self.bounds)};
//    self.topCollection.frame = tframe;
//
//    CGRect mframe = self.mainTableView.frame;
//    mframe.size = (CGSize){width, CGRectGetHeight(self.scrollView.frame)};
//    self.mainTableView.frame = mframe;
//
//    self.scrollView.contentSize = CGSizeMake(width, CGRectGetHeight(self.scrollView.bounds));
//    [self updateData];
}

#pragma mark - 表数据

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.leftDataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.squareH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.squareH;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.topCollection;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UIExcelTableViewCell *cell = [UIExcelTableViewCell cellForTableView:tableView squareW:self.squareW squareH:self.squareH];
    cell.indexPath = indexPath;
    [cell configData:self.tableViewDataSource[indexPath.row]];
    cell.selectBlock = ^(NSUInteger colunm,NSUInteger row,id value) {
        NSLog(@"第%lu行,第%lu列:%@",(unsigned long)row,(unsigned long)colunm,value);
    };
    return cell;
}

//  返回头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.topCollection) {
        return nil;
    }
        //如果是头视图
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:leftheaderID forIndexPath:indexPath];
            //添加头视图的内容
//        [header addSubview:[self getSquareView]];
        header.backgroundColor = [UIColor orangeColor];
        return header;
    }
    return nil;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
//    return (CGSize){self.squareW, self.squareH};
//}

- ( CGSize )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:( NSIndexPath *)indexPath {
    return (CGSize){self.squareW, self.squareH};
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.leftCollection) {
        return self.leftDataSource.count;
    }
    return self.topDataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UILeftCollectionCell *cell = [UILeftCollectionCell cellForCollectionView:collectionView IndexPath:indexPath];
    if (collectionView == self.leftCollection) {
        [cell configTitle:self.leftDataSource[indexPath.row]];
    }else {
        [cell configTitle:self.topDataSource[indexPath.row]];
    }
    return cell;
}

//滚动同步
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.mainTableView) {
        if (self.leftCollection.contentOffset.y != self.mainTableView.contentOffset.y) {
            self.leftCollection.contentOffset = CGPointMake(0, self.mainTableView.contentOffset.y);
        }
    } else if (scrollView == self.leftCollection) {
        if (self.mainTableView.contentOffset.y != self.leftCollection.contentOffset.y) {
            self.mainTableView.contentOffset = CGPointMake(self.mainTableView.contentOffset.x, self.leftCollection.contentOffset.y);
        }
    }
}

#pragma mark - 懒加载

-(UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.bounces = NO;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.showsHorizontalScrollIndicator = NO;
        _mainTableView.backgroundColor = [UIColor whiteColor];
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.tableFooterView = [UIView new];
        _mainTableView.estimatedRowHeight = 0;
        _mainTableView.estimatedSectionHeaderHeight = 0;
        _mainTableView.estimatedSectionFooterHeight = 0;
    }
    return _mainTableView;
}

- (UICollectionView *)topCollection {
    if (!_topCollection) {
        ExcelCollectionViewFlowLayout *layout = [[ExcelCollectionViewFlowLayout alloc] init];
        layout.itemSize= CGSizeMake(self.squareW, self.squareH);
        _topCollection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _topCollection.backgroundColor = [UIColor whiteColor];
        _topCollection.bounces = NO;
        _topCollection.delegate = self;
        _topCollection.dataSource = self;
        _topCollection.showsHorizontalScrollIndicator = NO;
        [_topCollection registerClass:[UILeftCollectionCell class] forCellWithReuseIdentifier:leftcollectionId];
    }
    return _topCollection;
}

- (UICollectionView *)leftCollection {
    if (!_leftCollection) {
        ExcelCollectionViewFlowLayout *layout = [[ExcelCollectionViewFlowLayout alloc] init];
        //设置collectionView头视图的大小，不然的话，不会出现头部view
        layout.headerReferenceSize = CGSizeMake(self.squareW, self.squareH);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _leftCollection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _leftCollection.bounces = NO;
        _leftCollection.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _leftCollection.backgroundColor = [UIColor whiteColor];
        _leftCollection.delegate = self;
        _leftCollection.dataSource = self;
        _leftCollection.showsVerticalScrollIndicator = NO;
        [_leftCollection registerClass:[UILeftCollectionCell class] forCellWithReuseIdentifier:leftcollectionId];
        
        //默认情况下collection的header会跟着一起走的，不会停靠在导航栏，重写flowlayout
        [_leftCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:leftheaderID];
    }
    return _leftCollection;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.squareW, 0,self.squareW, self.squareH)];
        _scrollView.contentSize = CGSizeMake(self.squareW, self.squareH);
        _scrollView.bounces = NO;
        _scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _scrollView.alwaysBounceVertical = YES;
        _scrollView.alwaysBounceHorizontal = NO;
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIView *)getSquareView {
//    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,self.squareW,self.squareH}];
//    UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){0,0,self.squareW,self.squareH}];
    UILabel *label = [UILabel new];
    label.text = @"header";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor blackColor];
//    [view addSubview:label];
    return label;
}

- (NSMutableArray *)leftDataSource {
    if (!_leftDataSource) {
        _leftDataSource = [NSMutableArray array];
    }
    return _leftDataSource;
}

- (NSMutableArray *)topDataSource {
    if (!_topDataSource) {
        _topDataSource = [NSMutableArray array];
    }
    return _topDataSource;
}

- (NSMutableArray *)tableViewDataSource {
    if (!_tableViewDataSource) {
        _tableViewDataSource = [NSMutableArray array];
    }
    return _tableViewDataSource;
}

@end
