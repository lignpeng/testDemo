//
//  CSPopoverController.m
//  testDemo
//
//  Created by lignpeng on 2017/9/5.
//  Copyright © 2017年 genpeng. All rights reserved.
//

#import "CSPopoverController.h"

@interface CSPopoverController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView; // 省份tableView

@property (nonatomic, strong) NSArray *dataSource;           // 省份数据源

@end

@implementation CSPopoverController

- (void)viewDidLoad {

    [self initView];
}

- (void)initView {
    [self.view addSubview:self.tableView];
}

//重写preferredContentSize，让popover返回你期望的大小
- (CGSize)preferredContentSize {
    return CGSizeMake(150, 300);
}

- (NSArray *)dataSource {
    if (!_dataSource) {
        _dataSource = @[@"河南", @"河北", @"江苏", @"浙江", @"广东"];
    }
    return _dataSource;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"master"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"master"];
    }
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

@end
