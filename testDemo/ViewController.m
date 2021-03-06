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
#import "UINameListPickerView.h"
#import "UILabelsViewController.h"
#import "UIURLAlertView.h"
#import "SelectPanViewController.h"
#import "HexColor.h"
#import "UIEditTextFieldView.h"
#import "GPTools.h"
#import "UIClipImageViewController.h"


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) NSString *name;

@property(nonatomic, strong) UITableView *tableView;
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
    _vcArray = @[@"IDViewController",@"GPExtensionViewController",
                 @"GPNullViewController",@"GPCellViewController",
                 @"LoadingViewController",@"GPTimeViewController",
                 @"GPSelectSeatViewController",@"ArrayEnumViewController",
                 @"SearchBarViewController",@"SinaWBSendingViewController",
                 @"DataBindingViewController",@"AlipayViewController",
                 @"AttributeLabelViewController",@"GPKeyBoardViewController",
                 @"GPVideoViewController",@"GPTableViewController",
                 @"GPGIFViewController",@"GPPopViewController",
                 @"ModelViewController",@"GGXibViewController",
                 @"CalulateImageViewController",@"GGPredicateViewController",
                 @"GGDateViewController",@"GGBlockViewController",
                 @"GGVIPDayViewController",@"GGSelectViewController",
                 @"GGMLeakViewController",@"GGSpaceViewController",
                 @"CSBrowsingHistoryListViewController",@"GGStringViewController",
                 @"GGRunTimeMethodViewController",@"TimezoneViewController",
                 @"GExcelViewController",@"RiseUpCalcViewController",
                 @"SelectManagerViewController",@"UISelectImageViewController",
                 @"UIClipImageViewController",@"EMailCheckViewController",
                 @"TimeCheckViewController",@"UIShapeImageClipViewController",
                 @"UIDataModelViewController"];
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
                      @"支付宝网页拦截native支付",@"富文本",@"键盘弹起",@"摄像",
                      @"tableView操作",@"播放gif",@"弹出viewController",
                      @"对象转模型",@"xib使用",@"计算图片大小",@"谓词predicate",
                      @"时间校验",@"block多层回调",@"会员日弹框",@"弹出选择列表",
                      @"MLeakFinder使用",@"去空格",@"浏览历史",@"字符串包含",
                      @"runtime调用方法",@"获取当前时区",@"excel表",@"复利计算",
                      @"转盘",@"文字识别",@"图片裁剪",@"邮箱校验",@"年龄计算",
                      @"图案裁剪",@"数据解析"];
    return _vcTitleArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
//    [CSNoviceGuideView showNoviceGuideWithAnimated:YES];
}

- (void)initView {
    self.title = [@"testDemo" stringByAppendingFormat:@":%lu个",(unsigned long)self.vcArray.count];
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

- (void)viewDidLayoutSubviews {
    self.tableView.frame = self.view.bounds;
}

- (void)guideAction {
//    [CSNoviceGuideView showNoviceGuideWithAnimated:YES];
//    [UINameListPickerView nameListPickerView];
    NSLog(@"***-------------***");
//    [UINameListPickerView nameListPickerView:^(NSInteger section, NSInteger index, NSString *name) {
//        NSLog(@"section = %ld index = %ld name = %@",(long)section,(long)index,name);
//    }];
//    [UINameListPickerView nameListPickerView:self.vcTitleArray complish:^(NSInteger index, NSString *name) {
//        NSLog(@"index = %ld name = %@",(long)index,name);
//    }];
//    __weak typeof(self) weakSelf = self;
//    [UINameListPickerView nameListPickerView:self.vcTitleArray selectedIndex:0 complish:^(NSInteger index, NSString *name) {
//        NSLog(@"index = %ld name = %@",(long)index,name);
//        UIViewController *vc = [NSClassFromString(weakSelf.vcArray[index]) new];
//        vc.title = weakSelf.vcTitleArray[index];
//        [weakSelf.navigationController pushViewController:vc animated:YES];
//    }];
    
//    [CSURLAlertView urlAlertView];
//    NSString *titleStr = @"您还未添加身份证，进行身份认证。";
//    NSString *textStr = @"身份认证";
//    [CSURLAlertView urlAlertView:titleStr urlString:textStr complish:nil];
//    [CSURLAlertView urlAlertView:titleStr urlString:textStr buttonTitle:@"知道了" complish:^(BOOL flag) {
//        NSLog(@"***------000000-------***");
//    }];
//    NSLog(@"***-------------***");
    
//    UILabelsViewController *vc = [UILabelsViewController new];
//    SelectPanViewController *vc = [SelectPanViewController new];
//    [self.navigationController pushViewController:vc animated:YES];
//    [UIEditTextFieldView editTextFieldWithTitle:@"输入标题" editStr:nil complish:^(NSString *text) {
//        NSLog(@"%@",text);
//    } cancelBlock:nil];
//    [UIEditTextFieldView editTextFieldWithTitle:@"输入标题" editStr:nil complish:^(NSString *text) {
//        NSLog(@"%@",text);
//    } cancelBlock:nil];
    
    [GPTools ShowInfoTitle:@"提醒" message:@"OK" delayTime:0.2];
//    UIClipImageViewController *vc = [UIClipImageViewController new];
//    [self.navigationController pushViewController:vc animated:YES];
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
    cell.backgroundColor = [UIColor colorWith8BitRed:arc4random()%256 green:arc4random()%256 blue:arc4random()%256 alpha:0.45];
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
