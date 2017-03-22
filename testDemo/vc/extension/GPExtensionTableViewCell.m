//
//  GPExtensionTableViewCell.m
//  testDemo
//
//  Created by lignpeng on 16/12/1.
//  Copyright © 2016年 genpeng. All rights reserved.
//

#import "GPExtensionTableViewCell.h"

@implementation GPExtensionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCellExtensionStatus:(BOOL)status infoString:(NSString *)infoString {
    if (status) {
        [self.extensionButton setTitle:@"收起" forState:UIControlStateNormal];
    }else{
        [self.extensionButton setTitle:@"展开" forState:UIControlStateNormal];
        infoString = @"";
    }
    self.infoLabel.text = infoString;
}

- (IBAction)buttonClickAction:(UIButton *)sender {
    BOOL status = NO;
    if ([self.extensionButton.titleLabel.text isEqualToString:@"收起"]) {
        [self.extensionButton setTitle:@"展开" forState:UIControlStateNormal];
        
    }else{
        status = true;
        [self.extensionButton setTitle:@"收起" forState:UIControlStateNormal];
        
    }
    if (self.actionBlock) {
        self.actionBlock(status, self);
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
