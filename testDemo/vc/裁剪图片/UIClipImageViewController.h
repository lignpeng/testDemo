//
//  UIClipImageViewController.h
//  testDemo
//
//  Created by lignpeng on 2018/8/29.
//  Copyright © 2018年 genpeng. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIClipImageViewController : UIViewController

+ (void)clipImage:(UIImage *)image complishBlock:(void(^)(UIImage *image))complishBlock;

@end
