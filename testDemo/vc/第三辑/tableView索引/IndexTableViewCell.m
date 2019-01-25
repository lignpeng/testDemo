//
//  IndexTableViewCell.m
//  testDemo
//
//  Created by lignpeng on 2019/1/25.
//  Copyright © 2019年 genpeng. All rights reserved.
//

#import "IndexTableViewCell.h"



@interface IndexTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;


@end

@implementation IndexTableViewCell

+ (instancetype)indexTableViewCell:(UITableView *)tableView info:(NSString *)info{
    IndexTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    }
    cell.infoLabel.text = info;
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.infoLabel.text = @"";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
