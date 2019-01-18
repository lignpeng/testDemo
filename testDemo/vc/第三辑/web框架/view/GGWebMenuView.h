//
//  GGWebMenuView.h
//  testDemo
//
//  Created by lignpeng on 2019/1/18.
//  Copyright © 2019年 genpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGWebMenuModel.h"

@interface GGWebMenuView : UIView

+ (instancetype)webMenuView;

+ (void)show;

+ (void)showComplish:(void(^)(WebMenuType index))complishBlock;

@end

