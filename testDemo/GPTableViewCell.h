//
//  GPTableViewCell.h
//  testDemo
//
//  Created by genpeng on 16/11/25.
//  Copyright © 2016年 genpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#define cellIdentify @"cellReuse"

@interface GPTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end
