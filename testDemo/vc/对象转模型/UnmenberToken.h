//
//  UnmenberToken.h
//  CSMBP
//
//  Created by chen shaomou on 11-8-13.
//  Copyright 2011年 Forever OpenSource Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UnmenberToken : NSObject 

@property(nonatomic,strong) NSString *mobilestr;
@property(nonatomic,strong) NSString *vCode;
@property(nonatomic,strong) NSString *result;
@property(nonatomic,strong) NSString *method;

- (void)setData;
@end
