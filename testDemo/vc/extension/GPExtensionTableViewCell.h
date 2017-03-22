//
//  GPExtensionTableViewCell.h
//  testDemo
//
//  Created by lignpeng on 16/12/1.
//  Copyright © 2016年 genpeng. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^extensionActinBlock)(BOOL status, UITableViewCell *cell);

@interface GPExtensionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *extensionButton;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@property(nonatomic, copy) extensionActinBlock actionBlock;

- (void)setCellExtensionStatus:(BOOL)status infoString:(NSString *)infoString;

@end
