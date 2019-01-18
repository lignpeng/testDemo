//
//  GGWebMenuModel.h
//  testDemo
//
//  Created by lignpeng on 2019/1/18.
//  Copyright © 2019年 genpeng. All rights reserved.
//


#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,WebMenuType) {
    WebMenuTypeUpdate,
    WebMenuTypeShareforFriend,
    WebMenuTypeShareforCircle
};

@interface GGWebMenuModel : NSObject

@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *image;
@property(nonatomic, assign) WebMenuType type;

+ (NSArray *)webMenus;

@end

