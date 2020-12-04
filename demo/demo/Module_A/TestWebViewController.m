//
//  TestWebViewController.m
//  demo
//
//  Created by 赵学良 on 2020/12/3.
//

#import "TestWebViewController.h"
#import <WebKit/WebKit.h>

@interface TestWebViewController () <WKNavigationDelegate,WKUIDelegate>
@property (nonatomic, strong) WKWebView *webview;

@end

@implementation TestWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _titleStr;

    self.webview = [[WKWebView alloc] initWithFrame:self.view.bounds];
    self.webview.UIDelegate = self;
    self.webview.navigationDelegate = self;
    [self.view addSubview:_webview];
    
    NSURL *url = [NSURL URLWithString:_urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webview loadRequest:request];
}




- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{

}
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
     
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
     
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    
}

@end
