//
//  GGWebViewController.h
//  testDemo
//
//  Created by lignpeng on 2019/1/17.
//  Copyright © 2019年 genpeng. All rights reserved.
//
/*
 web框架
 */
/*
 1、界面搭建
 2、实现标题更新、进度、刷新、后退、关闭、更多
 3、js原生交互
 4、ccookie缓存
 https://www.jianshu.com/p/870dba42ec15
 Cookie管理
 比起UIWebView的自动管理，WKWebView坑爹的Cookie管理，相信阻止了很多的尝试者。许多小伙伴也许曾经都想从UIWebView转到WKWebView，但估计因为Cookie的问题，最终都放弃了，笔者折腾WKWebView的Cookie长达多半年之久，也曾想放弃，但最终还是坚持下来了，虽说现在不敢说完全掌握，至少也不影响正常使用了。
 
 1）WKWebView加载网页得到的Cookie会同步到NSHTTPCookieStorage中（也许你看过一些文章说不能同步，但笔者这里说下，它真的会，大家可以尝试下，实践出真知）。
 2）WKWebView加载请求时，不会同步NSHTTPCookieStorage中已有的Cookie（是的，最坑的地方）。
 3）通过共用一个WKProcessPool并不能解决2中Cookie同步问题，且可能会造成Cookie丢失。
 
 
 
 */


#import <UIKit/UIKit.h>


@interface GGWebViewController : UIViewController

+ (instancetype)loadUrl:(NSString *)url;

@end

