
#import <Foundation/Foundation.h>
#import "JSONModel.h"

@class AccMsgJsonModel;
@protocol BankCardJsonModel;

@interface WalletInfoJsonModel : JSONModel

@property(nonatomic, copy) NSString *code;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, strong) AccMsgJsonModel *accMsg;//二类户信息
@property(nonatomic, strong) NSArray<BankCardJsonModel> *ddm;//二类户信息

- (NSArray *)getAllProperties;
+ (NSDictionary *)modelForArrayObjectKeyMaper;
+ (instancetype)modelWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err;
@end

@interface AccMsgJsonModel:JSONModel

@property(nonatomic, copy) NSString *accNo;//卡号
@property(nonatomic, copy) NSString <Optional>*name;//
@property (nonatomic, strong) NSArray<BankCardJsonModel> *accNoList;//银行卡列表
@property(nonatomic, copy) NSString *phoneNo;//手机号
@property(nonatomic, copy) NSString *cardNo;//会员卡号

@end

@interface BankCardJsonModel : JSONModel

@property (nonatomic,copy) NSString *accNo; //"622202*********4835"
@property (nonatomic,copy) NSString *accId;//"291"
@property (nonatomic,copy) NSString *bankName;//"农业银行 (4835)"
@property (nonatomic,copy) NSString *logo;//http://10.79.1.143/CSMBP/images/banklogo/02.png
@end


