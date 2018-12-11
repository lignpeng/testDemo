//
//  ImageTools.m
//  testDemo
//
//  Created by lignpeng on 2018/12/10.
//  Copyright © 2018年 genpeng. All rights reserved.
//

#import "ImageTools.h"

@implementation ImageTools


//裁剪指定区域图片：传入需要截取的view
+(UIImage *)clipImageByView:(UIView *)view {
    UIImage *imageRet = [[UIImage alloc]init];
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，调整清晰度。
    UIGraphicsBeginImageContextWithOptions(view.frame.size, YES, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    imageRet = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageRet;
}

@end
