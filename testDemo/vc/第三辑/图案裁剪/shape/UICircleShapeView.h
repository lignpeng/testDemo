//
//  UIRectShape.h
//  testDemo
//
//  Created by lignpeng on 2018/12/10.
//  Copyright © 2018年 genpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIShapeView.h"

/*
 圆形蒙版
 添加到图片上
 */

@interface UICircleShapeView : UIShapeView

//开始点，从圆的顶点开始
@property (nonatomic,assign) CGFloat startPoint;
//结束点 需要自己计算
@property (nonatomic,assign) CGFloat endPoint;
//如果isCLockwise==YES 则endPoint的范围为0~-2 如果为NO则范围为0~2
@property (nonatomic,assign) BOOL isClockwise;

@end
