//
//  WebViewController.m
//  testDemo
//
//  Created by lignpeng on 2018/5/7.
//  Copyright © 2018年 genpeng. All rights reserved.
//

#import "WebViewController.h"
#import "WebViewJavascriptBridge.h"


@interface WebViewController ()<WKNavigationDelegate>

@property(nonatomic, strong) WebViewJavascriptBridge *bridge;
@property(nonatomic, strong) WKWebView *webview;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (WebViewJavascriptBridge *)bridge {
    if (!_bridge) {
        _bridge = [WebViewJavascriptBridge bridgeForWebView:self.webview];
        [_bridge setWebViewDelegate:self];
    }
    return _bridge;
}

- (WKWebView *)webview {
    if (!_webview) {
        _webview = [[WKWebView alloc] initWithFrame:self.view.bounds];
    }
    _webview.navigationDelegate = self;
    return _webview;
}

@end

























