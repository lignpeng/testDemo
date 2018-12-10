//
//  CSBrowingHistoryAirPortCell.m
//  testDemo
//
//  Created by lignpeng on 2017/11/15.
//  Copyright © 2017年 genpeng. All rights reserved.
//

#import "CSBrowingHistoryAirPortCell.h"
#import "CSBrowingHistoryModel.h"

@interface CSBrowingHistoryAirPortCell()

@property (weak, nonatomic) IBOutlet UIImageView *broweTypeImageView;
@property (weak, nonatomic) IBOutlet UILabel *broweTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *startPortLabel;
@property (weak, nonatomic) IBOutlet UILabel *endPortLabel;
@property (weak, nonatomic) IBOutlet UIImageView *flightTypeImageView;
@property (weak, nonatomic) IBOutlet UILabel *flightTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *passengerLabel;
@property (weak, nonatomic) IBOutlet UIView *separatorView;

@property(nonatomic, strong) CSBrowingHistoryModel *model;

@end

@implementation CSBrowingHistoryAirPortCell

+ (instancetype)browingHistoryAirPortCellWithTableView:(UITableView *)tableView {
    CSBrowingHistoryAirPortCell * cell = [tableView dequeueReusableCellWithIdentifier:kCSBrowingHistoryAirPortCell];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
        NSLog(@"创建了一个cell");
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self initView];
}

- (void)initView {
    self.broweTypeLabel.text = @"";
//    self.broweTypeLabel.backgroundColor = [UIColor grayColor];
    self.broweTypeLabel.layer.cornerRadius = 3.0;
    self.broweTypeLabel.clipsToBounds = YES;
    self.startPortLabel.text = @"";
    self.endPortLabel.text = @"";
    self.flightTimeLabel.text = @"";
    self.passengerLabel.text = @"";
}

- (void)setupBrowingHistoryCellWithModel:(CSBrowingHistoryModel *)model {
    self.model = model;
    NSArray *typeImageArray = @[@"icon_jpdh",@"icon_jpyd",@"icon_hbdt"];
    NSArray *typeTitleArray = @[@"机票兑换",@"机票预订",@"航班动态"];
    self.broweTypeImageView.image = [UIImage imageNamed:typeImageArray[model.historyType]];
    self.broweTypeLabel.text = typeTitleArray[model.historyType];
    self.startPortLabel.text = model.flightStart;
    self.endPortLabel.text = model.flightEnd;
    NSString *imageName = model.flightType == 0?@"dancheng_jt":@"wangfan_JT";
    self.flightTypeImageView.image = [UIImage imageNamed:imageName];
    self.flightTimeLabel.text = model.flightStartTime;
    self.passengerLabel.text = [NSString stringWithFormat:@"%d成人  %d儿童",model.adultNum,model.childrenNum];
}

- (void)hiddenSeparatorView:(BOOL)hidden {
    self.separatorView.hidden = hidden;
}


@end
