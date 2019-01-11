//
//  GGRouter.h
//  testDemo
//
//  Created by lignpeng on 2019/1/7.
//  Copyright © 2019年 genpeng. All rights reserved.
//
/*
 1、单例模式，APP启动时就要进行初始化：加载URL配置表
 2、注册表：注册URL，每个注册表里有对应的URL配置获取路径
 3、URL配置信息：提供可供调用接口方法，有无传参
 4、根据方法传参调用，并弹出
 */



#import <Foundation/Foundation.h>

@interface GGRouter : NSObject

+ (instancetype)ggRouter;
//启动路由
+ (void)startRouter;

/*
 1、url格式: scheme://dataModel/classAction=create#action=add&&action=sum
 1）dataModel：组件名
 2）classAction：表示类方法
 3）classAction=create：create为类方法的key，根据key获取对应的类方法
 4）#：分割类方法、实例方法
 5）action：表示实例对象方法
 6）action=add&&action=sum：：add、sum实例方法的key，依次调用add、sum指向的实例方法
 7）&&：区分方法
 2、param：传参，数组存储，方法的执行的先后顺序依次放入即可
 1）结构：
 {
    @“create”:@[block,viewmodel],//按顺序存储参数
    @“add”:@[@"abc",@"hello"]
 }
 
 
 2）
 
 3、complishBlock：执行完后，调用complishBlock，返回info
 1）info：@{“status”：YES/NO，“key”：value}；key是url里的方法，value是方法执行后的结果
 一定会返回status，但不一定会有key-value
 */
+ (void)openUrl:(NSString *)url;
+ (void)openUrl:(NSString *)url complish:(void(^)(NSDictionary *info))complishBlock;
+ (void)openUrl:(NSString *)url param:(NSDictionary *)params;
+ (void)openUrl:(NSString *)url param:(NSDictionary *)params complish:(void(^)(NSDictionary *info))complishBlock;

@end
