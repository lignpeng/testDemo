//
//  LabelModel.h
//  testDemo
//
//  Created by lignpeng on 2018/7/11.
//  Copyright © 2018年 genpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LabelModel : NSObject

@property(nonatomic, strong) NSString *name;
@property(nonatomic, assign) BOOL isImage;//是否图片
@property(nonatomic, assign) BOOL isSelected;//是否已被选中
@property(nonatomic, assign) BOOL isShowDelete;
@end
