//
//  GGRunTimeMethodViewController.m
//  testDemo
//
//  Created by lignpeng on 2018/2/5.
//  Copyright © 2018年 genpeng. All rights reserved.
//

#import "GGRunTimeMethodViewController.h"

#import <objc/runtime.h>
#import "GGPerson.h"

@interface GGRunTimeMethodViewController ()

@property(nonatomic, strong) UILabel *label;


@end

@implementation GGRunTimeMethodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat margin = 32;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(margin, margin * 3, CGRectGetWidth([UIScreen mainScreen].bounds) - margin * 2, 42)];
    [button addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"action" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorWithRed:3/255.0 green:223/255.0 blue:71/255.0 alpha:1];
    button.layer.cornerRadius = 5;
    button.clipsToBounds = YES;
    [self.view addSubview:button];
    self.label = [[UILabel alloc] init];
    self.label.frame = (CGRect){16,120,CGRectGetWidth([UIScreen mainScreen].bounds) - margin,120};
    self.label.textAlignment = NSTextAlignmentLeft;
    self.label.textColor = [UIColor grayColor];
    self.label.numberOfLines = 0;
    [self.view addSubview:self.label];
}

- (void)action {
    [self dd];
}

- (void)dd {
//    NSString *uuid = [[NSUUID UUID] UUIDString];
    NSString *str = [NSString stringWithFormat:@"1、%@\n2、%@",[self getDeviceId],[self uuid]];
    self.label.text = str;
//    [[UIDevice currentDevice] uniqueIdentifier];
//    u_int count;
//    [self classMethodList:object_getClass([GGPerson class])];//获取类方法
    //class_copyMethodList([GGPerson class], &count);获取对象方法
//    Method *methods = class_copyMethodList(objc_getClass([GGPerson class]),&count);
//    for (int i =0; i<count; i++) {
//        SEL name1 = method_getName(methods[i]);
//        const char *selName= sel_getName(name1);
//        NSString *strName = [NSString stringWithCString:selName encoding:NSUTF8StringEncoding];
//        NSLog(@"%@",strName);
////        这2句等同于NSStringFromSelector(name1);
//    }
//    free(methods);
}

- (NSString *)getDeviceId {
    NSUUID * currentDeviceUUID = [UIDevice currentDevice].identifierForVendor;
    NSString *deviceId = currentDeviceUUID.UUIDString;
    deviceId = [deviceId stringByReplacingOccurrencesOfString:@"-" withString:@""];
    deviceId = [deviceId lowercaseString];
    return deviceId;
    
}

- (NSString *)uuid {
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuid = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
    return [uuid lowercaseString];
}



+ (void)classMethodList:(Class)aClass {
    u_int count;
    Method * methods = class_copyMethodList(aClass,&count);
    for(int i = 0;i < count; i++) {
        Method method = methods[i];
        NSString *methodName = [NSString stringWithUTF8String:sel_getName(method_getName(method))];
        NSString *methodType = [NSString stringWithUTF8String:method_getTypeEncoding(method)];
        NSString *methodArgs = @(method_getNumberOfArguments(method)).stringValue;
        
        NSLog(@"[%d]methodName : %@", i, methodName);
        if ([methodName hasSuffix:@":"]) {
            break;
        }
//        IMP imp = method_getImplementation(method);
//        imp();
            //        NSLog(@"[%d]methodArgs : %@", i, methodArgs);
            //        NSLog(@"[%d]methodType : %@\n\n", i, methodType);
            //        if ([CSLoginUserManager respondsToSelector:NSSelectorFromString(methodName)]) {
            //           SEL selec = NSSelectorFromString(methodName);
            //           id result =  [CSLoginUserManager performSelector:selec];
            //          id result = [CSLoginUserManager performSelector:selec];
            //            if ([result isKindOfClass:[NSString class]]) {
            //                NSLog(@"result = %@", result);
            //            }else if ([result isKindOfClass:[NSNumber class]]){
            //                NSLog([NSString stringWithFormat:@"result = %@",  [result boolValue] ? @"yes" : @"no"]);
            //            }
            //        }
    }
    free(methods);
}

@end
