//
//  CSCabinBoundary.h
//  CSMBP
//
//  Created by lyh on 16/6/30.
//  Copyright © 2016年 China Southern Airlines. All rights reserved.
//

#import "JSONModel.h"
#import "CSSeatMapElement.h"
#import "CSCheckInModuleMacros.h"

/**
 返回的座位对象数组
 */
@interface CSCabinBoundary : JSONModel

//舱位
@property (nonatomic) CSCarbinType cabin;

@property (nonatomic, readonly) NSString *cabinName;

//标示上下层，上层座位为U，下层D。只有一层为D
@property (nonatomic) CSSeatMapDeckCode deckCode;

//座位数据
@property (nonatomic, strong) NSArray<CSSeatMapElement, Optional> *eleList;
/*
 *  存储当前机舱中的sction，每个section又存储着当前section的座位list，以过道为分割，将座位分为多块section
 */
@property (nonatomic, strong) NSArray<NSArray<CSSeatMapElement *> *> *eleSectionList;

//通道
@property (nonatomic, strong) NSArray<CSSeatMapElement *> *entrywayList;

//记录有多少行座位(整个机舱)
@property (nonatomic) NSInteger rows;

//记录有多少列座位(整个机舱)
@property (nonatomic) NSInteger columns;

//记录通道数
@property (nonatomic) NSInteger entryways;

//记录有多少个section
@property (nonatomic) NSInteger sections;


/*
 y
 ^
 |   接口返回的顺序坐标系
 |
 | 7 8 9
 | 4 5 6
 | 1 2 3
 ----------------------->x
 
 ----------------------->x
 | 1 2 3
 | 4 5 6
 | 7 8 9
 |  这个是屏幕的坐标系
 |y
 \/
 所以解析的时候要将接口的返回坐标系转为屏幕坐标系
 */
/**
 *  解析座位元素结构，现在是从返回的数据后面像前解析(因为屏幕的坐标是从左上角向右下角伸展的)，即987654321顺序，比如987解析完，则说明第一列解析完成，要将其反转为789(因为屏幕上的座位图是从左边到右边的)
 */
-(void)parseElement;


/**
 *  这个是用于区分显示Y和W的时候
 *
 *  @param carbin
 *
 *  @return
 */
+(NSString *)getCarbinName:(CSCarbinType)carbin;

/**
 *  这个用于显示不区分Y 和 W的时候
 *
 *  @param carbin
 *
 *  @return
 */
+(NSString *)getShortCarbinName:(CSCarbinType)carbin;

@end
