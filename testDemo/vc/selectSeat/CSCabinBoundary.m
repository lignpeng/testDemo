//
//  CSCabinBoundary.m
//  CSMBP
//
//  Created by lyh on 16/6/30.
//  Copyright © 2016年 China Southern Airlines. All rights reserved.
//

#import "CSCabinBoundary.h"
#import "CSConfigMacros.h"


@interface CSCabinBoundary ()


/**
  eleList:舱位CSSeatMapElement对象的数组(接口返回的)，按坐标x,y，从左至右，从下至上的顺序以数组的方式返回
  按最终被解析后存储为eleSectionList
 */
//@property (nonatomic, strong) NSArray<CSSeatMapElement, Optional> *eleList;

@property (nonatomic,   copy) NSString *sever_cabin;

@property (nonatomic,   copy) NSString *sever_deckCode;

@end

@implementation CSCabinBoundary

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *dic = @{@"cabin":           @"sever_cabin",
                          @"deckCode":        @"sever_deckCode"};//@"eleList":         @"eleList"
    return [[JSONKeyMapper alloc] initWithDictionary:dic];
}

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}


+(BOOL)propertyIsIgnored:(NSString *)propertyName
{
    return [propertyName isEqualToString:CS_KeyPath(CSCabinBoundary, cabin)]
    || [propertyName isEqualToString:CS_KeyPath(CSCabinBoundary, deckCode)]
    || [propertyName isEqualToString:CS_KeyPath(CSCabinBoundary, cabinName)]
    || [propertyName isEqualToString:CS_KeyPath(CSCabinBoundary, eleSectionList)]
    || [propertyName isEqualToString:CS_KeyPath(CSCabinBoundary, entrywayList)]
    || [propertyName isEqualToString:CS_KeyPath(CSCabinBoundary, rows)]
    || [propertyName isEqualToString:CS_KeyPath(CSCabinBoundary, columns)]
    || [propertyName isEqualToString:CS_KeyPath(CSCabinBoundary, entryways)]
    || [propertyName isEqualToString:CS_KeyPath(CSCabinBoundary, sections)];
}


#pragma mark - getters
-(NSString *)cabinName {
    return [[self class] getCarbinName:self.cabin];
}

-(CSCarbinType)cabin {
    if (_cabin == CSCarbinN) {
        _cabin = _sever_cabin.length > 0 ? (_sever_cabin.UTF8String)[0] : CSCarbinN;
        _sever_cabin = nil;
    }
    
    return _cabin;
}


-(CSSeatMapDeckCode)deckCode {
    if (_deckCode == CSSeatMapDeckCodeNone) {
        _deckCode = _sever_deckCode.length > 0 ? (_sever_deckCode.UTF8String)[0] : CSSeatMapDeckCodeNone;
        _sever_deckCode = nil;
    }
    
    return _deckCode;
}


#pragma mark - private methods
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
 *  解析座位元素结构，现在是从返回的数据后面像前解析(因为屏幕的坐标是从左上角向右下角伸展的)，即987654321顺序，比如987解析完，则说明第一列解析完成，要将其反转为789(因为屏幕上的座位图是从左边到右边的，这里的做法是，每遍历一个元素都插在前面，这样就不需要做反转动作了)
    注：后台返回的数据通道为连续两列，需要处理为一列，后台接口没返回通道行号，需要给通道设置相应的行号；婴儿摇篮座位需要特殊处理下
 */
