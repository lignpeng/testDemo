//
//  AlipayViewController.m
//  testDemo
//
//  Created by lignpeng on 17/2/9.
//  Copyright © 2017年 genpeng. All rights reserved.
//

#import "AlipayViewController.h"
//#import <AlipaySDK/AlipaySDK.h>

@interface AlipayViewController ()<UIWebViewDelegate>
@property(nonatomic, strong) UIWebView *webView;
@end

@implementation AlipayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.webView];
    self.webView.delegate = self;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"进入" style:UIBarButtonItemStylePlain target:self action:@selector(showAction)];
//    CGRect frame = [UIScreen mainScreen].bounds;
//    CGFloat margin = 32;
//    CGFloat wdith = (CGRectGetWidth(frame) - 2 * margin);
//    CGFloat height = 42;
//    
//    CGRect bframe = CGRectMake(margin, margin + 64, wdith, height);
//    UIButton *showBtn = ({
//        UIButton *btn = [[UIButton alloc] initWithFrame:bframe];
//        btn.backgroundColor = [UIColor blueColor];
//        [btn setTitle:@"show" forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [btn addTarget:self action:@selector(showAction) forControlEvents:UIControlEventTouchUpInside];
//        btn.layer.cornerRadius = 5.0;
//        btn.clipsToBounds = YES;
//        btn;
//    });
//    [self.view addSubview:showBtn];
}

- (void)showAction {
    NSString *urlString = @"http://10.92.21.85/extra/lounge/welcome.html?productId=782c019381d54bfda7725c0f9b565cc5&airport=CAN";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [self.webView loadRequest:request];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
//    NSString* orderInfo = [[AlipaySDK defaultService]fetchOrderInfoFromH5PayUrl:[request.URL absoluteString]];
//    if (orderInfo.length > 0) {
        // 调用支付接口进行支付
//        [[AlipaySDK defaultService]payUrlOrder:orderInfo fromScheme:@"kCallBackApplication" callback:^(NSDictionary* result) {
//            // 处理返回结果
//            NSString* resultCode = result[@"resultCode"];
//            //建议操作: 根据resultCode做处理
//            
//            // returnUrl 代表 第三方App需要跳转的成功页URL
//            NSString* returnUrl = result[@"returnUrl"];
//            //建议操作: 打开returnUrl
//        }];
        
//        return YES;
//    }

    
    return YES;
}

@end
