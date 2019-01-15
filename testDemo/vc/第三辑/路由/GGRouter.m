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
@property(nonatomic, strong) NSDictionary *params;

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
//    GGRouter *router = [GGRouter ggRouter];
//    [router loadRegisterData];
}

+ (void)removeValue {
    GGRouter *router = [GGRouter ggRouter];
    router.params = nil;
    router.complishBlock = nil;
//    router.routerModel = nil;
}

+ (void)openUrl:(NSString *)url {
    [self openUrl:url param:nil complish:nil];
}
    
+ (void)openUrl:(NSString *)url complish:(void(^)(NSDictionary *info))complishBlock {
    [self openUrl:url param:nil complish:complishBlock];
}
    
+ (void)openUrl:(NSString *)url param:(NSDictionary *)params {
    [self openUrl:url param:params complish:nil];
}
    
+ (void)openUrl:(NSString *)url param:(NSDictionary *)params complish:(void(^)(NSDictionary *info))complishBlock {
    GGRouterUrl *routerUrl = [GGRouterUrl routerUrlWithUrl:url];
    GGRouter *router = [GGRouter ggRouter];
    router.complishBlock = complishBlock;
    router.params = params;
    if(![router isRegisterComponent:routerUrl]) {
        return;
    }
    [router loadComponent:routerUrl];
}
    
- (BOOL)isRegisterComponent:(GGRouterUrl *)routerUrl {
    GGComponentModel *model = [self getComponentModel:routerUrl];
    return model != nil;
}

- (void)loadComponent:(GGRouterUrl *)routerUrl {
    GGComponentModel *model = [self getComponentModel:routerUrl];
    Class class = NSClassFromString(model.className);
    
    if (![class isKindOfClass:[NSObject class]]) {
        if (self.complishBlock) {
            self.complishBlock(@{@"status":@(NO)});
        }
        return ;
    }
    
    id obj;
    NSMutableDictionary *resultParams = [NSMutableDictionary dictionary];
    //没有类方法，创建默认实例对象
    if (routerUrl.classActions.count == 0) {
        obj = [[class alloc] init];
        [resultParams setObject:obj forKey:@"obj"];
    }
    
    //执行类方法
    NSError *classError;
    for (NSString *item in routerUrl.classActions) {
        NSString *actionStr = [model.classActions objectForKey:item];
        
        obj = [self runClassMethod:class key:item action:actionStr error:&classError];
        if (classError) {
            //
            [resultParams setValue:classError forKey:item];
        }
        if (obj) {
            [resultParams setValue:obj forKey:item];
        }
    }

    //推出viewController
    if ([obj isKindOfClass:[UIViewController class]]) {
        UIViewController *cur = [GPTools getCurrentViewController];
        [cur.navigationController pushViewController:obj animated:YES];
    }
    
    //执行实例方法
    NSError *actionError;
    for (NSString *item in routerUrl.actions) {
        NSString *actionStr = [model.actions objectForKey:item];
        id value = [self runInstanceMethod:obj key:item action:actionStr error:&actionError];
        if (actionError) {
            //
            [resultParams setValue:actionError forKey:item];
        }
        if (obj) {
            [resultParams setValue:value?:@"" forKey:item];
        }
    }
    
    if (self.complishBlock) {
        if ([resultParams allKeys].count > 0) {
            [resultParams setValue:@(YES) forKey:@"status"];
            self.complishBlock(resultParams);
        }else {
            self.complishBlock(@{@"status":@(NO)});
        }
    }
}

- (void)hasError:(NSError **)error errorInfo:(NSString *)errorString {
    NSDictionary *dic = @{NSLocalizedFailureReasonErrorKey:errorString};
    *error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:1024 userInfo:dic];
}

//执行类方法
- (id)runClassMethod:(id)target key:(NSString *)key action:(NSString *)actionStr error:(NSError **)error {
    if (actionStr.length == 0) {
        [self hasError:error errorInfo:@"提供的类方法为空"];
        return nil;
    }
    SEL selector = NSSelectorFromString(actionStr);
    if (![target respondsToSelector:selector]) {
        [self hasError:error errorInfo:[NSString stringWithFormat:@"类:'%@',没有找到此类方法：'%@'",NSStringFromClass(target),actionStr]];
        return nil;
    }
    id obj = nil;
    NSArray *param = [self.params objectForKey:key];
    if (![param isKindOfClass:[NSArray class]]) {
        if ([self paramNums:actionStr] == 1) {
            if (param) {
                obj =  objc_msgSend(target,selector,param);
            }else {
                [self hasError:error errorInfo:[NSString stringWithFormat:@"类方法：'%@',提供的参数为空",actionStr]];
            }
        }
        return obj;
    }
    if ([self paramNums:actionStr] == 0) {
        obj =  objc_msgSend(target,selector);
    }else if(param.count > 0 && [self paramNums:actionStr] == 1){
        obj =  objc_msgSend(target,selector,param.firstObject);
    }else if (param.count >= 2 && [self paramNums:actionStr] == 2) {
        id (*obj_msgsend)(id, SEL, id, id) = (id (*)(id, SEL, id, id))objc_msgSend;
        obj =  obj_msgsend(target, selector, param.firstObject, param[1]);
    }else if (param.count >= 3 && [self paramNums:actionStr] == 3) {
        id (*obj_msgsend)(id, SEL, id, id, id) = (id (*)(id, SEL, id, id, id))objc_msgSend;
        obj =  obj_msgsend(target, selector, param.firstObject, param[1],param[2]);
    }
    
    return obj;
}

- (NSInteger)paramNums:(NSString *)actionStr {
    NSInteger num = 0;
    for (int i = 0; i < actionStr.length; i++) {
        NSString *subStr = [actionStr substringWithRange:NSMakeRange(i, 1)];
        if ([subStr isEqualToString:@":"]) {
            ++num;
        }
    }
    return num;
}

//执行实例方法
- (id)runInstanceMethod:(id)target key:(NSString *)key action:(NSString *)actionStr error:(NSError **)error {
    if (!target) {
        [self hasError:error errorInfo:@"创建对象失败"];
        return nil;
    }
    if (actionStr.length == 0) {
        [self hasError:error errorInfo:@"提供方法为空"];
        return nil;
    }
    id obj;
    SEL selector = NSSelectorFromString(actionStr);
    if (!selector || ![target respondsToSelector:selector]) {
        [self hasError:error errorInfo:@"找不到提供的方法"];
        return nil;
    }

    NSMethodSignature *sig = [target methodSignatureForSelector:selector];
    if (!sig) {
        [self hasError:error errorInfo:@"方法签名失败"];
        return nil;
    }
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
    [invocation setTarget:target];
    [invocation setSelector:selector];
    NSInteger paramNum = [self paramNums:actionStr];
    NSArray *param = [self.params objectForKey:key];
    if (param) {
        if ([param isKindOfClass:[NSArray class]]) {
            if (param.count >= paramNum && (paramNum > 0)) {
                for (int i = 0; i < paramNum; i++) {
                    id item = param[i];
                    [invocation setArgument:&item atIndex:i+2];
                }
            }
        }else {
            [invocation setArgument:&param atIndex:2];
        }
        [invocation retainArguments];
    }

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
        _routerModel = [GGRouterModel routerModel];
    }
    return _routerModel;
}
    
@end
