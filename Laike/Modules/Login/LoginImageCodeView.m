//
//  LoginImageCodeView.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/15.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "LoginImageCodeView.h"

@interface LoginImageCodeView ()

@property (nonatomic, strong) UIImageView *codeImgView;
@property (nonatomic, strong) UITextField *codeTextField;
@property (nonatomic, strong, readwrite) UILabel *tipLabel;
@property (nonatomic, strong) UIButton *submitBtn;

@end

@implementation LoginImageCodeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.popType = PopTypeCenter;
        [self addSubview:self.codeImgView];
        [self addSubview:self.codeTextField];
        [self addSubview:self.submitBtn];
    }
    return self;
}

- (void)setCodeBase64:(NSString *)codeBase64 {
    NSData *decodeData = [[NSData alloc] initWithBase64EncodedString:codeBase64 options:(NSDataBase64DecodingIgnoreUnknownCharacters)];
    self.codeImgView.image = [UIImage imageWithData: decodeData];
}

- (void)tapCodeImgView {
    if (self.getCodeBlock) {
        self.getCodeBlock();
    }
}

- (void)clickSubmitBtn {
    if (self.codeTextField.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入图形验证码"];
        return;
    }
    if (self.submitBlock) {
        self.submitBlock(self.codeTextField.text);
    }
}

- (void)textFieldValueChanged:(UITextField *)textField {
    if (textField.text.length > 4) {
        textField.text = [textField.text substringToIndex:4];
    }
}

- (UIImageView *)codeImgView {
    if (!_codeImgView) {
        _codeImgView = UIImageView.ivFrame(CGRectMake(15, 15, self.width-30, 100)).ivMode(UIViewContentModeScaleAspectFit).ivAction(self, @selector(tapCodeImgView));
    }
    return _codeImgView;
}

- (UITextField *)codeTextField {
    if (!_codeTextField) {
        _codeTextField = UITextField.tfFrame(CGRectMake(15, self.codeImgView.bottom+10, self.width-30, 40)).tfPlaceholder(@"请输入以上图形验证码").tfFont(kFontTheme14).tfTextColor(kColorTheme000).tfBorderColor(kColorThemeeee).tfCornerRadius(2);
        [_codeTextField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _codeTextField;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = UILabel.labelFrame(CGRectMake(15, _codeTextField.bottom+5, self.width-30, 20)).labelText(@"图形验证码输入有误").labelFont(kFontTheme11).labelTitleColor(kColorThemefb4d56);
        [self addSubview:_tipLabel];
    }
    return _tipLabel;
}

- (UIButton *)submitBtn {
    if (!_submitBtn) {
        _submitBtn = UIButton.btnFrame(CGRectMake(15, self.codeTextField.bottom+30, self.width-30, 50)).btnTitle(@"提交").btnTitleColor(kColorThemefff).btnFont(kFontTheme15).btnCornerRadius(2).btnBkgColor(kColorTheme21a8ff);
        [_submitBtn addTarget:self action:@selector(clickSubmitBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}

@end
