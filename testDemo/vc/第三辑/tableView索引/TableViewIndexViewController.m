//
//  TableViewIndexViewController.m
//  testDemo
//
//  Created by lignpeng on 2019/1/23.
//  Copyright © 2019年 genpeng. All rights reserved.
//
#import "IndexView.h"
#import "Masonry.h"
#define NAV_HEIGHT 64
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#import "TableViewIndexViewController.h"
#import "IndexTableViewCell.h"
#import "NewIndexView.h"

static NSString *TableViewHeaderViewIdentifier = @"TableViewHeaderViewIdentifier";
static NSString *TableViewCellIdentifier = @"TableViewCellIdentifier";



@interface TableViewIndexViewController ()<UITableViewDelegate, UITableViewDataSource, NewIndexViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NewIndexView *indexView;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;//数据源数组
@property (nonatomic, strong) NSMutableArray *indexArray; //索引数组
@property(nonatomic, strong) NSArray *siteArray;
@end

@implementation TableViewIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self initView];
}

- (void)initView {
//添加视图
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.indexView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];

    [self.tableView reloadData];
    [self.indexView reload];
//    [self.indexView setSelectionIndex:0];
    [self.view layoutIfNeeded];
}


- (void)loadData {
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"overseasSiteData" ofType:@"json" inDirectory:@"Resource/data"]];
    NSError *error;
//    id dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    self.siteArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    //获得国家名
    NSMutableArray *countyArray = [NSMutableArray array];
    for (NSDictionary *siteDic in self.siteArray) {
        NSString *countryName = [[siteDic allKeys] firstObject];
        if (countryName.length > 0) {
            [countyArray addObject:countryName];
        }
    }
    NSString *china = countyArray.firstObject;
    if ([china isEqualToString:@"China"]) {
        [countyArray removeObjectAtIndex:0];
        [self.indexArray addObject:@"推荐"];
        [self.dataSourceArray addObject:@[china,china,china,china,china,china]];
    }
    while (countyArray.count > 0) {
        NSString *countryName = countyArray.firstObject;
        NSString *str = [countryName substringToIndex:1];
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH[c] %@",str];
        NSArray *filterArray = [countyArray filteredArrayUsingPredicate:pre];
        if (filterArray.count > 0) {
            [self.dataSourceArray addObject:filterArray];
            [countyArray removeObjectsInArray:filterArray];
            [self.indexArray addObject:str];
        }
    }
    
}

#pragma mark - 代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.indexArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = self.dataSourceArray[section];
    return [array count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 42;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UILabel *headerView = (UILabel *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:TableViewHeaderViewIdentifier];
    if (!headerView) {
        headerView = [UILabel new];
        headerView.backgroundColor = [UIColor whiteColor];
        headerView.frame = (CGRect){0,0,CGRectGetWidth([UIScreen mainScreen].bounds),30};
    }
    headerView.text = [NSString stringWithFormat:@"  %@",self.indexArray[section]];
    return headerView;
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    UIView *headerView = (UILabel *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footer"];
//    if (!headerView) {
//        headerView = [UIView new];
//        headerView.backgroundColor = [UIColor whiteColor];
//        headerView.frame = (CGRect){0,0,CGRectGetWidth([UIScreen mainScreen].bounds),30};
//    }
//    return [[UIView new] initWithFrame:(CGRect){0,0,CGRectGetWidth([UIScreen mainScreen].bounds),30}];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableViewCellIdentifier];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableViewCellIdentifier];
//    }
    NSArray *dataArray = self.dataSourceArray[indexPath.section];
    NSString *info = dataArray[indexPath.row];
    IndexTableViewCell *cell = [IndexTableViewCell indexTableViewCell:tableView info:info];
//    cell.textLabel.text = info;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat nHight = CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]) + CGRectGetHeight(self.navigationController.navigationBar.frame);
    [self.indexView scrollViewDidScroll:scrollView navigationHeight:nHight];
}

#pragma mark - IndexView

- (NSArray<NSString *> *)sectionIndexTitles {
    return self.indexArray;
}

//当前选中组
- (void)selectedSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    NSLog(@"index = %ld\n",(long)index);
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 42;//因为实现了cell，所以不会出现空白
        _tableView.rowHeight = 42;//因为实现了cell，所以不会出现空白
        //要实现sectionheader的方法，返回headerview，且frame不能为zero，否则会导致每行section出现空白
        _tableView.estimatedSectionHeaderHeight = 30;
        //要实现sectionfooter的方法，返回footerview，且frame不能为zero，会导致每行section出现空白
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.showsVerticalScrollIndicator = NO;
//        UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,10,10}];
//        view.backgroundColor = [UIColor grayColor];
//        _tableView.tableHeaderView = view;//会导致头部出现空白
        _tableView.tableFooterView = [UIView new];
//        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:TableViewCellIdentifier];
    }
    return _tableView;
}

- (NewIndexView *)indexView {
    if (!_indexView) {
        CGFloat nHight = CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]) + CGRectGetHeight(self.navigationController.navigationBar.frame);
        CGRect frame = [UIScreen mainScreen].bounds;
        frame = (CGRect){CGRectGetWidth(frame)-64,nHight,64,CGRectGetHeight(frame)-nHight};
        _indexView = [NewIndexView indexViewWithFrame:frame tableView:self.tableView delegate:self];
        UILabel *label = [self dd];
        [_indexView configIndicatorView:label touchBlock:^(NSString *title) {
            label.text = title;
        }];
        [_indexView showBackColor:[UIColor colorWithRed:121/255.0 green:134/255.0 blue:145/255.0 alpha:0.5]];
    }
    return _indexView;
}

- (UILabel *)dd {
    UILabel *label = [UILabel new];
    CGRect frame = [UIScreen mainScreen].bounds;
    label.frame = CGRectMake((CGRectGetWidth(frame)-80)/2.0, (CGRectGetHeight(frame) - 64 - 40)/2.0, 80, 40);
    label.backgroundColor = [UIColor colorWithRed:0.5 green:0.2 blue:0.6 alpha:0.5];
    label.layer.cornerRadius = 8.0;
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.masksToBounds = YES;
    return label;
}

/*
- (IndexView *)indexView {
    if (!_indexView) {
        _indexView = [[IndexView alloc] init];
        CGFloat nHight = CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]) + CGRectGetHeight(self.navigationController.navigationBar.frame);
        CGRect frame = [UIScreen mainScreen].bounds;
        _indexView.frame = (CGRect){CGRectGetWidth(frame)-30,nHight,30,CGRectGetHeight(frame)-nHight};
        _indexView.referenceStr = @"推荐";
        _indexView.delegate = self;
        _indexView.dataSource = self;
    }
    return _indexView;
}
*/

- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray array];
    }
    return _dataSourceArray;
}

- (NSMutableArray *)indexArray {
    if (!_indexArray) {
        _indexArray = [NSMutableArray array];
    }
    return _indexArray;
}

@end
