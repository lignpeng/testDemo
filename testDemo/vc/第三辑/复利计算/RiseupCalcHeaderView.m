//
//  RiseupCalcHeaderView.m
//  testDemo
//
//  Created by lignpeng on 2018/7/10.
//  Copyright © 2018年 genpeng. All rights reserved.
//

#import "RiseupCalcHeaderView.h"

@interface RiseupCalcHeaderView()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *sumTextField;
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
@property (weak, nonatomic) IBOutlet UITextField *riseTextField;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UIButton *strCopyButton;

@end


@implementation RiseupCalcHeaderView

+ (instancetype)riseupCalcHeaderView {
    RiseupCalcHeaderView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([RiseupCalcHeaderView class]) owner:nil options:nil] firstObject];
    return view;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initView];
}

- (IBAction)buttonAction:(id)sender {
//    if (self.actionBlock) {
//        self.actionBlock(self.sumTextField.text, self.riseTextField.text, self.numberTextField.text);
//    }
    if (self.editBlock) {
        self.editBlock(self.sumTextField.text, self.riseTextField.text, self.numberTextField.text,YES);
    }
}
- (IBAction)copyStrAction:(id)sender {
    if (self.copyActionBlock) {
        self.copyActionBlock();
    }
}

- (void)initView {
    self.sumTextField.delegate = self;
    self.numberTextField.delegate = self;
    self.riseTextField.delegate = self;
    self.sumTextField.text = @"10000";
    self.numberTextField.text = @"10";
    self.riseTextField.text = @"12";
    self.actionButton.layer.cornerRadius = 5.0;
    self.actionButton.clipsToBounds = YES;
    self.strCopyButton.layer.cornerRadius = 5.0;
    self.strCopyButton.clipsToBounds = YES;
    [self.strCopyButton setTitle:@"Ok" forState:UIControlStateHighlighted];
    [self.strCopyButton setTitle:@"复制" forState:UIControlStateNormal];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //只输入数字
    NSString *str = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    return str.length <= 0;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.editBlock) {
        self.editBlock(self.sumTextField.text, self.riseTextField.text, self.numberTextField.text,NO);
    }
}

@end
