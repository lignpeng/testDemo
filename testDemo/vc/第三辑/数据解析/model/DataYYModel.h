


#import <UIKit/UIKit.h>
#import "YYModel.h"

@class BankCardYYModel;
@class AccMsgYYModel;

@interface WalletInfoYYModel : NSObject

@property(nonatomic, copy) NSString *code;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *name1;
@property(nonatomic, copy) NSString *name2;
@property(nonatomic, copy) NSString *name3;
@property(nonatomic, strong) AccMsgYYModel *accMsg;//二类户信息
@property(nonatomic, strong) NSArray<BankCardYYModel *> *ddm;//二类户信息
@end

@interface AccMsgYYModel:NSObject

@property(nonatomic, copy) NSString *accNo;//卡号
@property(nonatomic, copy) NSString *name;//
@property (nonatomic, strong) NSMutableArray<BankCardYYModel *> *accNoList;//银行卡列表
@property(nonatomic, copy) NSString *phoneNo;//手机号
@property(nonatomic, copy) NSString *cardNo;//会员卡号

@end

@interface BankCardYYModel : NSObject

@property (nonatomic,copy) NSString *accNo; //"622202*********4835"
@property (nonatomic,copy) NSString *accId;//"291"
@property (nonatomic,copy) NSString *cardFlag;//"01"
@property (nonatomic,copy) NSString *bankName;//"农业银行 (4835)"
@property (nonatomic,copy) NSString *logo;//http://10.79.1.143/CSMBP/images/banklogo/02.png
@end


