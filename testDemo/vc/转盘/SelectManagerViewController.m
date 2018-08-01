//
//  SelectManagerViewController.m
//  testDemo
//
//  Created by lignpeng on 2018/7/11.
//  Copyright © 2018年 genpeng. All rights reserved.
//

#import "SelectManagerViewController.h"
#import "SelectPanViewController.h"
#import "GPTableViewCell.h"
#import "HexColor.h"
#import "LabelModel.h"
#import <Realm/Realm.h>
#import "FileTools.h"

@interface SelectManagerViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *imageArray;
@property(nonatomic, strong) RLMResults *dataSource;

@end

@implementation SelectManagerViewController

- (NSArray *)imageArray {
    if (_imageArray) {
        return _imageArray;
    }
    _imageArray = [[NSBundle mainBundle] pathsForResourcesOfType:@"png" inDirectory:@"xiaohuangren"];
    return _imageArray;
}

- (RLMResults *)dataSource {
    if (!_dataSource) {
        _dataSource = [ActionResult allObjects];
        [_dataSource sortedResultsUsingKeyPath:@"date" ascending:YES];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [FileTools configDefaultRealmDBWithdbName:labelRealm];
    [self initView];
//    [self.tableView reloadData];
}

- (void)initView {
    self.title = @"testDemo";
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect frame = self.view.bounds;
    CGFloat vheight = 120;
    self.tableView = [[UITableView alloc] initWithFrame:frame];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"GPTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellIdentify];
    self.tableView.rowHeight = 72;
    self.tableView.tableHeaderView = [UIView new];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), vheight)];
    [self.view addSubview:self.tableView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAction)];
}

- (void)addAction {
    SelectPanViewController *vc = [SelectPanViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidLayoutSubviews {
    self.tableView.frame = self.view.bounds;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.iconImageView.image = [UIImage imageWithContentsOfFile:self.imageArray[arc4random() % self.imageArray.count]];
    cell.backgroundColor = [UIColor colorWith8BitRedN:arc4random()%256 green:arc4random()%256 blue:arc4random()%256 alpha:0.45];
    ActionResult *result = self.dataSource[indexPath.row];
    cell.titleLabel.text = result.name;
    cell.infoLabel.text = [result.bestStr stringByAppendingFormat:@"，%@",result.date];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ActionResult *result = self.dataSource[indexPath.row];
    SelectPanViewController *vc = [SelectPanViewController new];
    vc.actionResult = result;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
