//
//  BuildListViewController.m
//  airport
//
//  Created by jinchangwang on 15/7/27.
//  Copyright (c) 2015年 jinchangwang. All rights reserved.
//

#import "BuildListViewController.h"
//#import "FloorListViewController.h"
#import "searchBarCustomView.h"
//#import "NavgationBar.h"
//#import "AirportSqlite.h"
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define HIGHT 667.0*self.view.bounds.size.height

@interface BuildListViewController ()<searchBarCustomViewDelegate>
{
    
}
@end

@implementation BuildListViewController
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // self.navigationController.navigationBarHidden = YES;
    [self showHistoryBuild];
}


- (void) popNavigationViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
  
}
- (void) popToRootViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"rtmapNotification" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [NavgationBar navgationBarController:self WithSelector:@selector(popNavigationViewController) WithRootSelector:@selector(popToRootViewController)  title:@"发现模式"];
    self.title = @"发现模式";
//    self.view.backgroundColor = [UIColor colorWithRed:0.929 green:0.941 blue:0.945 alpha:1.000];
    
//    NSArray *buildTextList = [AirportSqlite getAllBuildInfo];
    
    // 搜索部分
//    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 65, self.view.bounds.size.width, 50/HIGHT)];
//    searchView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:searchView];
    
//    searchBarCustomView *search = [[searchBarCustomView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50/HIGHT)];
//    search.ctl = self;
//    search.type = SearchBuild;
//    search.placeholder = @"输入或选择机场及航站楼名称";
//    search.delegate = self;
//    search.backgroundColor = [UIColor colorWithRed:0.929 green:0.941 blue:0.945 alpha:1.000];
//    [searchView addSubview:search];
    
    // 常见机场
    UILabel *commonAirportLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 110, self.view.bounds.size.width, 40)];
    commonAirportLable.text = @"常见机场";
    commonAirportLable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:commonAirportLable];
    
    UIView *upLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 140, self.view.bounds.size.width, 2)];
    upLineView.backgroundColor = [UIColor colorWithRed:0.922 green:0.933 blue:0.929 alpha:1.000];
    [self.view addSubview:upLineView];
    
//    for(int i=0;i<buildTextList.count;i++){
//        AirportSqlite *sqlite = [buildTextList objectAtIndex:i];
//        UIButton *airPortBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        airPortBtn.frame = CGRectMake(10, 150+i*40, self.view.bounds.size.width-20, 40);
//        airPortBtn.backgroundColor = [UIColor whiteColor];
//        [airPortBtn setTitle:sqlite.buildName forState:UIControlStateNormal];
//        airPortBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
//        airPortBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
//        airPortBtn.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
//        [airPortBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        [airPortBtn addTarget:self action:@selector(touchAirPortBtn:) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:airPortBtn];
//    }
    
    // 历史纪录
    UILabel *historyLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 350, self.view.bounds.size.width, 40)];
    historyLable.text = @"历史纪录";
    historyLable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:historyLable];
    
    UIView *downLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 380, self.view.bounds.size.width, 2)];
    downLineView.backgroundColor = [UIColor colorWithRed:0.922 green:0.933 blue:0.929 alpha:1.000];
    [self.view addSubview:downLineView];
    // 显示历史建筑物列表
    [self showHistoryBuild];
}

- (void) showHistoryBuild {
    
    for(id view in [self.view subviews])
    {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton*)view;
            if(btn.tag>=1000){
                [btn removeFromSuperview];
            }
        }
    }
    
    NSArray *historyArrays = @[@"1",@"2",@"1",@"2",@"1",@"2",@"1",@"2",@"1",@"2",@"1",@"2"];
    NSInteger historyCount = historyArrays.count;
    if(iPhone4 && historyArrays.count>3){
        historyCount = 3;
    }
    
    for(int i=0;i<historyCount;i++){
        UIButton *historyAirPortBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        historyAirPortBtn.frame = CGRectMake(10, 390+i*40, self.view.bounds.size.width-20, 40);
        historyAirPortBtn.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
        historyAirPortBtn.backgroundColor = [UIColor whiteColor];
        historyAirPortBtn.tag = 100+i;
        [historyAirPortBtn setTitle:[historyArrays objectAtIndex:i] forState:UIControlStateNormal];
        historyAirPortBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        historyAirPortBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        [historyAirPortBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [historyAirPortBtn addTarget:self action:@selector(touchAirPortBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:historyAirPortBtn];
    }
}


- (void) touchAirPortBtn:(UIButton*)btn {
    //点击后的建筑物保存到历史纪录里
//    [self savhistoryBuildName:btn.currentTitle];
    
//    [self jumpToNextControllerWithbuildName:btn.currentTitle];
}
/*
-(void)jumpToNextControllerWithbuildName:(NSString *)buildName {
    FloorListViewController *floorCV = [[FloorListViewController alloc] init];
    floorCV.buildName = buildName;
    [self.navigationController pushViewController:floorCV animated:YES];
}

- (void) savhistoryBuildName:(NSString*)selectbuildName{
    NSMutableArray *historyArrays = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"history"]];
    
    if(!historyArrays){
        historyArrays = [[NSMutableArray alloc] init];
    }
    if(historyArrays.count<4){
        BOOL _isSame = NO;
        for(NSString *buildName in historyArrays){
            if([selectbuildName isEqualToString:buildName]){
                _isSame = YES;
                break;
            }
        }
        if(!_isSame){
            [historyArrays addObject:selectbuildName];
        }
        
    }else {
        
        for(int i = 0;i<historyArrays.count;i++){
            NSString *buildName = [historyArrays objectAtIndex:i];
            if([buildName isEqualToString:selectbuildName]){
                
                [historyArrays removeObjectAtIndex:i];
                [historyArrays insertObject:selectbuildName atIndex:0];
                break;
            }
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:historyArrays forKey:@"history"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - searchBarCustomViewDelegate

- (void) selectBuild:(AirportSqlite *)buildSqlite {
    [self savhistoryBuildName:buildSqlite.buildName];
    FloorListViewController *floorCV = [[FloorListViewController alloc] init];
    floorCV.buildName = buildSqlite.buildName;
    [self.navigationController pushViewController:floorCV animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
*/
@end
