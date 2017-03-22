//
//  CSSeatMapElement.m
//  CSMBP
//
//  Created by lyh on 16/6/30.
//  Copyright © 2016年 China Southern Airlines. All rights reserved.
//

#import "CSSeatMapElement.h"
#import "CSConfigMacros.h"


@interface CSSeatMapElement ()

//元素类型, W：机翼；A：过道；S：座位；E：安全出口
@property (nonatomic, copy) NSString *sever_eleType;
//列(A,B,C,H,J,K....)
@property (nonatomic, copy) NSString *sever_column;
//类型(A免费座位，U付费座位。S安全员座位[自定义])
@property (nonatomic, copy) NSString *sever_type;
//座位状态:(A可选，T已被占，R不可选)
@property (nonatomic, copy) NSString *sever_status;
@end

@implementation CSSeatMapElement


/**
  注：文档说好的row代表第几行(31,32,33...)，但是现在接口返回却是跟column字段调换了
 
 */
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"eleType":          @"sever_eleType",
                                                       @"xIndex":           @"xIndex",
                                                       @"yIndex":           @"yIndex",
                                                       @"column":           @"row",
                                                       @"row":              @"sever_column",
                                                       @"type":             @"sever_type",
                                                       @"status":           @"sever_status",
                                                       @"characteristic":   @"characteristic",
                                                       @"priceList":        @"priceList",
                                                       @"seatvaluelevel":   @"seatvaluelevel"
                                                       }];
}

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+(BOOL)propertyIsIgnored:(NSString *)propertyName {
    return [propertyName isEqualToString:CS_KeyPath(CSSeatMapElement, eleType)]
    || [propertyName isEqualToString:CS_KeyPath(CSSeatMapElement, column)]
    || [propertyName isEqualToString:CS_KeyPath(CSSeatMapElement, type)]
    || [propertyName isEqualToString:CS_KeyPath(CSSeatMapElement, status)];
}

#pragma mark - getters
-(CSSeatMapElementType)eleType {
    if (_eleType == '\0') {
        _eleType = _sever_eleType.length > 0 ? (_sever_eleType.UTF8String)[0] : '\0';
        _sever_eleType = nil;
    }
    
    return _eleType;
}

-(char)column {
    if (_column == '\0') {
        _column = _sever_column.length > 0 ? (_sever_column.UTF8String)[0] : '\0';
        _sever_column = nil;
    }
    
    return _column;
}

-(CSSeatMapSeatType)type {
    if (_type == '\0') {
        _type = _sever_type.length > 0 ? (_sever_type.UTF8String)[0] : '\0';
        _sever_type = nil;
    }
    
    return _type;
}

-(CSSeatMapSeatStatus)status {
    if (_status == '\0') {
        _status = _sever_status.length > 0 ? (_sever_status.UTF8String)[0] : '\0';
        _sever_status = nil;
    }
    
    return _status;
}


#pragma mark - priavte methods
/**
 *  是否是过道:安全出口标示在过道中
 *
 *  
 */
-(BOOL)isEntryWay {
    return self.eleType == CSSeatMapElementTypeEntryWay || self.eleType == CSSeatMapElementTypeExit;
}

/**
 *  是否是出口
 *
 *  
 */
-(BOOL)isExit {
    return self.eleType == CSSeatMapElementTypeExit;
}

/**
 *  是否是婴儿摇篮座位
 *
 *  
 */
-(BOOL)isBabySeat {
    return self.eleType == CSSeatMapElementTypeSeat && [_characteristic rangeOfString:[NSString stringWithFormat:@"%c", CSSeatMapSeatAttributeBaby]].length>0;
}

- (BOOL)isAttributeExitSeat {
//    return self.eleType == CSSeatMapElementTypeSeat && [_characteristic cs_rangeOfString:[NSString stringWithFormat:@"%c", CSSeatMapSeatAttributeExit]].length>0;
    return YES;
}
/**
 *  是否可选
 *
 *  
 */
-(BOOL)canShow {
    return self.eleType == CSSeatMapElementTypeSeat && self.status == CSSeatMapSeatStatusNormal;
}

/**
 *  根据会员级别获取相应价格
 *
 *  @param lvType 会员级别
 *
 *   价格
 */
-(CSPriceTag *)getPriceWithLvType:(NSString *)lvType {
    for (CSPriceTag *price in _priceList) {
        if ([price.tag isEqualToString:lvType]) {
            return price;
        }
    }
    return nil;
}

/**
 *  返回座位号，如36D
 *
 *  
 */
-(NSString *)getSeatNo {
    return [NSString stringWithFormat:@"%d%c", self.row, self.column];
}

@end
