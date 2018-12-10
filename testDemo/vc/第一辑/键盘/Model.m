//
//  Model.m
//  testDemo
//
//  Created by lignpeng on 17/3/13.
//  Copyright © 2017年 genpeng. All rights reserved.
//

#import "Model.h"

@implementation Model

- ( void ) imageSaved: ( UIImage *) image didFinishSavingWithError:( NSError *)error
          contextInfo: ( void *) contextInfo
{
    NSLog(@"保存结束");
    if (error != nil) {
        NSLog(@"有错误");
    }
}


@end
