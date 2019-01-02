

#import "DataJsonModel.h"
#import <objc/runtime.h>

@implementation WalletInfoJsonModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

+ (JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                       @"iniPayCount": @"initPayCount"}];
}


+ (NSDictionary *)modelForArrayObjectKeyMaper {
    return @{@"accMsg":[AccMsgJsonModel class],@"ddm":[BankCardJsonModel class]};
}

//- (instancetype)modelWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err {
//    if (self = [self initWithDictionary:dict error:err]) {
//
//    }
//    return self;
//}

- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err {
    if (self = [super initWithDictionary:dict error:err]) {
        
    }
    return self;
}

- (NSArray *)getAllProperties {
    u_int count;
    objc_property_t *properties  =class_copyPropertyList([self class], &count);
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        const char* propertyName =property_getName(properties[i]);
        [propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];
    }
    free(properties);
    return propertiesArray;
    
}

@end


@implementation AccMsgJsonModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

@end

@implementation BankCardJsonModel

+(BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

@end


