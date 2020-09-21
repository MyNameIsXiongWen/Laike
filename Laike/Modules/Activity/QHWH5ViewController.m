//
//  QHWH5ViewController.m
//  GoOverSeas
//
//  Created by xiaobu on 2019/10/9.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "QHWH5ViewController.h"
#import <WebKit/WebKit.h>
#import <WKWebViewJavascriptBridge.h>
#import "UserModel.h"
#import "AppDelegate.h"

#define JsGetMobileNumber @"getMobileNumber"
#define JsIsApp @"isApp"
@interface QHWH5ViewController () <WKNavigationDelegate, WKScriptMessageHandler, WKUIDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) WKWebViewJavascriptBridge *bridge;

@end

@implementation QHWH5ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.kNavigationView.title = self.titleName;
    [QHWHttpLoading show];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.h5Url]]];
    [WKWebViewJavascriptBridge enableLogging];
    self.bridge = [WKWebViewJavascriptBridge bridgeForWebView:self.webView];
    [self.bridge setWebViewDelegate:self];
    [self.bridge registerHandler:JsGetMobileNumber handler:^(id data, WVJBResponseCallback responseCallback) {
        responseCallback([self jsGetMobileNumber]);
    }];
    [self.bridge registerHandler:JsIsApp handler:^(id data, WVJBResponseCallback responseCallback) {
        responseCallback([NSNumber numberWithBool:[self jsIsApp]]);
    }];
}

- (NSString *)jsGetMobileNumber {
    return UserModel.shareUser.mobileNumber;
}

- (BOOL)jsIsApp {
    return YES;
}

#pragma mark ------------WKNavigationDelegate-------------
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [QHWHttpLoading dismiss];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [QHWHttpLoading dismiss];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    id parameter = message.body;
    NSString *method = message.name;
    NSLog(@"parameter===%@\nmethor=====%@", parameter, method);
}

#pragma mark ------------WKUIDelegate-------------
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (WKWebView *)webView {
    if (!_webView) {
        NSString *jScript = @"var script = document.createElement('meta');"
        "script.name = 'viewport';"
        "script.content=\"width=device-width, user-scalable=no\";"
        "document.getElementsByTagName('head')[0].appendChild(script);";
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        [wkUController addUserScript:wkUScript];
        WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
        wkWebConfig.userContentController = wkUController;
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, kTopBarHeight, kScreenW, kScreenH-kTopBarHeight) configuration:wkWebConfig];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        [_webView sizeToFit];
        _webView.scrollView.scrollEnabled = YES;
        _webView.userInteractionEnabled = YES;
        [self.view addSubview:_webView];
    }
    return _webView;
}

@end

@implementation QHWWeakScriptMessageDelegate

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)delegate {
    if (self == [super init]) {
        _scriptDelegate = delegate;
    }
    return self;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
}

@end
