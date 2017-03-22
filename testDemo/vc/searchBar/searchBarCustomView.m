//
//  searchBarCustomView.m
//  airport
//
//  Created by jinchangwang on 15/7/28.
//  Copyright (c) 2015年 jinchangwang. All rights reserved.
//

#import "searchBarCustomView.h"

@interface searchBarCustomView()<UISearchBarDelegate,UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate,UISearchResultsUpdating>
//@property (nonatomic,readwrite)UISearchBar *searchBar;

//@property (nonatomic,strong)UISearchDisplayController *searchDC;
@property (nonatomic,strong)NSMutableArray *searchArrays;

@end
@implementation searchBarCustomView

- (instancetype)init {
    if (self = [super init]) {
        [self initView];
    }
    return self;
}

//- (instancetype)initWithFrame:(CGRect)frame {
//    if (self = [super initWithFrame:frame]) {
//        [self initView];
//    }
//    return self;
//}

//下面我们来初始化我们的三个成员
-(void)initView{
    
    self.searchArrays = [NSMutableArray array];
    [self.searchArrays addObjectsFromArray:@[@"1",@"2",@"1",@"2",@"1",@"2",@"1",@"2",@"1",@"2"]];
    self.searchController = ({
        
       UISearchController *vc = [[UISearchController alloc] initWithSearchResultsController:nil];
        vc.searchResultsUpdater = self; //设置显示搜索结果的控制器
        vc.dimsBackgroundDuringPresentation = false;//开始输入时，背景就会变暗。
        vc.searchBar.placeholder = @"search here ...";
        vc.searchBar.delegate = self;
        vc.hidesNavigationBarDuringPresentation = NO;
        [vc.searchBar sizeToFit];//设置searchBar位置自适应
        vc;
    });
//    CGRect frame = self.bounds;
//    CGFloat vheight = 120;
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentify];
//    self.tableView.rowHeight = 90;
//    self.tableView.tableHeaderView = self.searchController.searchBar;//放置 搜索条在 tableView的头部视图中
//    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), vheight)];
//    [self addSubview:self.tableView];
    [self.tableView reloadData];
    
    
;//    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width, 44)];
//    self.searchBar.placeholder = _placeholder;
//    self.searchBar.delegate = self;
//    //设置选项
//    self.searchBar.barTintColor = [UIColor whiteColor
//                               ];
//    self.searchBar.searchBarStyle = UISearchBarStyleDefault;
//    self.searchBar.translucent = YES; //是否半透明
//    [self setSearchTextFieldBackgroundColor:[UIColor colorWithRed:0.929 green:0.941 blue:0.945 alpha:1.000]];
//    [self.searchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
//    [self.searchBar sizeToFit];
//    [self addSubview:self.searchBar];
    
    
//    self.searchDC = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self.ctl];
//    self.searchDC.delegate = self;
//    self.searchDC.searchResultsDataSource = self;
//    self.searchDC.searchResultsDelegate = self;
//    self.searchDC.displaysSearchBarInNavigationBar = NO;
    
}


- (void) setSearchTextFieldBackgroundColor:(UIColor*)color {
//    UIView *searchTextField = nil;
//    self.searchBar.barTintColor = [UIColor whiteColor];
//    searchTextField = [[[self.searchBar.subviews firstObject] subviews] lastObject];
//    searchTextField.backgroundColor = color;
    
}



- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
//    if(self.type == SearchBuild){
//    _searchArrays = [AirportSqlite searchbuildwithBuildName:searchText];
//    }else if(self.type == SearchPOI){
//        
//        RTLbsWebService *webService = [[RTLbsWebService alloc] init];
//        webService.delegate = self;
//        webService.serverUrl = RTLbsServerAddress;
//        BOOL isSuccess =  [webService getKeywordSearchByPage:@"1" pageSize:@"100" keywords:searchText buildID:_searchBuildID];
//        if (isSuccess)
//        {
//            NSLog(@"关键词检索发送成功");
//        }
//        else
//        {
//            NSLog(@"关键词检索发送失败");
//        }
//
//    }
}


#pragma mark - UISearchBarDelegate

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    return YES;
}

// 点击键盘上面的搜索按钮
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    //    [self.searchBar resignFirstResponder];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
//    NSString *filterString = searchController.searchBar.text;
    
}

//实现我们的table view 的协议，判断当我们开始搜索时，转到自己实现的一个searchDisplayController方法里，这样代码看起来是不是很简洁？
#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    return _searchArrays.count;
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"rtmap";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }

    cell.textLabel.text = self.searchArrays[indexPath.row];

    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [self.searchDC setActive:NO animated:YES];
    if([self.delegate respondsToSelector:@selector(selectBuild:)]){
        [self.delegate selectBuild:[_searchArrays objectAtIndex:indexPath.row]];
    }
}

#pragma mark - 搜索完刷新tableView
- (void) refreshTableView{
//    [self.searchDC.searchResultsTableView reloadData];
}
#pragma mark - RTLbsWebServiceDelegate
//- (void) searchRequestFinish:(NSArray *)poiMessageArray
//{
//
//    [_searchArrays removeAllObjects];
//    [self.searchDC.searchResultsTableView reloadData];
//    if(poiMessageArray.count == 0)
//    {
//        showAlertViewWithoutCancelAction(nil, @"没有相符的结果", nil);
//        return;
//    }
//   
//    [_searchArrays sortUsingComparator:^NSComparisonResult(  RTLbsAnnotation * obj1, RTLbsAnnotation  * obj2) {
//        if ([obj1.annotationFloor isEqualToString:_floor] && ![obj2.annotationFloor isEqualToString:_floor]) {
//            return NSOrderedAscending;
//        }else if (![obj1.annotationFloor isEqualToString:_floor] && [obj2.annotationFloor isEqualToString:_floor]){
//            return NSOrderedDescending;
//        }else if ([obj1.annotationFloor isEqualToString:_floor] && [obj2.annotationFloor isEqualToString:_floor]){
//            if (CGPointEqualToPoint(_point, CGPointZero)) {
//                return -[self compareFloorA:obj1.annotationFloor andFloorB:obj2.annotationFloor];
//            }
//            float a = [self distantFormPoint:obj1.location];
//            float b = [self distantFormPoint:obj2.location];
//            return a > b;
//        }else{
//            return -[self compareFloorA:obj1.annotationFloor andFloorB:obj2.annotationFloor];
//        }
//    }];
//    [self.searchDC.searchResultsTableView reloadData];
//}


// 搜索失败调用该方法
//- (void) searchRequestEndWithError:(NSError *)error {
//    //    NSLog(@"%@",error);
//    [self.searchDC.searchResultsTableView reloadData];
//    showAlertViewWithoutCancelAction(@"搜索失败",[NSString stringWithFormat:@"%ld",(long)error.code],nil);
//}


@end
