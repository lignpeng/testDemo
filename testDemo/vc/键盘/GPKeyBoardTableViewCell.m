

#import "GPKeyBoardTableViewCell.h"

@interface GPKeyBoardTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *totalBalenceLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *balenceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *infoBarImageView;
@property (weak, nonatomic) IBOutlet UILabel *infoBarLabel;

@end

@implementation GPKeyBoardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self initView];
}
- (IBAction)buttonClickAction:(id)sender {

}

-(void)initView {
    self.backView.backgroundColor = [UIColor clearColor];
    self.backView.layer.borderWidth = 1;
    self.backView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.backView.layer.cornerRadius = 3.0;
    self.backView.clipsToBounds = YES;
    self.balenceLabel.text = @"0.00";
    self.totalBalenceLabel.text = @"0.00";
    self.dateLabel.text = @"";
    self.infoBarImageView.hidden = YES;
    self.infoBarLabel.hidden = YES;
}

- (void)configCashCouponsCellWithCashCouponModel:(Model *)model {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
