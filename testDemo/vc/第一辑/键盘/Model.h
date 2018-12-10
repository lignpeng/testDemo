//
//  Model.h
//  testDemo
//
//  Created by lignpeng on 17/3/13.
//  Copyright © 2017年 genpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Model : NSObject


- (void)imageSaved:(UIImage *)image didFinishSavingWithError:(NSError *)error
          contextInfo:(void *)contextInfo;

@end
