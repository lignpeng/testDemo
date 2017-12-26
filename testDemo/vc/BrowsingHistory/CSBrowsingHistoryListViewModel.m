//
//  CSBrowsingHistoryListViewModel.m
//  testDemo
//
//  Created by lignpeng on 2017/11/13.
//  Copyright © 2017年 genpeng. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CSBrowsingHistoryListViewModel.h"
#import "CSBrowingHistoryModel.h"

@interface CSBrowsingHistoryListViewModel()

@property(nonatomic, strong) NSMutableArray *dataSoure;//源数据
@property(nonatomic, strong) NSMutableArray *sectionsArray;//section数据
@property(nonatomic, strong) NSMutableDictionary *sectionsDictionary;//section对应的cell数据
@property(nonatomic, strong) NSMutableArray *selectDataSoure;//选择类型后的原数据

@end

@implementation CSBrowsingHistoryListViewModel

//标题
- (NSString *)browingHistoryTitle {
    NSArray *titleArray = @[@"浏览历史",@"机票搜索浏览历史",@"航班动态浏览历史"];
    return titleArray[self.type];
}

//无数据时的提示语
- (NSString *)blankInfomation {
    NSArray *titleArray = @[@"暂无浏览历史记录",@"暂无机票搜索浏览历史记录",@"暂无航班动态浏览历史记录"];
    return titleArray[self.type];
}

//有几个section
- (NSInteger)numberOfSections {
    
    return self.sectionsArray.count;
}
- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    NSArray *array = (NSArray *)[self.sectionsDictionary objectForKey:self.sectionsArray[section]];
    return array.count;
}
- (CSBrowingHistoryModel *)cellModelForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *array = (NSArray *)[self.sectionsDictionary objectForKey:self.sectionsArray[indexPath.section]];
    CSBrowingHistoryModel *model = array[indexPath.row];
    return model;
}

- (NSString *)sectionTitleForSection:(NSInteger)section {
    return self.sectionsArray[section];
}

//隐藏分割线
- (BOOL)isHiddenSeparatorViewAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *array = (NSArray *)[self.sectionsDictionary objectForKey:self.sectionsArray[indexPath.section]];
    return !(array.count-1-indexPath.row>0);
}

- (instancetype)init {
    if (self = [super init]) {
        self.type = BrowsingHistoryAll;
        [self createTempData];
        [self updataDataSoure];
    }
    return self;
}

- (NSMutableArray *)dataSoure {
    if (!_dataSoure) {
        _dataSoure = [NSMutableArray array];
    }
    return _dataSoure;
}

- (NSMutableArray *)sectionsArray {
    if (!_sectionsArray) {
        _sectionsArray = [NSMutableArray array];
    }
    return _sectionsArray;
}

- (NSMutableDictionary *)sectionsDictionary {
    if (!_sectionsDictionary) {
        _sectionsDictionary = [NSMutableDictionary dictionary];
    }
    return _sectionsDictionary;
}

- (NSMutableArray *)selectDataSoure {
    if (!_selectDataSoure) {
        _selectDataSoure = [NSMutableArray array];
    }
    return _selectDataSoure;
}

//创建临时数据
- (void)createTempData {
    for (int i=0; i<12; i++) {
        CSBrowingHistoryModel *model = [CSBrowingHistoryModel new];
        model.historyType = i%3;
        model.flightStartTime = [NSString stringWithFormat:@"2017-11-%d",14+i%3];
        model.flightStart = [NSString stringWithFormat:@"start-%d",i];
        model.flightEnd = [NSString stringWithFormat:@"start-%d",i];
        NSArray *airTypeArray = @[@"经济舱",@"明珠经济舱",@"公务舱",@"商务舱"];
        model.positionType = airTypeArray[i%airTypeArray.count];
        model.adultNum = i;
        model.childrenNum = i;
        [self.dataSoure addObject:model];
    }
}

//更新数据
- (void)updataDataSoure {
    //1、筛选出选择类型的数据
    [self.selectDataSoure removeAllObjects];
    switch (self.type) {
        case BrowsingHistoryAll:{
            if (self.dataSoure.count > 0) {
                [self.selectDataSoure addObjectsFromArray:self.dataSoure];
            }
        }break;
        case BrowsingHistoryTicket:{
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.historyType < 2"];
            NSArray *preArray = [self.dataSoure filteredArrayUsingPredicate:predicate];
            if (preArray.count > 0) {
                [self.selectDataSoure addObjectsFromArray:preArray];
            }
        }break;
        case BrowsingHistoryFlight:{
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.historyType == 2"];
            NSArray *preArray = [self.dataSoure filteredArrayUsingPredicate:predicate];
            if (preArray.count > 0) {
                [self.selectDataSoure addObjectsFromArray:preArray];
            }
        }break;
        default:{
            if (self.dataSoure.count > 0) {
                [self.selectDataSoure addObjectsFromArray:self.dataSoure];
            }
        }break;
    }
    //2、根据日期进行分类
    [self.sectionsArray removeAllObjects];
    for (CSBrowingHistoryModel *model in self.selectDataSoure) {
        if (![self.sectionsArray containsObject:model.flightStartTime]) {
            [self.sectionsArray addObject:model.flightStartTime];
        }
    }
    //3、筛选出同日期下的数据
    [self.sectionsDictionary removeAllObjects];
    for (NSString *timeString in self.sectionsArray) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.%@ == %@",@"flightStartTime",timeString];
        NSArray *predicateArray = [self.selectDataSoure filteredArrayUsingPredicate:predicate];
        if (predicateArray.count > 0) {
            [self.sectionsDictionary setObject:predicateArray forKey:timeString];
        }else {
            //没有数据时，要清理掉
        }
        
    }
}

//是否还有数据
- (BOOL)isHaveDataSoure {
    return self.selectDataSoure.count > 0;
}

@end



















