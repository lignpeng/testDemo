//
//  GGRouter.m
//  testDemo
//
//  Created by lignpeng on 2019/1/7.
//  Copyright © 2019年 genpeng. All rights reserved.
//

#import "GGRouter.h"
#import "GGRouterModel.h"
#import "GPTools.h"
#import <objc/runtime.h>
#import <objc/message.h>

static GGRouter *g_Router;

@interface GGRouter()

@property(nonatomic, strong) GGRouterModel *routerModel;
@property(nonatomic, copy) void (^complishBlock)(NSDictionary *info);
    
@end


@implementation GGRouter

+ (instancetype)ggRouter {
    return [self new];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (g_Router == nil) {
            g_Router = [super allocWithZone:zone];
        }
    });
    return g_Router;
}

//启动路由
+ (void)startRouter {
    GGRouter *router = [GGRouter ggRouter];
    [router loadRegisterData];
}

//url: scheme://dataModel/action
+ (void)openUrl:(NSString *)url {
    GGRouterUrl *routerUrl = [GGRouterUrl routerUrlWithUrl:url];
    GGRouter *router = [GGRouter ggRouter];
    if(![router isRegisterComponent:routerUrl]) {
        return;
    }
    [router loadComponent:routerUrl];
}
    
+ (void)openUrl:(NSString *)url complish:(void(^)(NSDictionary *info))complishBlock {
    
}
    
+ (void)openUrl:(NSString *)url param:(NSDictionary *)dic {
    
}
    
+ (void)openUrl:(NSString *)url param:(NSDictionary *)dic complish:(void(^)(NSDictionary *info))complishBlock {
    
}
    
- (BOOL)isRegisterComponent:(GGRouterUrl *)routerUrl {
    GGComponentModel *model = [self getComponentModel:routerUrl];
    return model != nil;
}

- (void)loadComponent:(GGRouterUrl *)routerUrl {
    GGComponentModel *model = [self getComponentModel:routerUrl];
    Class class = NSClassFromString(model.className);
    
    if (![class isKindOfClass:[NSObject class]]) {
        return;
    }
    
    id obj;
    //执行类方法
    if (routerUrl.classActions.count == 0) {
        obj = [[class alloc] init];
    }else {
        for (NSString *item in routerUrl.classActions) {
            NSString *actionStr = [model.classActions objectForKey:item];
            obj = [self runClassMethod:class action:actionStr];
        }
    }

    //1、viewController
    if ([obj isKindOfClass:[UIViewController class]]) {
        UIViewController *cur = [GPTools getCurrentViewController];
        [cur.navigationController pushViewController:obj animated:YES];
    }
    
    //执行实例方法
    for (NSString *item in routerUrl.actions) {
        NSString *actionStr = [model.actions objectForKey:item];
        [self runInstanceMethod:obj action:actionStr];
    }
}

//执行类方法
- (id)runClassMethod:(id)target action:(NSString *)actionStr {
    if (actionStr.length == 0) {
        return nil;
    }
    SEL selector = NSSelectorFromString(actionStr);
    if (![target respondsToSelector:selector]) {
        return nil;
    }
    id obj =  objc_msgSend(target,selector);
    return obj;
}

//执行实例方法
- (id)runInstanceMethod:(id)target action:(NSString *)actionStr {
    if (actionStr.length == 0 || target == nil) {
        return nil;
    }
    id obj;
    SEL selector = NSSelectorFromString(actionStr);
    if (!selector || ![target respondsToSelector:selector]) {
        return nil;
    }
//            obj = objc_msgSend(target, selector);
    //        if ([actionStr hasSuffix:@":"]) {
    //            [target performSelector:action withObject:nil];
    //        }else {
    //            [target performSelector:action];
    //        }
    BOOL hasArg = NO;
    NSMethodSignature *sig = [target methodSignatureForSelector:selector];
    if (!sig) {
        return nil;
    }
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
    [invocation setTarget:target];
    [invocation setSelector:selector];
    if (hasArg) {
//            [invocation setArgument:&ext atIndex:2];
    }
    [invocation retainArguments];
    obj = [self runInvoke:invocation methodSignature:sig];
    
    return obj;
}

