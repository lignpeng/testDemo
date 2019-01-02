

#import "DataYYModel.h"

@implementation WalletInfoYYModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"ddm": BankCardYYModel.class};
}

@end


@implementation AccMsgYYModel

//如果数组里面带有对象的类型，要指定映射的类型，不然的话，解析出来的是字典格式
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"accNoList": BankCardYYModel.class};
}

@end

@implementation BankCardYYModel

////1.该方法是字典里的属性Key和要转化为模型里的属性名不一样而重写的
////key：模型的属性，值：字典里的属性
//
//+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
//    return @{@"messageId":@"id",
//             @"content":@"cc"};
//}

@end