-(void)parseElement {
    
    if (_eleList) {
        
        _entryways = 0;
        _rows = 0;
        _columns = 0;
        
        //存储多个section数据
        NSMutableArray<NSMutableArray<CSSeatMapElement *> *> *sectionList = [NSMutableArray<NSMutableArray<CSSeatMapElement *> *> array];
        
        //存储过道
        NSMutableArray<CSSeatMapElement *> *entrywayList = [NSMutableArray<CSSeatMapElement *> array];
        
        //列数据存储, 每列存储的是dict，以BOOL类型(座位：NO，过道：YES)为key，array<element>为value
        NSMutableArray<NSDictionary<NSNumber *, NSArray<CSSeatMapElement *> *> *> *elements
        = [NSMutableArray<NSDictionary<NSNumber *, NSArray<CSSeatMapElement *> *> *> array];
        
        //记录行号，用于给通道设置相应的行号，后台接口没返回（后台接口不愿意返回，没办法，不返回我就自己搞咯。。。）
        NSMutableDictionary<NSNumber *, NSNumber *> *rowNums = [NSMutableDictionary<NSNumber *, NSNumber *> dictionary];
        
        
        NSMutableArray<CSSeatMapElement *> *perColElements = nil;//前一列数组
        int y = -1;
        BOOL preColIsWay = NO;  //前一列是否是过道
        BOOL curColIsWay = NO;  //当前列是否是过道
        
        int curForeachIndex = 0;    //当前遍历到每一列中的第几个元素
        
        for (int i = _eleList.count - 1; i >= 0; --i) {
            CSSeatMapElement *ele = _eleList[i];
            
            if (y != ele.yIndex) {//首次遍历该列时的处理
                y  = ele.yIndex;
                
                if (curForeachIndex > 0 && _rows == 0) {
                    _rows = (curForeachIndex + 2);  //前后加了占位符
                }
                
                curForeachIndex = 0;
                
                perColElements = nil;
                
                
                preColIsWay = curColIsWay;
                
                curColIsWay = [ele isEntryWay];
                
                if (!preColIsWay || !curColIsWay) {//后台返回的数据过道为连续两列，需要处理为一列
                    
                    perColElements = [NSMutableArray<CSSeatMapElement *> array];
//                    [perColElements addObject:[self spaceElement:-1 y:y]];//在每一列的前面加一个占位
//                    [perColElements addObject:[self spaceElement:ele.xIndex+1 y:y]];//在每一列的后面加一个占位
                    [elements addObject:@{@([ele isEntryWay]): perColElements}];
                    
                }
            }
            
            
            
            if (ele.eleType == CSSeatMapElementTypeSeat) {
                [rowNums setObject:@(ele.row) forKey:@(curForeachIndex)];
            }
            
            //如果当前是摇篮，这置为普通座位，并设置前一个占位为摇篮
            if ([ele isBabySeat]) {
                //                CSSeatMapElement *preEle = [perColElements cs_objectWithIndex:perColElements.count-2-curForeachIndex];  //取出当前要插入位置的前一个元素
                //                preEle.eleType = CSSeatMapElementTypeBaby;  //设为摇篮
                //                preEle.xIndex = ele.xIndex - 1;
            } else if ([ele isEntryWay] && preColIsWay && [ele isExit]) {
                
//                NSArray<CSSeatMapElement *> *lastCol = [[elements cs_dictionaryWithIndex:elements.count-1] cs_arrayForKey:@(YES)];
                
//                if (lastCol) {
//                    //说明当前遍历到的ele是连续通道的第二条通道，如果是出口，替换上一条通道的对应行中的type
//                    CSSeatMapElement *lEle = [lastCol cs_objectWithIndex:curForeachIndex+1];
//                    lEle.eleType = CSSeatMapElementTypeExit; //将同时出现的前一个通道占位设为出口
//                }
//                
//            } else if ([ele isEntryWay]) {
////                ele.row = [rowNums cs_int32ForKey:@(curForeachIndex)]; //设置通道的行号
//            }
            }
            if (perColElements) {
                [perColElements insertObject:ele atIndex:1];
            }
            
            ++curForeachIndex;
        }
        
        
        BOOL lastSectionHasValue = NO;
        for (NSDictionary<NSNumber *, NSArray<CSSeatMapElement *> *> *colDict in elements) {
            
            NSNumber *key = colDict.allKeys.firstObject;
            
            if ([key boolValue] == NO) {
                if (!lastSectionHasValue) {//多个section以过道分隔的
                    [sectionList addObject:[NSMutableArray<CSSeatMapElement *> array]];
                    lastSectionHasValue = YES;
                }
                
                _columns += 1;
                
//                NSArray<CSSeatMapElement *> *colSeats = [colDict cs_arrayForKey:key];
//                
//                //解析婴儿摇篮座位
//                for (int i = 1; i < colSeats.count; ++i) {
//                    CSSeatMapElement *ele = colSeats[i];  //判断当前是否是摇篮座位
//                    if ([ele isBabySeat] && colSeats[i-1].eleType == CSSeatMapElementTypeSpace) {
//                        ele = colSeats[i-1];  //取出当前要插入位置的前一个元素
//                        ele.eleType = CSSeatMapElementTypeBaby;  //设为摇篮
//                    }
//                }
//                
//                [sectionList[sectionList.count - 1] cs_addObjectsFromArray:colSeats];
                
            } else {
                lastSectionHasValue = NO;
//                [entrywayList cs_addObjectsFromArray:[colDict cs_arrayForKey:key]];
                _entryways += 1;
            }
        }
        
        _eleSectionList = sectionList;
        _entrywayList = entrywayList;
        _sections = sectionList.count;
        _eleList = nil;
    }
}


/**
 *  这个是用于区分显示Y和W的时候
 *
 *  @param carbin
 *
 *  @return
 */
+ (NSString *)getCarbinName:(CSCarbinType)carbin {
    switch (carbin) {
        case CSCarbinF:
            return NSLocalizedString(@"First class", @"头等舱");
            
        case CSCarbinJ:
            return NSLocalizedString(@"Business class", @"公务舱");
            
        case CSCarbinW:
            return NSLocalizedString(@"Economy class paid seat", @"经济舱付费座位");
            
        case CSCarbinY:
            return NSLocalizedString(@"Economy class free seat", @"经济舱免费座位");
            
        default:
            return nil;
    }
}

/**
 *  这个用于显示不区分Y 和 W的时候

 */
+(NSString *)getShortCarbinName:(CSCarbinType)carbin {
    switch (carbin) {
        case CSCarbinF:
            return NSLocalizedString(@"First class", @"头等舱");
            
        case CSCarbinJ:
            return NSLocalizedString(@"Business class", @"公务舱");
            
        case CSCarbinW:
        case CSCarbinY:
            return NSLocalizedString(@"Economy class", @"经济舱");
            
        default:
            break;
    }
    
    return nil;
}

/**
 *  生成一个占位符
 *
 */
-(CSSeatMapElement *)spaceElement:(int)x y:(int)y {
    CSSeatMapElement *e = [CSSeatMapElement new];
    e.xIndex = x;
    e.yIndex = y;
    e.eleType = CSSeatMapElementTypeSpace;
    
    return e;
}

@end
