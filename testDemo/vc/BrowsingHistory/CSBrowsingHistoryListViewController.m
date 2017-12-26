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
#import "CSBrowingHistoryAirPortCell.h"
#import "CSBrowingHistoryFlightNumberCell.h"
#import "CSBrowingHistoryBlankView.h"
#import "HexColor.h"
#import "CSBrowingHistoryModel.h"


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
    self.view.backgroundColor = [HXColor colorWith8BitRedN:239 green:242 blue:245];
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
    [self updateView];
}

- (void)updateView {
    [self.viewModel updataDataSoure];
    if (![self.viewModel isHaveDataSoure]) {
        self.navigationItem.rightBarButtonItem = nil;
        [CSBrowingHistoryBlankView showWithTitle:[self.viewModel blankInfomation] delegate:self];
    }else {
        [CSBrowingHistoryBlankView dismissWithDelegate:self];
        [self showRightBarButtonItem];
    }
    [self.tableView reloadData];
}

- (void)showRightBarButtonItem {
    if (![self.viewModel isHaveDataSoure]) {
        self.navigationItem.rightBarButtonItem = nil;
        return;
    }
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
    [CSBrowsingHistoryTypeView showBrowsingHistoryTypeViewWithDelegate:self Type:self.viewModel.type complishBlock:^(BrowsingType type) {
        NSLog(@"type = %lu",(unsigned long)type);
        weakSelf.viewModel.type = type;
//        [weakSelf showRightBarButtonItem];
        [weakSelf.topButton setTitle:[weakSelf.viewModel browingHistoryTitle] forState:UIControlStateNormal];
        [weakSelf.topButton setImage:[UIImage imageNamed:@"icon_x"] forState:UIControlStateNormal];
        [weakSelf updateButtonContentAction];
        [weakSelf updateView];
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
    return [self.viewModel numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
//    }
    CSBrowingHistoryAirPortCell *cell = [CSBrowingHistoryAirPortCell browingHistoryAirPortCellWithTableView:tableView];
    CSBrowingHistoryModel *model = [self.viewModel cellModelForRowAtIndexPath:indexPath];
    [cell setupBrowingHistoryCellWithModel:model];
    [cell hiddenSeparatorView:[self.viewModel isHiddenSeparatorViewAtIndexPath:indexPath]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return [self.viewModel heightForHeaderInSection:section];
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGFloat headerHeight = [self tableView:tableView heightForHeaderInSection:section];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds) - 20, headerHeight)];
//    headerView.backgroundColor = RGBCOLOR(238, 242, 245);
    headerView.backgroundColor = [UIColor clearColor];
    UILabel *label = [UILabel new];
    [headerView addSubview:label];
//    label.textColor = textLabelColor;
    label.backgroundColor= [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14];
    label.numberOfLines = 0;
    label.text = [self.viewModel sectionTitleForSection:section];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(headerView).offset(16);
        make.trailing.equalTo(headerView).offset(-16);
        make.top.equalTo(headerView);
        make.bottom.equalTo(headerView.mas_bottom);
    }];
    return headerView;
}

- (UIButton *)topButton {
    if (!_topButton) {
        _topButton = ({
            UIButton * button =[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=CGRectMake(0, 0, 150, 30);
            button.titleLabel.font = [UIFont systemFontOfSize:16];
            [button setTitle:[self.viewModel browingHistoryTitle] forState:UIControlStateNormal];
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 80;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CSBrowingHistoryAirPortCell class]) bundle:nil] forCellReuseIdentifier:kCSBrowingHistoryAirPortCell];
        _tableView.tableFooterView = [UIView new];
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
