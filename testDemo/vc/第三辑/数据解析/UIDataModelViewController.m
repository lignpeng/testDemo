//
//  UIDataModelViewController.m
//  testDemo
//
//  Created by lignpeng on 2018/12/27.
//  Copyright © 2018年 genpeng. All rights reserved.
//

#import "UIDataModelViewController.h"
#import "DataTools.h"
#import "HexColor.h"
#import "DataJsonModel.h"
#import "DataYYModel.h"

@interface UIDataModelViewController ()

@property(nonatomic, strong) UITextView *textView;

@end

@implementation UIDataModelViewController

+ (instancetype)create {
    UIDataModelViewController *vc = [UIDataModelViewController new];
    return vc;
}

+ (NSString *)fun:(NSString *)name {
    return [NSString stringWithFormat:@"hello %@",name];
}

+ (NSString *)add:(NSString *)str1 with:(NSString *)str2 {
    return [NSString stringWithFormat:@"%@ + %@ = hello",str1,str2];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    
}

- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat margin = 32;
    CGRect sframe = [UIScreen mainScreen].bounds;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(margin, margin * 3, CGRectGetWidth(sframe) - margin * 2, 42)];
    [button addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"action" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorWith8BitRed:arc4random()%256 green:arc4random()%256 blue:arc4random()%256];
    button.layer.cornerRadius = 5;
    button.clipsToBounds = YES;
    [self.view addSubview:button];
    CGRect bframe = button.frame;
    CGFloat y = CGRectGetHeight(bframe) + CGRectGetMinY(bframe) + margin * 0.25;
    self.textView.frame = (CGRect){margin * 0.5,y,CGRectGetWidth(sframe) - margin,CGRectGetHeight(sframe) - y - margin};
    [self.view addSubview:self.textView];
}

- (void)action {
        //    do something.
    NSDictionary *dic = [self data];
    
    WalletInfoJsonModel *jsonWallet = [[WalletInfoJsonModel alloc] initWithDictionary:dic error:nil];
    WalletInfoYYModel *yyWallet = [WalletInfoYYModel modelWithDictionary:dic];
    NSLog(@"-----------");
    for (int i = 0; i < yyWallet.accMsg.accNoList.count; i++) {
        BankCardJsonModel *jsonmodel = jsonWallet.accMsg.accNoList[i];
        BankCardYYModel *yymodel = yyWallet.accMsg.accNoList[i];

        if ([jsonmodel isKindOfClass:[NSDictionary class]]) {
            NSLog(@"jsonmodel = dictionary");
//            jsonmodel = [[BankCardJsonModel alloc] initWithDictionary:jsonmodel error:nil];
        }else if ([jsonmodel isKindOfClass:[BankCardJsonModel class]]){
            NSLog(@"jsonmodel = BankCardJsonModel");
        }

        if ([yymodel isKindOfClass:[NSDictionary class]]) {
            NSLog(@"yymodel = dictionary");
        }else if ([yymodel isKindOfClass:[BankCardYYModel class]]){
            NSLog(@"yymodel = BankCardJsonModel");
        }
    }
    
    for (int i = 0; i < yyWallet.ddm.count; i++) {
        BankCardJsonModel *jsonmodel = jsonWallet.ddm[i];
        BankCardYYModel *yymodel = yyWallet.ddm[i];
        
        if ([jsonmodel isKindOfClass:[NSDictionary class]]) {
            NSLog(@"jsonmodel = dictionary");
                //            jsonmodel = [[BankCardJsonModel alloc] initWithDictionary:jsonmodel error:nil];
        }else if ([jsonmodel isKindOfClass:[BankCardJsonModel class]]){
            NSLog(@"jsonmodel = BankCardJsonModel");
        }
        
        if ([yymodel isKindOfClass:[NSDictionary class]]) {
            NSLog(@"yymodel = dictionary");
        }else if ([yymodel isKindOfClass:[BankCardYYModel class]]){
            NSLog(@"yymodel = BankCardYYModel");
        }
    }
    
    NSDictionary *json = (NSDictionary *)jsonWallet.accMsg.accNoList[0];
    BankCardJsonModel *model1 = [[BankCardJsonModel alloc] initWithDictionary:json error:nil];
//    NSLog(@"mm %@",model1.bankName);
    
    BankCardJsonModel *model2 = [model1 copy];//使用jsonmodel，可以直接使用这个方法
    model2.bankName = @"111111";
    BankCardJsonModel *model3 = [model1 modelCopy];//yymodel的方法
    model3.bankName = @"2222222";
    NSLog(@"1 = %p 2 = %p 3 = %p",model1,model2,model3);
    
    NSLog(@"1 = %@ 2 = %@ 3 = ",model1.bankName,model2.bankName);
    NSString *value = @"5092";
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"accId = %@",value];
    NSArray *filterArray = [jsonWallet.accMsg.accNoList filteredArrayUsingPredicate:pre];
    NSLog(@"%@",filterArray);

}

- (NSDictionary *)data {
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"GGTestModelData" ofType:@"json" inDirectory:@"Resource/data"]];
    NSError *error;
    id dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (error) {
        NSLog(@"%@",error);
        return @{};
    }
    if ([dic isKindOfClass:[NSDictionary class]]) {
        NSLog(@"yes");
    }
//    NSLog(@"%@",dic);
    [self showString:@[@"yes",dic]];
    return dic;
}

- (void)showString:(NSArray *)array {
    NSString *str = @"";
    for (NSString *string in array) {
        str = [str stringByAppendingFormat:@"\n%@",string];
    }
    self.textView.text = str;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [UITextView new];
        _textView.font = [UIFont systemFontOfSize:14];
        _textView.showsHorizontalScrollIndicator = NO;
        _textView.editable = NO;
        _textView.textAlignment = NSTextAlignmentLeft;
    }
    return _textView;
}

@end
