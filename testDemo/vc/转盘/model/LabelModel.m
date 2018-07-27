//
//  LabelModel.m
//  testDemo
//
//  Created by lignpeng on 2018/7/11.
//  Copyright © 2018年 genpeng. All rights reserved.
//

#import "LabelModel.h"

@implementation LabelModel

- (instancetype)init {
    if (self = [super init]) {
        self.id = [[NSUUID UUID] UUIDString];//自动创建唯一的标志
    }
    return self;
}

+ (NSString *)primaryKey {
    return @"id";
}

+ (NSDictionary<NSString *,RLMPropertyDescriptor *> *)linkingObjectsProperties {
    return @{@"owner":[RLMPropertyDescriptor descriptorWithClass:ActionResult.class propertyName:@"labels"],@"owner":[RLMPropertyDescriptor descriptorWithClass:ActionResult.class propertyName:@"resultLabels"]};
}

@end


@implementation ActionResult

- (instancetype)init {
    if (self = [super init]) {
        self.id = [[NSUUID UUID] UUIDString];//自动创建唯一的标志
    }
    return self;
}

+ (NSString *)primaryKey {
    return @"id";
}

@end
