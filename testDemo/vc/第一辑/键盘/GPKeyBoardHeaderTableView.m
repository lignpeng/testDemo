

#import "GPKeyBoardHeaderTableView.h"

static NSString *imageString = @"icon_right";

@interface GPKeyBoardHeaderTableView()

@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UILabel *balenceLabel;
@property (weak, nonatomic) IBOutlet UILabel *cashCouponsNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel;

@end

@implementation GPKeyBoardHeaderTableView

+ (instancetype)createWalletHeaderTableView {
    GPKeyBoardHeaderTableView *headerView = [[NSBundle mainBundle] loadNibNamed:@"GPKeyBoardHeaderTableView" owner:nil options:nil].firstObject;
    return headerView;
}

- (void)configWalletHeaderTableViewWithBalence:(NSString *)balence numberOfCashCoupons:(NSInteger)count totalMoney:(double)totalMoney {
    self.balenceLabel.text = balence;
    self.cashCouponsNumLabel.text = [NSString stringWithFormat:@"%d",count];
    self.totalMoneyLabel.text = [NSString stringWithFormat:@"%.2f",totalMoney];
}

- (void)configSelectButtonIcon:(BOOL)selected {
    imageString = selected?@"icon_right":@"icon_gray";
    [self.selectButton setImage:[UIImage imageNamed:imageString] forState:UIControlStateNormal];
    [self.selectButton setImage:[UIImage imageNamed:imageString] forState:UIControlStateSelected];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self initView];
}

- (void)initView {
    self.balenceLabel.text = @"0.00";
    self.cashCouponsNumLabel.text = @"0";
    self.totalMoneyLabel.text = @"0.00";
}

- (IBAction)selectButtonAction:(UIButton *)sender {
    
    [self.selectButton setImage:[UIImage imageNamed:imageString] forState:UIControlStateNormal];
    [self.selectButton setImage:[UIImage imageNamed:imageString] forState:UIControlStateSelected];
    imageString = [imageString isEqualToString:@"icon_right"]?@"icon_gray":@"icon_right";
    if (self.walletHeaderTableViewSelectCallBack) {
        self.walletHeaderTableViewSelectCallBack();
    }    
}

- (IBAction)infoButtonClickAction:(UIButton *)sender {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
