
#import <UIKit/UIKit.h>

typedef void (^CSWalletHeaderTableViewSelectCallBack)();
typedef void (^CSWalletHeaderTableViewInfoCallBack)();

@interface GPKeyBoardHeaderTableView : UITableViewCell

@property(nonatomic, copy) CSWalletHeaderTableViewSelectCallBack walletHeaderTableViewSelectCallBack;

+ (instancetype)createWalletHeaderTableView;
- (void)configWalletHeaderTableViewWithBalence:(NSString *)balence numberOfCashCoupons:(NSInteger)count totalMoney:(double)totalMoney;
- (void)configSelectButtonIcon:(BOOL)selected;

@end
