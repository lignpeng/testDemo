//
//  GGWebMenuModel.m
//  testDemo
//
//  Created by lignpeng on 2019/1/18.
//  Copyright © 2019年 genpeng. All rights reserved.
//

#import "GGWebMenuModel.h"

@implementation GGWebMenuModel

+ (NSArray *)webMenus {
    
    NSMutableArray *array = [NSMutableArray array];
    NSMutableArray *firstArray = [NSMutableArray array];
    NSMutableArray *secondArray = [NSMutableArray array];
    [array addObjectsFromArray:@[firstArray, secondArray]];
    
    GGWebMenuModel *updateModel = [GGWebMenuModel new];
    updateModel.title = @"刷新";
    updateModel.type = WebMenuTypeUpdate;
    updateModel.image = @"icon-update";
    [firstArray addObject:updateModel];
    [firstArray addObject:updateModel];
    
    GGWebMenuModel *friendModel = [GGWebMenuModel new];
    friendModel.title = @"好友";
    friendModel.type = WebMenuTypeShareforFriend;
    friendModel.image = @"icon-update";
    [secondArray addObject:friendModel];
    GGWebMenuModel *circleModel = [GGWebMenuModel new];
    circleModel.title = @"朋友圈";
    circleModel.type = WebMenuTypeShareforCircle;
    circleModel.image = @"icon-update";
    [secondArray addObject:circleModel];
    
    return array;
}


@end
