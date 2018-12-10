//
//  CSNoviceGuide.h
//  CSMBP
//
//  Created by lignpeng on 16/12/21.
//  Copyright © 2016年 genpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
//新手引导

@interface CSNoviceGuideView : UIView

//展示新手引导
+ (instancetype)showNoviceGuideWithAnimated:(BOOL)animated;

//展示新手引导+任务，任务按顺序执行
//+ (instancetype)showNoviceGuideWithAnimated:(BOOL)animated actions:(NSArray<NSOperation>)actions;

//隐藏
+ (void)dismiss;
@end
