//
//  CSBrowsingHistoryListViewController.m
//  testDemo
//
//  Created by lignpeng on 2017/11/13.
//  Copyright © 2017年 genpeng. All rights reserved.
//

#import "CSBrowsingHistoryListViewController.h"
#import "CSBrowsingHistoryListViewModel.h"
#import "Masonry.h"
#import "CSBrowsingHistoryTypeView.h"


@interface CSBrowsingHistoryListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UIButton *topButton;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) CSBrowsingHistoryListViewModel *viewModel;

@end

@implementation CSBrowsingHistoryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.navigationItem.titleView = self.topButton;
    [self updateButtonContentAction];
    
    [self showRightBarButtonItem];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.trailing.equalTo(self.view);
        make.leading.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

- (void)showRightBarButtonItem {
    if (self.navigationItem.rightBarButtonItem) {
        return;
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(clearAction)];
}

- (void)showSelectionType {
    self.navigationItem.rightBarButtonItem = nil;
    if (![CSBrowsingHistoryTypeView isBrowsingHistoryTypeViewShow:self]) {
        [self.topButton setImage:[UIImage imageNamed:@"icon_s"] forState:UIControlStateNormal];
    }
    __weak typeof(self) weakSelf = self;
    [CSBrowsingHistoryTypeView showBrowsingHistoryTypeViewWithDelegate:self Type:0 complishBlock:^(NSUInteger type) {
        NSLog(@"type = %lu",(unsigned long)type);
        [weakSelf showRightBarButtonItem];
        NSArray *titleArray = @[@"浏览历史",@"机票搜索浏览历史",@"航班动态浏览历史"];
        [weakSelf.topButton setTitle:titleArray[type] forState:UIControlStateNormal];
        [weakSelf.topButton setImage:[UIImage imageNamed:@"icon_x"] forState:UIControlStateNormal];
        [weakSelf updateButtonContentAction];
    } dismissBlock:^{
        [weakSelf showRightBarButtonItem];
        [self.topButton setImage:[UIImage imageNamed:@"icon_x"] forState:UIControlStateNormal];
    }];
    if (![CSBrowsingHistoryTypeView isBrowsingHistoryTypeViewShow:self]) {
        [self showRightBarButtonItem];
        [self.topButton setImage:[UIImage imageNamed:@"icon_x"] forState:UIControlStateNormal];
    }
}

//调整按钮：文字左，图片右
- (void)updateButtonContentAction {
    //文字的size
    CGSize textSize = [self.topButton.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.topButton.titleLabel.font}];
    CGSize imageSize = self.topButton.currentImage.size;
    CGFloat marginGay = 8;//图片跟文字之间的间距
    self.topButton.imageEdgeInsets = UIEdgeInsetsMake(0, textSize.width + marginGay - imageSize.width, 0, - textSize.width - marginGay + imageSize.width);
    self.topButton.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width - marginGay, 0, imageSize.width + marginGay);
    //设置按钮内容靠右
    self.topButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
}

- (void)clearAction {
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UITableViewCell new];
}

- (UIButton *)topButton {
    if (!_topButton) {
        _topButton = ({
            UIButton * button =[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=CGRectMake(0, 0, 150, 30);
            button.titleLabel.font = [UIFont systemFontOfSize:16];
            [button setTitle:@"浏览历史浏览历史" forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"icon_x"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(showSelectionType) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _topButton;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 72;
//        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([@"" class]) bundle:nil] forCellReuseIdentifier:@""];
    }
    return _tableView;
}

- (CSBrowsingHistoryListViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [CSBrowsingHistoryListViewModel new];
    }
    return _viewModel;
}

@end
