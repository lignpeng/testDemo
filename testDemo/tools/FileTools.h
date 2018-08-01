//
//  SelectPanTools.h
//  testDemo
//
//  Created by lignpeng on 2018/7/23.
//  Copyright © 2018年 genpeng. All rights reserved.
//
/*
 关于文件方面的操作
 
 */

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
//#import <Realm/RLMObject.h>

@interface FileTools : NSObject

+ (NSString *)createFileFolderInDocumentsWithName:(NSString *)folderName;

//返回realm数据库的路径
+ (NSString *)getRealmDBPathWithdbName:(NSString *)dbName;
//获取指定的realm数据库
+ (RLMRealm *)getRealmDBWithdbName:(NSString *)dbName;
//设置默认的数据库
+ (void)configDefaultRealmDBWithdbName:(NSString *)dbName;
//添加数据
+ (RLMObject *)addObjectToDB:(RLMObject *)obj;
//删除数据
+ (void)deletDBObjects:(NSArray<RLMObject *> *)objs;
+ (void)deletDBObject:(RLMObject *)obj;
//+ (void)deletDBObject:(RLMObject *)obj withKeyValue:(NSString *)value;
@end
