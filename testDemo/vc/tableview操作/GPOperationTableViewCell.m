//
//  GPOperationTableViewCell.m
//  testDemo
//
//  Created by lignpeng on 17/3/22.
//  Copyright © 2017年 genpeng. All rights reserved.
//

#import "GPOperationTableViewCell.h"


@implementation GPOperationTableViewCell

- (IBAction)action:(UIButton *)sender {
    if (self.cellActionCallBackBlock) {
        self.cellActionCallBackBlock(self);
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
