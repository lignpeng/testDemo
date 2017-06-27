//
//  ModelViewController.m
//  testDemo
//
//  Created by gaby on 2017/6/16.
//  Copyright © 2017年 genpeng. All rights reserved.
//

#import "ModelViewController.h"
#import "CSEMemberInfoModel.h"
#import "UnmenberToken.h"
#import "NSObject+YYModel.h"
#import "GPTools.h"

@interface ModelViewController ()

@end

@implementation ModelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect frame = [UIScreen mainScreen].bounds;
    CGFloat margin = 32;
    CGFloat wdith = (CGRectGetWidth(frame) - 2 * margin);
    CGFloat height = 42;
    
    CGRect bframe = CGRectMake(margin, CGRectGetHeight(frame) - height - margin, wdith, height);
    UIButton *showBtn = ({
        UIButton *btn = [[UIButton alloc] initWithFrame:bframe];
        btn.backgroundColor = [UIColor blueColor];
        [btn setTitle:@"show" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(showAction) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.cornerRadius = 5.0;
        btn.clipsToBounds = YES;
        btn;
    });
    [self.view addSubview:showBtn];
}

- (void)showAction {
    [self string];
}

- (NSDictionary *) string {
//    NSString *string = @"content{RZDBChangeKeyPath = content;RZDBChangeNew =     {loginType = 2;nonFfpUser ={eLoginInfo = {aid = ff8080815c9fe310015ca44e64a4018e;eBasicInfo =                 {aid = ff8080815c9fe310015ca44e64a4018e;identifyCertNum = 360731199002173817;identifyCertType = NI;identifyCnName = 身份证;identifyMobile = 13631324537;};identifyStatus = Y;};key = S;mobileNo = 13631324537;};oneToManyFlag = 0;};}";
//    NSError *error = nil;
//    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
//    if (error) {
//        NSLog(@"error= %@",error);
//    }
//    NSLog(@"dic = ",dic);
    
    CSEMemberInfoModel *model = [CSEMemberInfoModel new];
    [model.nonFfpUser setData];
    [model.nonFfpUser.eLoginInfo setData];
    [model.token setData];
    
    NSDictionary *dic = [model modelToJSONObject];
    CSEMemberInfoModel *newModel = [CSEMemberInfoModel new];
    
    [newModel modelSetWithDictionary:dic];
    
    return [NSDictionary new];
}

- (void)number {
    NSString *num = [[NSUserDefaults standardUserDefaults] stringForKey:@"SBFormattedPhoneNumber"];
    [GPTools ShowAlert:num];
}

@end
