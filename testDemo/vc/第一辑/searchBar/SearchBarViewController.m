//
//  SearchBarViewController.m
//  testDemo
//
//  Created by lignpeng on 17/1/6.
//  Copyright © 2017年 genpeng. All rights reserved.
//

#import "SearchBarViewController.h"
#import "searchBarCustomView.h"
#import "BaseSearchViewController.h"
#import "BuildListViewController.h"
#define cellIdentify @"cellReuse"
#define HIGHT 667.0*self.view.bounds.size.height

@interface SearchBarViewController ()
///<,UITableViewDataSource,UISearchResultsUpdating,UISearchBarDelegate,searchBarCustomViewDelegate>
/*
@property(nonatomic, strong) NSString *name;

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) NSArray *dataSource;
@property(nonatomic, strong) NSMutableArray *filterDataSource;
@property(nonatomic, assign) BOOL shouldShowSearchReaults;
@property(nonatomic, strong) UISearchController *searchController;
*/
@end

@implementation SearchBarViewController
/*
- (NSArray *)dataSource {
    if (_dataSource) {
        return _dataSource;
    }
    _dataSource = @[@"1",@"2",@"4",@"5",@"3",@"2",@"3",@"2",@"4",@"2",@"4",@"2"];
    return _dataSource;
}

- (NSMutableArray *)filterDataSource {
    if (_filterDataSource) {
        return _filterDataSource;
    }
    _filterDataSource = [NSMutableArray array];
    return _filterDataSource;
}

- (UISearchController *)searchController {
    if (!_searchController) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        _searchController.searchResultsUpdater = self; //设置显示搜索结果的控制器
        _searchController.dimsBackgroundDuringPresentation = false;//开始输入时，背景就会变暗。
        _searchController.searchBar.placeholder = @"search here ...";
        _searchController.searchBar.delegate = self;
        _searchController.hidesNavigationBarDuringPresentation = NO;
        [_searchController.searchBar sizeToFit];//设置searchBar位置自适应
    }
    return _searchController;
}
*/
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initViews];
    
}

- (void)show {
    BuildListViewController *vc = [[BuildListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)initViews {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"super" style:UIBarButtonItemStylePlain target:self action:@selector(show)];
//    self.shouldShowSearchReaults = false;
//    CGRect frame = self.view.bounds;
//    CGFloat vheight = 120;
//    self.tableView = [[UITableView alloc] initWithFrame:frame];
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentify];
//    self.tableView.rowHeight = 90;
////    self.tableView.tableHeaderView = self.searchController.searchBar;//放置 搜索条在 tableView的头部视图中
//    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), vheight)];
//    [self.view addSubview:self.tableView];
//    [self.tableView reloadData];
//    self.navigationItem.titleView = self.searchController.searchBar;
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
//        [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]].title = @"取消";
//    }else {//ios 8
//        [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]].title = @"取消";
//    }

    
    // 搜索部分
//    CGRect frame = self.view.bounds;
////    CGRect sframe = CGRectMake(0, 65, CGRectGetWidth(frame), CGRectGetHeight(frame) - 64);
//    CGRect sframe = CGRectMake(0, 65, CGRectGetWidth(frame),  64);
//    UIView *searchView = [[UIView alloc] initWithFrame:sframe];
//    searchView.backgroundColor = [UIColor lightGrayColor];
//    [self.view addSubview:searchView];
//    searchBarCustomView *search = [[searchBarCustomView alloc] initWithFrame:sframe];
////    search.ctl = self;
//    search.placeholder = @"输入或选择机场及航站楼名称";
//    search.delegate = self;
////    search.backgroundColor = [UIColor colorWithRed:0.929 green:0.941 blue:0.945 alpha:1.000];
////    search.backgroundColor = [UIColor yellowColor];
//    [searchView addSubview:search];
}
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.shouldShowSearchReaults) {
        return self.filterDataSource.count;
    }
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    cell.backgroundColor = [UIColor colorWithRed:(arc4random()%255)/255.0 green:(arc4random()%255)/255.0 blue:(arc4random()%255)/255.0 alpha:0.8];
    if (self.shouldShowSearchReaults) {
        cell.textLabel.text = self.filterDataSource[indexPath.row];
    }else {
        cell.textLabel.text = self.dataSource[indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *filterString = searchController.searchBar.text;
    if (filterString.length <= 0) {
        return;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains [c] %@", filterString];
    
    self.filterDataSource = [NSMutableArray arrayWithArray:[self.dataSource filteredArrayUsingPredicate:predicate]];
    
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (!self.shouldShowSearchReaults) {
        self.shouldShowSearchReaults = YES;
        [self.tableView reloadData];
    }
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.shouldShowSearchReaults = false;
    [self.filterDataSource removeAllObjects];
    [self.tableView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.shouldShowSearchReaults = YES;
    [self.tableView reloadData];
}
*/

#pragma mark - searchBarCustomViewDelegate
/*
- (void) selectBuild:(NSString *)str {
    NSLog(@"str : %@",str);
//    [self savhistoryBuildName:buildSqlite.buildName];
//    FloorListViewController *floorCV = [[FloorListViewController alloc] init];
//    floorCV.buildName = buildSqlite.buildName;
//    [self.navigationController pushViewController:floorCV animated:YES];
}
*/
@end
