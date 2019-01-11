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

NS_ASSUME_NONNULL_BEGIN

@interface GGRouter : NSObject

+ (instancetype)ggRouter;
//启动路由
+ (void)startRouter;

+ (void)openUrl:(NSString *)url;
+ (void)openUrl:(NSString *)url complish:(void(^)(NSDictionary *info))complishBlock;
+ (void)openUrl:(NSString *)url param:(NSDictionary *)dic;
+ (void)openUrl:(NSString *)url param:(NSDictionary *)dic complish:(void(^)(NSDictionary *info))complishBlock;
@end

NS_ASSUME_NONNULL_END
