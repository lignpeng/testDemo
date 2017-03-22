//
//  BaseSearchViewController.m
//  testDemo
//
//  Created by lignpeng on 17/1/11.
//  Copyright © 2017年 genpeng. All rights reserved.
//

#import "BaseSearchViewController.h"
#define cellIdentify @"cellReuse"

@interface BaseSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating,UISearchBarDelegate>

@property(nonatomic, strong) NSArray *dataSource;
@property(nonatomic, strong) NSMutableArray *filterDataSource;
@property(nonatomic, assign) BOOL shouldShowSearchReaults;

@end

@implementation BaseSearchViewController
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

- (UIButton *)backgroundView {
    if (!_backgroundView) {
        _backgroundView =[[UIButton alloc]initWithFrame:self.view.bounds];
        [_backgroundView addTarget:self action:@selector(cancelSearch) forControlEvents:UIControlEventTouchUpInside];
        _backgroundView.backgroundColor =[UIColor blackColor];
        _backgroundView.alpha =0.3;
    }
    return _backgroundView;
}

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"search here ...";
        [_searchBar sizeToFit];
        _searchBar.showsCancelButton = YES;
    }
    return _searchBar;
}

#pragma mark - setter 方法

- (void)setShouldShowSearchReaults:(BOOL)shouldShowSearchReaults {
    _shouldShowSearchReaults = shouldShowSearchReaults;
    self.tableView.hidden = !shouldShowSearchReaults;
    if (shouldShowSearchReaults) {
        [self.view bringSubviewToFront:self.tableView];
        [self.tableView reloadData];
        
    }else {
        [self.backgroundView removeFromSuperview];
    }
    self.searchBar.showsCancelButton = shouldShowSearchReaults;
}

- (void)setPlaceHolder:(NSString *)placeHolder {
    if (_placeHolder != placeHolder) {
        _placeHolder = placeHolder;
        self.searchBar.placeholder = placeHolder;
    }
}

#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    
}

- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.shouldShowSearchReaults = false;
    
    CGRect frame = self.view.bounds;
    
    CGRect rect = [[UIApplication sharedApplication] statusBarFrame];
    CGFloat height =  rect.size.height;
    CGFloat navigationheight = self.navigationController.navigationBar.frame.size.height;
    CGRect bframe = self.searchBar.frame;
    bframe.origin.y += (height + navigationheight);
    self.searchBar.frame = bframe;
    [self.view addSubview:self.searchBar];
    frame.origin.y += (CGRectGetHeight(bframe) + CGRectGetMinY(bframe));
    frame.size.height -= CGRectGetMinY(frame);
    CGFloat vheight = 120;
    self.tableView = [[UITableView alloc] initWithFrame:frame];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentify];
    self.tableView.rowHeight = 90;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), vheight)];
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
    self.tableView.hidden = !self.shouldShowSearchReaults;
    self.backgroundView.frame = frame;
}

//点击遮罩，改变搜索状态
-(void)cancelSearch {
    [self searchBarCancelButtonClicked:self.searchBar];
}

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

#pragma mark - search Bar
 
 - (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
     NSString *filterString = searchController.searchBar.text;
     if (filterString.length <= 0) {
         return;
     }
     NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains [c] %@", filterString];
     
     self.filterDataSource = [NSMutableArray arrayWithArray:[self.dataSource filteredArrayUsingPredicate:predicate]];
     
     [self.tableView reloadData];
 }

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSString *filterString = searchBar.text;
    if (filterString.length <= 0) {
//        [self.view addSubview:self.backgroundView];
        return;
    }
    [self.backgroundView removeFromSuperview];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains [c] %@", filterString];
    
    self.filterDataSource = [NSMutableArray arrayWithArray:[self.dataSource filteredArrayUsingPredicate:predicate]];
    
    [self.tableView reloadData];
}

 - (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
     if (!self.shouldShowSearchReaults) {
         self.shouldShowSearchReaults = YES;
     }
     [self.backgroundView removeFromSuperview];
     [searchBar resignFirstResponder];
 }
 
 - (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
     self.shouldShowSearchReaults = false;
     [self.searchBar resignFirstResponder];
     searchBar.text = @"";
     [self.filterDataSource removeAllObjects];
 }

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    self.shouldShowSearchReaults = YES;
    [self.view addSubview:self.backgroundView];
    return YES;
}

@end

