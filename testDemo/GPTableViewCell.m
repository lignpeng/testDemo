//
//  GPTableViewCell.m
//  testDemo
//
//  Created by genpeng on 16/11/25.
//  Copyright © 2016年 genpeng. All rights reserved.
//

#import "GPTableViewCell.h"

@implementation GPTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.infoLabel.text = @"";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