- (id)runInvoke:(NSInvocation *)invocation methodSignature:(NSMethodSignature *)methodSignature {
    //消息调用
    [invocation invoke];
    //如果调用的消息有返回值，那么可进行以下处理
    //获得返回值类型
    char returnType[255];
    strcpy(returnType, [methodSignature methodReturnType]);
    
    id returnValue = nil;
    if (strncmp(returnType, "v", 1) != 0) {
        if (strncmp(returnType, "@", 1) == 0) {
            id __unsafe_unretained returnObject;
            [invocation getReturnValue:&returnObject];
            returnValue = returnObject;
            return returnValue;
            
        } else {
            
            switch (returnType[0] == 'r' ? returnType[1] : returnType[0]) {
                    
#define CALL_RET_CASE(_typeString, _type) \
case _typeString: {                              \
_type tempResultSet; \
[invocation getReturnValue:&tempResultSet];\
returnValue = @(tempResultSet); \
break; \
}
                    
                    CALL_RET_CASE('c', char)
                    CALL_RET_CASE('C', unsigned char)
                    CALL_RET_CASE('s', short)
                    CALL_RET_CASE('S', unsigned short)
                    CALL_RET_CASE('i', int)
                    CALL_RET_CASE('I', unsigned int)
                    CALL_RET_CASE('l', long)
                    CALL_RET_CASE('L', unsigned long)
                    CALL_RET_CASE('q', long long)
                    CALL_RET_CASE('Q', unsigned long long)
                    CALL_RET_CASE('f', float)
                    CALL_RET_CASE('d', double)
                    CALL_RET_CASE('B', BOOL)
                    
                case '{': {
                    
                    NSString *typeString = extractStructName([NSString stringWithUTF8String:returnType]);
#define CALL_RET_STRUCT(_type, _methodName) \
if ([typeString rangeOfString:@#_type].location != NSNotFound) {    \
_type result;   \
[invocation getReturnValue:&result];    \
return [NSValue _methodName:result];    \
}
                    CALL_RET_STRUCT(CGRect, valueWithCGRect)
                    CALL_RET_STRUCT(CGPoint, valueWithCGPoint)
                    CALL_RET_STRUCT(CGSize, valueWithCGSize)
                    CALL_RET_STRUCT(NSRange, valueWithRange)
                    CALL_RET_STRUCT(CGVector, valueWithCGVector)
                    CALL_RET_STRUCT(CGAffineTransform, valueWithCGAffineTransform)
                    CALL_RET_STRUCT(UIEdgeInsets, valueWithUIEdgeInsets)
                    CALL_RET_STRUCT(UIOffset, valueWithUIOffset)
                    
                    //暂时不支持自定义的结构体
                    break;
                }
                case '*':
                case '^': {
                    //暂时不支持指针返回
                    break;
                }
                case '#': {
                    Class result;
                    [invocation getReturnValue:&result];
                    returnValue = result;
                    break;
                }
                    
                default:break;
            }
            return returnValue;
        }
    }
    return nil;
}

static NSString *extractStructName(NSString *typeEncodeString) {
    NSArray *array = [typeEncodeString componentsSeparatedByString:@"="];
    NSString *typeString = array[0];
    int firstValidIndex = 0;
    for (int i = 0; i< typeString.length; i++) {
        char c = [typeString characterAtIndex:i];
        if (c == '{' || c=='_') {
            firstValidIndex++;
        }else {
            break;
        }
    }
    return [typeString substringFromIndex:firstValidIndex];
}

- (GGComponentModel *)getComponentModel:(GGRouterUrl *)routerUrl {
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"url = %@",routerUrl.scheme];
    NSArray *array = [self.routerModel.componentList filteredArrayUsingPredicate:pre];
    if (array.count == 0) {
        return nil;
    }
    GGComponentModel *model = array.firstObject;
    return model;
}

- (void)loadRegisterData {
//    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"GGTestModelData" ofType:@"json" inDirectory:@"Resource/data"]];
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"routerRegister" ofType:@"json" inDirectory:@"Resource/routerData"]];
    if (data == nil) {
        return;
    }
    NSError *error;
    id  dic  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (error) {
        return;
    }
    self.routerModel = [[GGRouterModel alloc] initWithDictionary:dic error:&error];
    if (error) {
        NSLog(error);
    }
}

- (GGRouterModel *)routerModel {
    if (!_routerModel) {
        _routerModel = [GGRouterModel new];
    }
    return _routerModel;
}
    
@end
