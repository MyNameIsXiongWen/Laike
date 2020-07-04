//
//  RichTextWithTitleTableViewCell.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/27.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "RichTextWithTitleTableViewCell.h"
#import <WebKit/WebKit.h>
#import "QHWBaseModel.h"

@interface RichTextWithTitleTableViewCell () <WKNavigationDelegate, QHWBaseCellProtocol> {
    CGFloat webContentHeight;
}

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titlaLabel;
@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) UIView *line;

@property (nonatomic, copy) NSString *identifier;

@end

@implementation RichTextWithTitleTableViewCell

- (void)dealloc {
    
}

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
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(20);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        [self.titlaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imgView.mas_right).offset(10);
            make.centerY.equalTo(self.imgView.mas_centerY);
            make.right.mas_equalTo(-20);
        }];
        [self.wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.equalTo(self.imgView.mas_bottom);
            make.bottom.mas_equalTo(0);
        }];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}

- (void)configCellData:(id)data {
    QHWBaseModel *model = (QHWBaseModel *)data;
    NSDictionary *dic = model.data;
    self.imgView.image = kImageMake(dic[@"img"]);
    self.titlaLabel.text = dic[@"title"];
    [self.wkWebView loadHTMLString:dic[@"content"] baseURL:nil];
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
        [NSNotificationCenter.defaultCenter postNotificationName:kNotificationReloadRichText object:@{@"height": @(height+40), @"identifier": self.identifier}];
        webContentHeight = height;
    }
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = UIImageView.ivInit();
        [self.contentView addSubview:_imgView];
    }
    return _imgView;
}

- (UILabel *)titlaLabel {
    if (!_titlaLabel) {
        _titlaLabel = UILabel.labelInit().labelFont(kFontTheme13).labelTitleColor(kColorTheme2a303c);
        [self.contentView addSubview:_titlaLabel];
    }
    return _titlaLabel;
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
        [self.contentView addSubview:_wkWebView];
    }
    return _wkWebView;
}

- (UIView *)line {
    if (!_line) {
        _line = UIView.viewInit().bkgColor(kColorThemeeee);
        [self.contentView addSubview:_line];
    }
    return _line;
}

@end
