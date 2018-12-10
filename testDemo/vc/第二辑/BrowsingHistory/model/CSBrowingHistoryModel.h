//
//  CSBrowingHistoryModel.h
//  testDemo
//
//  Created by lignpeng on 2017/11/17.
//  Copyright © 2017年 genpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSBrowingHistoryMarco.h"

@interface CSBrowingHistoryModel : NSObject

@property(nonatomic, assign)BrowsingHistoryType historyType;//查询类型，浏览类型：机票兑换：0、机票预订：1、航班动态：2
//@property(nonatomic, assign) NSUInteger ticketType;//机票搜索类型，机票预订：0，机票兑换：1
@property(nonatomic, strong) NSString *flightStartTime;//时间
@property(nonatomic, strong) NSString *flightStart;//起始点
@property(nonatomic, strong) NSString *flightEnd;//终点
@property(nonatomic, strong) NSString *positionType;//仓位类型：经济舱、明珠经济舱、公务舱、商务舱等
@property(nonatomic, assign) NSUInteger adultNum;//成年乘机人数量：
@property(nonatomic, assign) NSUInteger childrenNum;//儿童乘机人数量：
@property(nonatomic, assign) NSUInteger flightType;//单程：0，往返程：1

@end



















