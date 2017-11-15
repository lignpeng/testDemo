//
//  CSBrowsingHistoryListViewModel.h
//  testDemo
//
//  Created by lignpeng on 2017/11/13.
//  Copyright © 2017年 genpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

enum BrowsingHistoryType {
    BrowsingHistoryAll = 0,
    BrowsingHistorySearoch = 1,
};


@interface CSBrowsingHistoryListViewModel : NSObject

@property(nonatomic, strong) NSMutableArray *dataSoure;

@end
