//
//  ViewController.m
//  testDemo
//
//  Created by genpeng on 16/11/23.
//  Copyright © 2016年 genpeng. All rights reserved.
//

#import "ViewController.h"
#import "GPTableViewCell.h"
#import "GPExtensionViewController.h"
#import "CSNoviceGuideView.h"
#define cellIdentify @"cellReuse"


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) NSString *name;

@property(nonatomic, strong) UITableView *tableView;

//@property(nonatomic, strong) NSMutableArray *array;
@property(nonatomic, strong) NSArray *imageArray;
@property(nonatomic, strong) NSArray *colorArray;
@property(nonatomic, strong) NSArray *vcArray;
@property(nonatomic, strong) NSArray *vcTitleArray;

@end

@implementation ViewController

- (NSArray *)imageArray {
    if (_imageArray) {
        return _imageArray;
    }
    _imageArray = [[NSBundle mainBundle] pathsForResourcesOfType:@"png" inDirectory:@"png"];
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
    _vcArray = @[@"IDViewController",@"GPExtensionViewController",
                 @"GPNullViewController",@"GPCellViewController",
                 @"LoadingViewController",@"GPTimeViewController",
                 @"GPSelectSeatViewController",@"ArrayEnumViewController",
                 @"SearchBarViewController",@"SinaWBSendingViewController",
                 @"DataBindingViewController",@"AlipayViewController",
                 @"AttributeLabelViewController",@"GPKeyBoardViewController",
                 @"GPVideoViewController"];
    return _vcArray; 
}

- (NSArray *)vcTitleArray {
    if (_vcTitleArray) {
        return _vcTitleArray;
    }
    _vcTitleArray = @[@"身份证验证",@"扩展view",@"nil、NULL的区别",
                      @"tableViewCell传：nil",@"图片旋转",@"倒计时60s",
                      @"选座排座",@"数组枚举",
                      @"搜索bar",@"微博分享",@"数据绑定：RZDataBinding",
                      @"支付宝网页拦截native支付",@"富文本",@"键盘弹起",@"摄像"];
    return _vcTitleArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
//    [CSNoviceGuideView showNoviceGuideWithAnimated:YES];
}

- (void)initView {
    self.title = @"testDemo";
    self.view.backgroundColor = [UIColor blueColor];
    CGRect frame = self.view.bounds;
    CGFloat vheight = 120;
    self.tableView = [[UITableView alloc] initWithFrame:frame];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"GPTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellIdentify];
    self.tableView.rowHeight = 72;
    self.tableView.tableHeaderView = [UIView new];
    //[[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), 30)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), vheight)];
    [self.view addSubview:self.tableView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"引导" style:UIBarButtonItemStylePlain target:self action:@selector(guideAction)];
}

- (void)guideAction {
    [CSNoviceGuideView showNoviceGuideWithAnimated:YES];
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
    UIViewController *vc = [[NSClassFromString(self.vcArray[self.vcArray.count - 1 - indexPath.row]) alloc] init];
    vc.title = self.vcTitleArray[self.vcTitleArray.count - 1 -indexPath.row];
//    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.navigationController pushViewController:vc animated:YES];
//    [self presentViewController:navi animated:YES completion:nil];
}




@end
