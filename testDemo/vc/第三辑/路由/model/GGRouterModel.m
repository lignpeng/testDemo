//
//  GGRouterModel.m
//  testDemo
//
//  Created by lignpeng on 2019/1/7.
//  Copyright © 2019年 genpeng. All rights reserved.
//

#import "GGRouterModel.h"

@implementation GGRouterModel
    
+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}
    
@end

@implementation GGComponentModel
    
+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}
    
@end

//常量表
static NSString *kScheme = @"scheme://";
static NSString *kSeparatorScheme = @"/";
static NSString *kSeparatorAction = @"#";
static NSString *kAction = @"action";
static NSString *kClassAction = @"classAction";
static NSString *kSeparatorMethod = @"&&";
static NSString *kActionValue = @"=";

@implementation GGRouterUrl
/*
 url: scheme://dataModel/classAction=create#action=add&&action=sum
 dataModel：组件名
 classAction：表示类方法
 classAction=create：create为类方法的key，根据key获取对应的类方法
 #：分割类方法、实例方法
 action：表示实例对象方法
 action=add&&action=sum：add、sum实例方法的key，依次调用add、sum指向的实例方法
 */
+ (instancetype)routerUrlWithUrl:(NSString *)url {
    GGRouterUrl *routerUrl = [GGRouterUrl new];
    [routerUrl config:url];
    return routerUrl;
}
//解析URL
- (void)config:(NSString *)url {
    self.url = url;
    if (![url hasPrefix:kScheme]) {
        return ;
    }
    NSString *subStr = [url substringFromIndex:kScheme.length];
    NSArray *array = [subStr componentsSeparatedByString:kSeparatorScheme];
    if (array.count > 0) {
        self.scheme = array.firstObject;
        if (array.count >= 2) {
            NSString *actionStr = array[1];
            [self configAction:actionStr];
        }
    }
}
//解析方法
- (void)configAction:(NSString *)url {
    if (url.length == 0) {
        return;
    }
    NSArray *array = [url componentsSeparatedByString:kSeparatorAction];
    for (NSString *item in array) {
        if ([item containsString:kClassAction]) {
            [self configClassAction:item];
        }else if ([item containsString:kAction]){
            [self configObjAction:item];
        }
    }
    [self removeSpaceValue:self.actions];
    [self removeSpaceValue:self.classActions];
}

//解析类方法
- (void)configClassAction:(NSString *)actionStr {
    [self.classActions removeAllObjects];
    NSArray *actionArray = [actionStr componentsSeparatedByString:kSeparatorMethod];
    for (NSString *subStr in actionArray) {
        NSArray *array = [subStr componentsSeparatedByString:[NSString stringWithFormat:@"%@%@",kClassAction,kActionValue]];
        if (array.count > 0) {
            [self.classActions addObjectsFromArray:array];
        }
    }
}

//解析实例方法
- (void)configObjAction:(NSString *)actionStr {
    [self.actions removeAllObjects];
    NSArray *actionArray = [actionStr componentsSeparatedByString:kSeparatorMethod];
    for (NSString *subStr in actionArray) {
        NSArray *array = [subStr componentsSeparatedByString:[NSString stringWithFormat:@"%@%@",kAction,kActionValue]];
        if (array.count > 0) {
            [self.actions addObjectsFromArray:array];
        }
    }
}

//移除空字符串
- (void)removeSpaceValue:(NSMutableArray *)orgArray {
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"self = %@",@""];
    NSArray *array = [orgArray filteredArrayUsingPredicate:pre];
    if (array.count > 0) {
        [orgArray removeObjectsInArray:array];
    }
}

- (NSMutableArray *)actions {
    if (!_actions) {
        _actions = [NSMutableArray array];
    }
    return _actions;
}

- (NSMutableArray *)classActions {
    if (!_classActions) {
        _classActions = [NSMutableArray array];
    }
    return _classActions;
}

@end
