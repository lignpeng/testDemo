//
//  CSBrowsingHistoryListViewModel.h
//  testDemo
//
//  Created by lignpeng on 2017/11/13.
//  Copyright © 2017年 genpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSBrowingHistoryMarco.h"

@class CSBrowingHistoryModel;

@interface CSBrowsingHistoryListViewModel : NSObject

@property(nonatomic, assign) BrowsingType type;

//更新数据
- (void)updataDataSoure;
//是否还有数据
- (BOOL)isHaveDataSoure;
//标题
- (NSString *)browingHistoryTitle;
//无数据时的提示语
- (NSString *)blankInfomation;

//有几个section
- (NSInteger)numberOfSections;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;
- (CSBrowingHistoryModel *)cellModelForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)sectionTitleForSection:(NSInteger)section;
//隐藏分割线
- (BOOL)isHiddenSeparatorViewAtIndexPath:(NSIndexPath *)indexPath;

@end
