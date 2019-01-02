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
    RLMRealm *realm = [RLMRealm realmWithURL:[NSURL URLWithString:[self getRealmDBPathWithdbName:dbName]]];
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
   
    //要在主线程完成存储操作
    RLMRealm *realm = [RLMRealm defaultRealm];

    for (int i = 0; i < objs.count; i++) {
        RLMObject *obj = objs[i];
        Class class = (RLMObject *)NSClassFromString([NSString stringWithUTF8String:object_getClassName(obj)]);
        [realm beginWriteTransaction];
        obj = [class createOrUpdateInRealm:realm withValue:obj];
        [realm commitWriteTransaction];
    }
    
}

+ (RLMObject *)addObjectToDB:(RLMObject *)obj {
    
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

/*
 清除RLMArray数组元素操作
 保留与orignArray交集部分 
 */
+ (void)removeObjOrignArray:(NSArray *)orignArray filterArray:(RLMArray *)filterArray {
    
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0; i < filterArray.count; i++) {
        id model = filterArray[i];
        Class class = (RLMObject *)NSClassFromString([NSString stringWithUTF8String:object_getClassName(model)]);
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"self.%@ == %@",[class primaryKey],[model valueForKey:[class primaryKey]]];
        NSArray *array = [orignArray filteredArrayUsingPredicate:pre];
        if (array.count == 0) {
            [tempArray addObject:@(i)];
        }
    }
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    for (NSNumber *index in tempArray) {
        [filterArray removeObjectAtIndex:index.integerValue];
    }
    [realm commitWriteTransaction];
}


/*
 RLMArray数组添加数组操作
 1）orignArray的元素添加到targetArray
 2）相同的元素不添加
 */
+ (void)addObjOrignArray:(NSArray *)orignArray targetArray:(RLMArray *)targetArray {
    RLMRealm *realm = [RLMRealm defaultRealm];
    if (targetArray.count == 0) {
        [realm beginWriteTransaction];
        [targetArray addObjects:orignArray];
        [realm commitWriteTransaction];
    }else {
        //去除相同的，避免重复添加
        NSMutableArray *tempArray = [NSMutableArray array];
        BOOL needAdd = YES;
        for (int i = 0; i < orignArray.count; i++) {
            id model1 = orignArray[i];
            Class class = (RLMObject *)NSClassFromString([NSString stringWithUTF8String:object_getClassName(model1)]);
            needAdd = YES;
            for (int j = 0; j < targetArray.count; j++) {
                id model2 = targetArray[j];
                if ([[model2 valueForKey:[class primaryKey]] isEqualToString:[model1 valueForKey:[class primaryKey]]]) {
                    needAdd = NO;
                    break;
                }
            }
            if (needAdd) {
                [tempArray addObject:@(i)];
            }
        }
        for (int i = 0; i < tempArray.count; i++) {
            [realm beginWriteTransaction];
            NSInteger index = ((NSNumber *)tempArray[i]).integerValue;
            [targetArray addObject:orignArray[index]];
            [realm commitWriteTransaction];
        }
    }
}


@end
