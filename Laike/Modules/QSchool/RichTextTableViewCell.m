//
//  RichTextTableViewCell.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/27.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "RichTextTableViewCell.h"
#import <WebKit/WebKit.h>

@interface RichTextTableViewCell () <WKNavigationDelegate, QHWBaseCellProtocol> {
    CGFloat webContentHeight;
}

@property (nonatomic, strong) WKWebView *wkWebView;

@property (nonatomic, copy) NSString *identifier;

@end

@implementation RichTextTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(10);
            make.bottom.mas_equalTo(-10);
        }];
    }
    return self;
}

- (void)configCellData:(id)data {
    NSDictionary *dic = (NSDictionary *)data;
    [self.wkWebView loadHTMLString:dic[@"data"] baseURL:nil];
    self.identifier = dic[@"identifier"];
}

#pragma mark ------------KVO回调-------------
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    CGFloat newHeight = self.wkWebView.scrollView.contentSize.height;
    [self resetWebViewFrameWithHeight:newHeight];
}

#pragma mark ------------WKNavigationDelegate-------------
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [webView evaluateJavaScript:@"document.body.scrollWidth"completionHandler:^(id _Nullable result,NSError * _Nullable error){
        CGFloat ratio =  kScreenW / [result floatValue];
        [webView evaluateJavaScript:@"document.body.scrollHeight"completionHandler:^(id _Nullable result,NSError * _Nullable error){
            CGFloat newHeight = [result floatValue]*ratio;
            [self resetWebViewFrameWithHeight:newHeight];
        }];
    }];
}

- (void)resetWebViewFrameWithHeight:(CGFloat)height {
    //如果是新高度，那就重置
    if (height != webContentHeight) {
        [self.wkWebView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height);
        }];
        [NSNotificationCenter.defaultCenter postNotificationName:kNotificationReloadRichText object:@{@"height": @(height+20), @"identifier": self.identifier}];
        webContentHeight = height;
    }
}

- (WKWebView *)wkWebView {
    if (!_wkWebView) {
        NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta); var imgs = document.getElementsByTagName('img');for (var i in imgs){imgs[i].style.maxWidth='100%';imgs[i].style.height='auto';}";
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        [wkUController addUserScript:wkUScript];
        WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
        wkWebConfig.userContentController = wkUController;
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:wkWebConfig];
        _wkWebView.scrollView.showsVerticalScrollIndicator = NO;
        _wkWebView.navigationDelegate = self;
        _wkWebView.userInteractionEnabled = NO;
        [self addSubview:_wkWebView];
    }
    return _wkWebView;
}

@end
