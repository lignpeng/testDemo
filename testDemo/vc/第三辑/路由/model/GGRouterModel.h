//
//  GGRouterModel.h
//  testDemo
//
//  Created by lignpeng on 2019/1/7.
//  Copyright © 2019年 genpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@protocol GGComponentModel;
@protocol NSString;

@interface GGRouterModel : JSONModel

@property(nonatomic, strong) NSString *version;
@property(nonatomic, strong) NSArray<GGComponentModel> *componentList;

@end

@interface GGComponentModel : JSONModel
    
@property(nonatomic, strong) NSString *url;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *classType;
@property(nonatomic, strong) NSString *className;//类名
@property(nonatomic, strong) NSString *info;
@property(nonatomic, strong) NSDictionary *actions;//实例对象方法
@property(nonatomic, strong) NSDictionary *classActions;//类方法
@end

@interface GGRouterUrl : NSObject

@property(nonatomic, strong) NSString *url;
@property(nonatomic, strong) NSString *scheme;
@property(nonatomic, strong) NSMutableArray *actions;
@property(nonatomic, strong) NSMutableArray *classActions;
@property(nonatomic, strong) NSDictionary *param;

//创建urll对象
/*
 url: scheme://dataModel/classAction=create#action=add&&action=sum
 dataModel：组件名
 classAction：表示类方法
 classAction=create：调用create类方法
 #：分割类方法、实例方法
 action：表示实例对象方法
 action=add&&action=sum：依次调用add、sum实例方法
 */

+ (instancetype)routerUrlWithUrl:(NSString *)url;

@end
