//
//  GPOperationTableViewCell.m
//  testDemo
//
//  Created by lignpeng on 17/3/22.
//  Copyright © 2017年 genpeng. All rights reserved.
//

#import "GPOperationTableViewCell.h"

@interface GPOperationTableViewCell()

@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property(nonatomic, assign) BOOL status;
@end

@implementation GPOperationTableViewCell

- (IBAction)action:(UIButton *)sender {
    if (self.cellActionCallBackBlock) {
        self.cellActionCallBackBlock(self.status,self);
    }
    self.status = !self.status;
    [self.actionButton setTitle:self.status?@"展开":@"收起" forState:UIControlStateNormal];
}

- (void)configCellInfo:(NSString *)string {
    [self.actionButton setTitle:self.status?@"展开":@"收起" forState:UIControlStateNormal];
    self.infoLabel.text = string;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self initView];
}

- (void)initView {
    self.status = YES;
    [self.actionButton setTitle:@"展开" forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
