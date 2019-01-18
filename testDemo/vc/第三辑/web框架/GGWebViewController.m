//
//  GGWebViewController.m
//  testDemo
//
//  Created by lignpeng on 2019/1/17.
//  Copyright © 2019年 genpeng. All rights reserved.
//

#import "GGWebViewController.h"
#import <WebKit/WebKit.h>
#import "HexColor.h"
#import "GGWebMenuView.h"
#import "GGWebMenuModel.h"

#define kEstimatedProgress @"estimatedProgress"
#define kWebTitle @"title"
#define kNaviHeight CGRectGetHeight(self.navigationController.navigationBar.frame)

@interface GGWebViewController ()<WKNavigationDelegate>

@property(nonatomic, strong) WKWebView *webView;
@property(nonatomic, strong) NSURL *url;
@property(nonatomic, strong) WKWebViewConfiguration *webViewConfiguration;
@property(nonatomic, strong) UIProgressView *progressView;//进度条

@end

@implementation GGWebViewController

+ (instancetype)loadUrl:(NSString *)url {
    GGWebViewController *vc = [GGWebViewController new];
    [vc loadUrl:url];
    return vc;
}

- (void)loadUrl:(NSString *)url {
    NSString *newUrl;
    //处理中文字符
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    newUrl = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)url, (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]", NULL,kCFStringEncodingUTF8));
#pragma clang diagnostic pop

    self.url = [NSURL URLWithString:newUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:request];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self bindData];
    [self initView];
    [self showUpdateButton:NO];
}

- (void)initView {
    self.view = self.webView;
    [self.view addSubview:self.progressView];
    
    //自定义返回按钮
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kNaviHeight, kNaviHeight)];
    [backButton setImage:[UIImage imageNamed:@"icon-right"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)showUpdateButton:(BOOL)isShow {
    if (isShow) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"..." style:UIBarButtonItemStylePlain target:self action:@selector(moreWebAction)];
        self.navigationItem.rightBarButtonItems = @[item];
    }else {
        self.navigationItem.rightBarButtonItems = nil;
    }
}

- (void)moreWebAction {
    [GGWebMenuView showComplish:^(WebMenuType index) {
        if (WebMenuTypeUpdate == index) {
            [self.webView reloadFromOrigin];
        }
    }];
}

- (void)backAction {
    if ([self.webView canGoForward]) {
//        NSLog(@"------Forward------");
    }
    //可以后退上一页
    if ([self.webView canGoBack]) {
        NSLog(@"------ can back------");
        [self.webView goBack];
    }else {
        [self dismiss];
    }
}

- (void)dismiss {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)bindData {
    //监听webview进度
    [self.webView addObserver:self forKeyPath:kEstimatedProgress options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:kWebTitle options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:kEstimatedProgress]) {
        [self updateProgressViewHasError:NO error:nil];
//        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    if ([keyPath isEqualToString:kWebTitle]) {
        self.title = change[@"new"];
    }
}

- (void)updateProgressViewHasError:(BOOL)hasError error:(NSError *)error{
    if (hasError) {
        self.progressView.hidden = YES;
        if (error) {
            NSLog(@"error = %@",error);
        }
        return;
    }
    self.progressView.hidden = NO;
    
    self.progressView.progress = self.webView.estimatedProgress;
    if (self.progressView.progress == 1) {
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
        } completion:^(BOOL finished) {
            weakSelf.progressView.hidden = YES;
        }];
    }
}

#pragma mark - web delegate

//在发送请求之前，决定是否允许或取消导航。
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    //    NSLog(@"%s", __FUNCTION__);
    static int i = 1;
    NSLog(@"url %d = %@" ,i,navigationAction.request.URL.absoluteString);
    i++;
    // 如果请求的是百度地址，则允许跳转
    //    if ([navigationAction.request.URL.host.lowercaseString isEqual:@"www.baidu.com"]) {
    //        // 允许跳转
    //        decisionHandler(WKNavigationActionPolicyAllow);
    //        return;
    //    }
    decisionHandler(WKNavigationActionPolicyAllow);
    // 否则不允许跳转
    //    decisionHandler(WKNavigationActionPolicyCancel);
}

//开始加载web调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    self.progressView.hidden = NO;
    [self.view bringSubviewToFront:self.progressView];
    [self showUpdateButton:NO];
}

//web内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}

//使用的证书不合法或者证书过期时
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if ([challenge previousFailureCount] == 0) {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        } else {
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
    } else {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
    }
}

//web内容加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self showUpdateButton:YES];
}

//web加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self updateProgressViewHasError:YES error:error];
    [self showUpdateButton:YES];
}

//web视图导航过程发生错误
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self updateProgressViewHasError:YES error:error];
    [self showUpdateButton:YES];
    //请求被取消
    if (error.code == NSURLErrorCancelled) {
        return;
    }
}

//当Web视图的Web内容进程终止时调用
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    [self updateProgressViewHasError:YES error:nil];
    [self showUpdateButton:YES];
}

#pragma mark - init

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] init];
        _webView.frame = [UIScreen mainScreen].bounds;
        _webView.navigationDelegate = self;
        
    }
    return _webView;
}

- (WKWebViewConfiguration *)webViewConfiguration {
    if (!_webViewConfiguration) {
        _webViewConfiguration = [WKWebViewConfiguration new];
    }
    return _webViewConfiguration;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [UIProgressView new];
        CGFloat nHight = CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]) + kNaviHeight;
        _progressView.frame = (CGRect){0,nHight,CGRectGetWidth([UIScreen mainScreen].bounds),2};
        _progressView.tintColor = [UIColor blueColor];
        _progressView.tintColor = [UIColor colorWith8BitRed:140 green:236 blue:74];
        _progressView.trackTintColor = [UIColor whiteColor];
    }
    return _progressView;
}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:kEstimatedProgress];
    [self.webView removeObserver:self forKeyPath:kWebTitle];
}

@end
