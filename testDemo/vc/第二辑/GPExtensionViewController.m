//
//  GPExtensionViewController.m
//  testDemo
//
//  Created by lignpeng on 16/11/30.
//  Copyright © 2016年 genpeng. All rights reserved.
//

#import "GPExtensionViewController.h"
#import "GPExtensionTableViewCell.h"

#define cellIdentify @"cellReuse"

@interface GPExtensionViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) NSString *name;

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) NSArray *dataSource;

@property(nonatomic, strong) NSArray *infoArray;
@property(nonatomic, strong) NSMutableArray *statusArray;

@end

@implementation GPExtensionViewController

- (NSArray *)dataSource {
    if (_dataSource) {
        return _dataSource;
    }
    _dataSource = @[@"12345"];
    return _dataSource;
}

- (NSArray *)infoArray {
    if (_infoArray) {
        return _infoArray;
    }
    _infoArray = @[@"LabelLabelLabelLabelLabelLabelLabel\nLabelLabelLabelLabelLabelLabelLabelLabel\nLabelLabelLabelLabelLabelLabelLabel\nLabelLabelLabelLabelLabelLabelLabel\nLabelLabelLabelLabelLabelLabelLabel"];
    return _infoArray;
}

- (NSMutableArray *)statusArray {
    if (_statusArray) {
        return _statusArray;
    }
    _statusArray = [NSMutableArray array];
    [_statusArray addObject:@100];
    return _statusArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
}

- (void)initView {
    self.view.backgroundColor = [UIColor blueColor];
    CGRect frame = self.view.bounds;
    CGFloat vheight = 120;
    self.tableView = [[UITableView alloc] initWithFrame:frame];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"GPExtensionTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellIdentify];
    
    self.tableView.estimatedRowHeight = 90;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableHeaderView = [UIView new];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), vheight)];
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GPExtensionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    cell.titleLabel.text = self.dataSource[indexPath.row];
    NSNumber *status = self.statusArray[indexPath.row];
    [cell setCellExtensionStatus:status.boolValue infoString:self.infoArray[indexPath.row]];
    __weak typeof(self) weakSelf = self;
    cell.actionBlock = ^(BOOL status, UITableViewCell *cell){
        NSLog(@"status : %d",status);
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf extensionCell:cell status:status];
        });
        
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//修改展开状态
- (void)extensionCell:(UITableViewCell *)cell status:(BOOL)status {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    self.statusArray[indexPath.row] = status? @1 : @0;

    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}


@end

