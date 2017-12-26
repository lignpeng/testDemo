//
//  CSBrowingHistoryMarco.h
//  testDemo
//
//  Created by lignpeng on 2017/11/16.
//  Copyright © 2017年 genpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
//浏览类型：全部，机票、航班动态
typedef NS_ENUM(NSUInteger, BrowsingType) {
    BrowsingHistoryAll = 0,
    BrowsingHistoryTicket = 1,
    BrowsingHistoryFlight = 2
};


//具体的浏览类型：机票兑换：0、机票预订：1、航班动态：2
typedef NS_ENUM(NSUInteger, BrowsingHistoryType) {
    BrowsingHistoryTicketExchange = 0,
    BrowsingHistoryTicketBooking = 1,
    BrowsingHistoryFlightNews = 2
};

