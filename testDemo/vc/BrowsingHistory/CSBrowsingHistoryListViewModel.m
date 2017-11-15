//
//  CSBrowsingHistoryListViewModel.m
//  testDemo
//
//  Created by lignpeng on 2017/11/13.
//  Copyright © 2017年 genpeng. All rights reserved.
//

#import "CSBrowsingHistoryListViewModel.h"

@implementation CSBrowsingHistoryListViewModel

- (NSMutableArray *)dataSoure {
    if (!_dataSoure) {
        _dataSoure = [NSMutableArray array];
    }
    return _dataSoure;
}


@end
