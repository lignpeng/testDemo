//
//  LabelModel.h
//  testDemo
//
//  Created by lignpeng on 2018/7/11.
//  Copyright © 2018年 genpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

#define labelRealm @"labelRealm"

RLM_ARRAY_TYPE(LabelModel)

@class ActionResult;

@interface LabelModel : RLMObject
@property(nonatomic, strong) NSString *id;//主键
@property(nonatomic, strong) NSString *name;//title或图片路径
@property(nonatomic, assign) BOOL isImage;//是否图片
@property(nonatomic, assign) BOOL isSelected;//是否已被选中
@property(nonatomic, assign) BOOL isShowDelete;
//@property ActionResult *owner;
@property (readonly) RLMLinkingObjects *owner;

@end


//操作结果
@interface ActionResult:RLMObject

@property(nonatomic, strong) NSString *id;//主键
//@property(nonatomic, strong) NSArray *labels;
//@property(nonatomic, strong) NSArray *resultLabels;
@property(nonatomic, strong) NSString *name;//操作的名称
@property(nonatomic, strong) NSString *date;//操作日期，年月日时分秒
@property RLMArray<LabelModel *><LabelModel> *labels;//一次操作的labels标签集合
@property RLMArray<LabelModel *><LabelModel> *resultLabels;//结果集合

@end
























