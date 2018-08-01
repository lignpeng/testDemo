//
//  SelectPanTools.m
//  testDemo
//
//  Created by lignpeng on 2018/7/23.
//  Copyright © 2018年 genpeng. All rights reserved.
//

#import "FileTools.h"


@implementation FileTools

+ (NSString *)createFileFolderInDocumentsWithName:(NSString *)folderName {
    NSString *path = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@",folderName]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL exist = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    if (!(isDir && exist)) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

//返回realm数据库的路径
+ (NSString *)getRealmDBPathWithdbName:(NSString *)dbName {
    NSString *path = [self createFileFolderInDocumentsWithName:@"db"];
    path = [path stringByAppendingString:[NSString stringWithFormat:@"/%@.realm",dbName]];
    return path;
}
//如果该目录下没有以dbName命名的数据库存在，那么则生成该数据库，如果已经存在，则realm就是该数据库
+ (RLMRealm *)getRealmDBWithdbName:(NSString *)dbName {
//    if (![[NSFileManager defaultManager] fileExistsAtPath:[self getRealmDBPathWithdbName:dbName]]) {
    RLMRealm *realm = [RLMRealm realmWithURL:[NSURL URLWithString:[self getRealmDBPathWithdbName:dbName]]];
//    }
//    return YES;
    return realm;
}

+ (void)configDefaultRealmDBWithdbName:(NSString *)dbName {
    NSString *path = [self getRealmDBPathWithdbName:dbName];
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    config.fileURL = [NSURL URLWithString:path];
    config.readOnly = NO;
    [RLMRealmConfiguration setDefaultConfiguration:config];
}


+ (void)addObjectsToDB:(NSArray<RLMObject *> *)objs {
    //避免阻塞主线程  ，在异步会造成异常
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
//        RLMRealm *realm = [RLMRealm defaultRealm];
//        [realm transactionWithBlock:^{
//            [realm addObjects:objs];
//
//        }];
//    });
    
    //要在主线程完成存储操作
    RLMRealm *realm = [RLMRealm defaultRealm];
//    for (RLMObject *obj in objs) {
//        Class class = (RLMObject *)NSClassFromString([NSString stringWithUTF8String:object_getClassName(obj)]);
//        [realm beginWriteTransaction];
//        obj = [class createOrUpdateInRealm:realm withValue:obj];
//        [realm commitWriteTransaction];
//    }
    for (int i = 0; i < objs.count; i++) {
        RLMObject *obj = objs[i];
        Class class = (RLMObject *)NSClassFromString([NSString stringWithUTF8String:object_getClassName(obj)]);
        [realm beginWriteTransaction];
        obj = [class createOrUpdateInRealm:realm withValue:obj];
        [realm commitWriteTransaction];
    }
    
}

+ (RLMObject *)addObjectToDB:(RLMObject *)obj {
        //避免阻塞主线程  ，在异步会造成异常
        //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        //        RLMRealm *realm = [RLMRealm defaultRealm];
        //        [realm transactionWithBlock:^{
        //            [realm addObjects:objs];
        //
        //        }];
        //    });
    
//要在主线程完成存储操作
    RLMRealm *realm = [RLMRealm defaultRealm];
    Class class = (RLMObject *)NSClassFromString([NSString stringWithUTF8String:object_getClassName(obj)]);
    [realm beginWriteTransaction];
    obj = [class createOrUpdateInRealm:realm withValue:obj];
    [realm commitWriteTransaction];
    return obj;
}

+ (void)deletDBObjects:(NSArray<RLMObject *> *)objs {
    for (RLMObject *obj in objs) {
        [self deletDBObject:obj];
    }
}

+ (void)deletDBObject:(RLMObject *)obj {
    RLMRealm *realm = [RLMRealm defaultRealm];
    Class class = (RLMObject *)NSClassFromString([NSString stringWithUTF8String:object_getClassName(obj)]);
    if (![class primaryKey]) {
        return;
    }
    
    RLMObject *rlmObj = [class objectInRealm:realm forPrimaryKey:[obj valueForKey:[class primaryKey]]];
    if (!rlmObj) {
        return;
    }
    [realm transactionWithBlock:^{
        [realm deleteObject:rlmObj];
    }];
}

@end
