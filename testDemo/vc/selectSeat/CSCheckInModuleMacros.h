//
//  CSCheckInModuleMacros.h
//  CSMBP
//
//  Created by liluoxing on 6/13/16.
//  Copyright © 2016 China Southern Airlines. All rights reserved.
//

#ifndef CSCheckInModuleMacros_h
#define CSCheckInModuleMacros_h

//#import "JSONValueTransformer+CSCustomTransformer.h"

typedef NS_ENUM(NSInteger,OperateType){
    TypeOfCheckIn = 1,//值机
    TypeOfPreSelectSeat = 2,//提前选座
    TypeOfSelectSeatAfterBook = 3,//购票后选座
    TypeOfReselectSeat //重新选座
};

typedef NS_ENUM(NSInteger,OperateForSeat_NOT_PAY){//未支付的付费座位操作
    SeatTypeOfCancelOrder = 1,//取消订单
    SeatTypeOfPayForOrder = 2//去支付
};

//舱位类型
typedef NS_ENUM(char, CSCarbinType) {
    CSCarbinN = '\0', //无效舱位
    
    CSCarbinF = 'F',  //头等舱
    CSCarbinJ = 'J',  //公务舱
    CSCarbinW = 'W',  //高级经济舱
    CSCarbinY = 'Y',  //免费经济舱
};

/**
 *  旅客类型
 */
typedef NS_ENUM(NSInteger, CSATSTravelerType) {
    /**
     *  成人
     */
    CSATSTravelerAdult = 0,
    /**
     *  儿童
     */
    CSATSTravelerChildren = 1,
    /**
     *  无陪伴儿童
     */
    CSATSTravelerOnlyChildren = 2,
    /**
     *  婴儿
     */
    CSATSTravelerBaby = 3,
};


/**
 *  服务类型
 */
typedef NS_ENUM(NSInteger, CSATSEmdInfoType) {
    /**
     *  选座
     */
    CSATSEmdInfoChooseSeat = 1,
    /**
     *  行李
     */
    CSATSEmdInfoLuggage = 2
};



/**
 *  是否出EMD
 */
typedef NS_ENUM(NSInteger, CSATSEmdInfoIssueEMD) {
    /**
     *  出
     */
    CSATSEmdInfoIssueEMDYES = 1,
    /**
     *  不出(付费出，免费座位不出)
     */
    CSATSEmdInfoIssueEMDNO = 0
};


/**
 *  出票渠道
 */
typedef NS_ENUM(NSInteger, CSATSBasicInfoIssueType) {
    /**
     *  南航EMD
     */
    CSATSBasicInfoIssueEMD = 0,
    /**
     *  航信EMS
     */
    CSATSBasicInfoIssueEMS = 1
};

/**
 *  订单状态(C：已确认未支付；B：已支付未出票；T：已支付正在出票；E：已支付已出票；D：取消)
 */
typedef NS_ENUM(char, CSATSOrderInfoType) {
    /**
     *  已确认未支付
     */
    CSATSOrderInfoNoPaid          = 'C',
    /**
     *  已支付未出票
     */
    CSATSOrderInfoPaidAndNoIssued = 'B',
    /**
     *  已支付正在出票
     */
    CSATSOrderInfoPaidAndIssueing = 'T',
    /**
     *  已支付已出票
     */
    CSATSOrderInfoPaidAndIssued   = 'E',
    /**
     *  取消
     */
    CSATSOrderInfoCancel          = 'D'
};


/**
 *  座位元素类型  //W：机翼；A：过道；S：座位；E：安全出口
 */
typedef NS_ENUM(char, CSSeatMapElementType) {
    /**
     *  占位
     */
    CSSeatMapElementTypeSpace       = 'K',
    /**
     *  婴儿摇篮
     */
    CSSeatMapElementTypeBaby        = 'B',
    /**
     *  机翼
     */
    CSSeatMapElementTypeWing        = 'W',
    /**
     *  过道
     */
    CSSeatMapElementTypeEntryWay    = 'A',
    /**
     *  座位
     */
    CSSeatMapElementTypeSeat        = 'S',
    /**
     *  安全出口
     */
    CSSeatMapElementTypeExit        = 'E'
    
};


/**
 *  座位图座位类型(A免费座位，U付费座位。S安全员座位[自定义])
 */
typedef NS_ENUM(char, CSSeatMapSeatType) {
    /**
     *  免费座位
     */
    CSSeatMapSeatTypeFree           = 'A',
    /**
     *  付费座位
     */
    CSSeatMapSeatTypePay            = 'U',
    /**
     *  安全员座位[自定义]
     */
    CSSeatMapSeatTypeSafelyOfficer  = 'S'
};


/**
 *  座位状态:(A可选，T已被占，R不可选)
 */
typedef NS_ENUM(char, CSSeatMapSeatStatus) {
    /**
     *  可选
     */
    CSSeatMapSeatStatusNormal          = 'A',
    /**
     *  已被占
     */
    CSSeatMapSeatStatusOccupied        = 'T',
    /**
     *  不可选
     */
    CSSeatMapSeatStatusNotOptional     = 'R'
};


/**
 *  上下层标示:有上下层时，上层座位图为U，下层D。只有一层时为D
 */
typedef NS_ENUM(char, CSSeatMapDeckCode) {
    /**
     *  不区分楼层
     */
    CSSeatMapDeckCodeNone          = '\0',
    /**
     *  上层座位为U
     */
    CSSeatMapDeckCodeUpper         = 'U',
    /**
     *  下层D
     */
    CSSeatMapDeckCodeDown          = 'D'
};


/**
 *  属性(C普通座位，W靠窗，A靠过道，E靠紧急出口，G前排)
 */
typedef NS_ENUM(char, CSSeatMapSeatAttribute) {
    /**
     *  普通座位
     */
    CSSeatMapSeatAttributeNormal    = 'C',
    /**
     *  靠窗
     */
    CSSeatMapSeatAttributeWing      = 'W',
    /**
     *  靠过道
     */
    CSSeatMapSeatAttributeEntryWay  = 'A',
    /**
     *  靠紧急出口
     */
    CSSeatMapSeatAttributeExit      = 'E',
    /**
     *  前排
     */
    CSSeatMapSeatAttributeFront     = 'G',
    /**
     *  婴儿摇篮
     */
    CSSeatMapSeatAttributeBaby      = 'B',
};


/**
 *  预留座位付费状态
 */
typedef NS_ENUM(NSInteger, CSAscSeatPayType) {
    /**
     *  免费
     */
    CSAscSeatFree   =   1,
    /**
     *  未付费 HD
     */
    CSAscSeatNOT_PAY = 2,
    /**
     *  已付费 HI
     */
    CSAscSeatPAYED = 3
};


// cell identifier
#define ListTipCellIdentifier @"CSCheckInListTipViewCell"
#define NotCheckInCellIdentifier @"CSCheckInListNoCheckInPassCell"
#define DoCheckInCellIdentifier @"CSCheckInListDoCheckInCell"
#define CheckedInCellIdentifier @"CSCheckInListCheckedInCell"

//支付成功返回结果
static NSString* const kEncodeMsg = @"encodeMsg";
static NSString* const kSignMsg = @"signMsg";
#endif /* CSCheckInModuleMacros_h */
