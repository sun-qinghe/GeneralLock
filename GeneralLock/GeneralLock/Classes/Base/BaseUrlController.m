//
//  BaseUrlController.m
//  飞鸽出行
//
//  Created by 安中 on 2020/3/16.
//  Copyright © 2020 niehaoyu. All rights reserved.
//

#import "BaseUrlController.h"

@interface BaseUrlController ()<WKUIDelegate,WKNavigationDelegate>

@end

@implementation BaseUrlController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupWebUI];
}

-(void)setupWebUI{
    WKWebView *webView = [[WKWebView alloc] init];
    [self.view addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    webView.UIDelegate              = self;
    webView.navigationDelegate      = self;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    
    if (@available(iOS 11.0, *)) {
        webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

#pragma mark - 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSLog(@"开始");
}

#pragma mark - 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"完成");
}

@end
