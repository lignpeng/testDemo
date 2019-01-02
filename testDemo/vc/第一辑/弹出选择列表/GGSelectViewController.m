//
//  GGSelectViewController.m
//  testDemo
//
//  Created by lignpeng on 2017/9/5.
//  Copyright © 2017年 genpeng. All rights reserved.
//

#import "GGSelectViewController.h"
#import "GPTableViewCell.h"
#define cellIdentify @"cellReuse"
#import "UISelectListView.h"

@interface GGSelectViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) NSString *name;

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *imageArray;
@property(nonatomic, strong) NSArray *colorArray;
@property(nonatomic, strong) NSArray *vcArray;
@property(nonatomic, strong) NSArray *vcTitleArray;

@end

@implementation GGSelectViewController

- (NSArray *)imageArray {
    if (_imageArray) {
        return _imageArray;
    }
    _imageArray = [[NSBundle mainBundle] pathsForResourcesOfType:@"png" inDirectory:@"Resource/png"];
    return _imageArray;
}

- (NSArray *)colorArray {
    if (_colorArray) {
        return _colorArray;
    }
    _colorArray = @[[UIColor colorWithRed:248/255.0 green:251/255.0 blue:1 alpha:1],[UIColor colorWithRed:3/255.0 green:223/255.0 blue:71/255.0 alpha:0.8],[UIColor lightGrayColor],[UIColor whiteColor]];
    return _colorArray;
}

- (NSArray *)vcArray {
    if (_vcArray) {
        return _vcArray;
    }
    _vcArray = @[@"ModelViewController",@"GGXibViewController",
                 @"CalulateImageViewController",@"GGPredicateViewController",
                 @"GGDateViewController",@"GGBlockViewController",
                 @"GGVIPDayViewController",@"GGSelectViewController"];
    return _vcArray;
}

- (NSArray *)vcTitleArray {
    if (_vcTitleArray) {
        return _vcTitleArray;
    }
    _vcTitleArray = @[@"对象转模型",@"xib使用",@"计算图片大小",@"谓词predicate",
                      @"时间校验",@"block多层回调",@"会员日弹框",@"弹出选择列表"];
    return _vcTitleArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    self.title = @"弹出选择列表";
    self.view.backgroundColor = [UIColor blueColor];
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
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.vcArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.iconImageView.image = [UIImage imageWithContentsOfFile:self.imageArray[arc4random() % self.imageArray.count]];
    cell.backgroundColor = self.colorArray[indexPath.row%self.colorArray.count];
    cell.titleLabel.text = self.vcTitleArray[self.vcTitleArray.count - 1 - indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CGRect frame = [tableView cellForRowAtIndexPath:indexPath].frame;
    frame.origin.y += CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]);
    frame.origin.y += CGRectGetHeight(self.navigationController.navigationBar.frame);
//    [UISelectListView showSelectListViewWithSourceRect:frame];
//    [UISelectListView showSelectListViewWithSourceRect:frame delegate:self complishBlock:^(NSString *str) {
//        NSLog(@"str = %@",str);
//    }];
    //@"1",@"2",@"3"
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
    [mutableDic setDictionary:@{@"1":@"1",@"2":@"2",@"3":@"3"}];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:mutableDic];
    
    [UISelectListView showSelectListViewWithDataSoucre:@[] SourceRect:frame delegate:self complishBlock:^(NSString *str) {
        NSLog(@"str = %@",str);
    }];
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [UISelectListView removeSelectListView:self];
//}


@end
