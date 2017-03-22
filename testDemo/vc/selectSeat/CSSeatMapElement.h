//
//  CSSeatMapElement.h
//  CSMBP
//
//  Created by lyh on 16/6/30.
//  Copyright © 2016年 China Southern Airlines. All rights reserved.
//

#import "JSONModel.h"
#import "CSCheckInModuleMacros.h"
#import "CSPriceTag.h"

@protocol CSSeatMapElement <NSObject>
@end


@interface CSSeatMapElement : JSONModel

//元素类型, W：机翼；A：过道；S：座位；E：安全出口
@property (nonatomic) CSSeatMapElementType eleType;

//元素X座标
@property (nonatomic) int xIndex;

//元素Y座标
@property (nonatomic) int yIndex;


/* 
 *  以下属性只有座位才有
 *  文档说好的row代表第几行(31,32,33...)，但是现在接口返回却是跟column字段调换了
 */

//列(A,B,C,H,J,K....)
@property (nonatomic) char column;

//行(1,2,31,32....)
@property (nonatomic) int row;

//类型(A免费座位，U付费座位。S安全员座位[自定义])
@property (nonatomic) CSSeatMapSeatType type;

//座位状态:(A可选，T已被占，R不可选)
@property (nonatomic) CSSeatMapSeatStatus status;

//属性(C普通座位，W靠窗，A靠过道，E靠紧急出口，G前排，B婴儿摇篮座位) 例子"characteristic": "G,A"
@property (nonatomic, copy) NSString<Optional> *characteristic;

//价格
@property (nonatomic, strong) NSArray<CSPriceTag, Optional> *priceList;

//座位等级，付费座位才会有
@property (nonatomic, copy) NSString<Optional> *seatvaluelevel;

/**
 *  是否是过道
 *
 *  
 */
-(BOOL)isEntryWay;

/**
 *  是否是出口
 *
 *  
 */
-(BOOL)isExit;

/**
 *  是否是婴儿摇篮座位
 *
 *  
 */
-(BOOL)isBabySeat;

/**
 *  是否为安全出口座位
 *
 *   
 */
-(BOOL)isAttributeExitSeat;
/**
 *  是否可选
 *
 *  
 */
-(BOOL)canShow;

/**
 *  根据会员级别获取相应价格
 *
 *  @param lvType 会员级别
 *
 *   价格
 */
-(CSPriceTag *)getPriceWithLvType:(NSString *)lvType;

/**
 *  返回座位号，如36D
 *
 *  
 */
-(NSString *)getSeatNo;

@end
