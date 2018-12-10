//
//  GPCellViewController.m
//  testDemo
//
//  Created by lignpeng on 16/12/2.
//  Copyright © 2016年 genpeng. All rights reserved.
//

#import "GPCellViewController.h"


#define cellIdentify @"cellReuse"

@interface GPCellViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) NSString *name;

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) NSArray *dataSource;
@property(nonatomic, assign) BOOL isNeed;
@end

@implementation GPCellViewController

- (NSArray *)dataSource {
    if (_dataSource) {
        return _dataSource;
    }
    _dataSource = @[];
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否要设置cell = nil" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cacelBlock = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.isNeed = NO;
    }];
    UIAlertAction *okBlock = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.isNeed = YES;
    }];
    [alertVC addAction:cacelBlock];
    [alertVC addAction:okBlock];
    [self.navigationController presentViewController:alertVC animated:true completion:nil];
    [self initView];
    
}

- (void)initView {
    self.view.backgroundColor = [UIColor blueColor];
    CGRect frame = self.view.bounds;
    CGFloat vheight = 120;
    self.tableView = [[UITableView alloc] initWithFrame:frame];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    [self.tableView registerNib:[UINib nibWithNibName:@"<#cellClassName#>" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellIdentify];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentify];
    self.tableView.rowHeight = 90;
    self.tableView.tableHeaderView = [UIView new];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), vheight)];
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < 3) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
        cell.textLabel.text = [NSString stringWithFormat:@"第 %ld 行",(long)indexPath.row];
        return cell;
    }
    if (self.isNeed) {
        return nil;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"blankCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"blankCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

