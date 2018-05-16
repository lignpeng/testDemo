//
//  GExcelViewController.m
//  testDemo
//
//  Created by lignpeng on 2018/5/11.
//  Copyright © 2018年 genpeng. All rights reserved.
//

#import "GExcelViewController.h"

#import "UIExcelView.h"
#import "Masonry.h"

@interface GExcelViewController ()

@property(nonatomic, strong) UIExcelView *excelview;

@end

@implementation GExcelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initview];
}

- (void)initview {
    self.title = @"Excel 表";
    self.view.backgroundColor = [UIColor lightTextColor];
    [self.view addSubview:self.excelview];
    CGFloat margin = 16;
    CGFloat navigationbarHight = CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]) + CGRectGetHeight(self.navigationController.navigationBar.frame);

    self.excelview.frame = (CGRect){margin,margin+navigationbarHight,CGRectGetWidth(self.view.bounds)- 2*margin,CGRectGetHeight(self.view.bounds)-2*margin-navigationbarHight};
    [self createdata];
    self.automaticallyAdjustsScrollViewInsets = NO;
}


- (void)createdata {
    NSMutableArray *toparray = [NSMutableArray array];
    NSMutableArray *leftarray = [NSMutableArray array];
    NSMutableArray *tablearray = [NSMutableArray array];
    int colunm = 20;
    int row = 120;
    for (int i= 0; i < row; i++) {
        NSString *leftstr = [NSString stringWithFormat:@"行%3d",i];
        [leftarray addObject:leftstr];
        NSMutableArray *list = [NSMutableArray array];
        for (int j = 0; j < colunm; j++) {
            NSString *str = [NSString stringWithFormat:@"(%d,%d)",i,j];
            [list addObject:str];
        }
        [tablearray addObject:list];
    }
    for (int j = 0; j < colunm; j++) {
        NSString *topstr = [NSString stringWithFormat:@"列%2d",j];
        [toparray addObject:topstr];
    }
    self.excelview.topDataSource = toparray;
    self.excelview.leftDataSource = leftarray;
    self.excelview.tableViewDataSource = tablearray;
    [self.excelview show];
}


- (UIExcelView *)excelview {
    if (!_excelview) {
        _excelview = [[UIExcelView alloc] initWithFrame:(CGRect){0,0,100,100}];
        _excelview.colunm = 6;
        _excelview.row = 16;
    }
    return _excelview;
}

@end
