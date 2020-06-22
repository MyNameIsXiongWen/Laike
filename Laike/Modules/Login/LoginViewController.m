//
//  LoginViewController.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/15.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "LoginViewController.h"
#import "ThirdLoginHelper.h"
#import "LoginService.h"
#import "CTMediator+ViewController.h"
#import <CL_ShanYanSDK/CL_ShanYanSDK.h>

@interface LoginViewController ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *codeBtn;
@property (nonatomic, strong) UILabel *codeLabel;
@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, strong) UITextField *codeTextField;

@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UILabel *userProtocolLabel;
@property (nonatomic, strong) UILabel *userPrivacyLabel;
@property (nonatomic, strong) UIButton *wechatBtn;
@property (nonatomic, strong) UIButton *phoneBtn;
@property (nonatomic, strong) UIButton *loginBtn;

@property (nonatomic, assign) NSInteger codeTime;

@property (nonatomic, strong) LoginService *loginService;

@end

static NSInteger const CodeCountTime = 60;
@implementation LoginViewController

- (void)dealloc {
    if (self.loginService.timer) {
        dispatch_cancel(self.loginService.timer);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView)]];
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.kNavigationView.title = @"注册登录";
    [self.kNavigationView.leftBtn setImage:nil forState:0];
    
    self.codeTime = CodeCountTime;
    [self configUI];
    [CLShanYanSDKManager preGetPhonenumber:nil];
}


- (void)configUI {
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.phoneTextField];
    [self.view addSubview:self.codeTextField];
    [self.view addSubview:self.codeBtn];
    [self.view addSubview:self.codeLabel];
    [self.view addSubview:self.loginBtn];
    [self.view addSubview:self.wechatBtn];
    [self.view addSubview:self.phoneBtn];
    [self.view addSubview:self.userProtocolLabel];
    [self.view addSubview:self.userPrivacyLabel];
    if ([kUserDefault objectForKey:kConstPhoneNumber]) {
        self.phoneTextField.text = [kUserDefault objectForKey:kConstPhoneNumber];
        self.codeLabel.textColor = kColorTheme5c98f8;
    }
}

- (void)tapView {
    [self.view endEditing:YES];
}

- (void)clickLoginBtn {
    [self.loginService loginRequestWithPhone:self.phoneTextField.text Code:self.codeTextField.text];
}

- (void)clickCodeBtn {
    [self.loginService sendCodeRequestWithPhone:self.phoneTextField.text Complete:^{
        self.codeBtn.hidden = YES;
        self.codeLabel.hidden = NO;
    } TimerHandler:^{
        self.codeTime--;
        self.codeLabel.text = [NSString stringWithFormat:@"%lds后重新获取", (long)self.codeTime];
        if (self.codeTime > 0 && self.codeTime < CodeCountTime) {
            self.codeLabel.textColor = kColorTheme999;
        } else {
            self.codeTime = CodeCountTime;
            dispatch_cancel(self.loginService.timer);
            self.codeBtn.hidden = NO;
            self.codeLabel.hidden = YES;
        }
    }];
}

- (void)clickWechatBtn {
    [ThirdLoginHelper.sharedInstance getUserInfoForPlatform:UMSocialPlatformType_WechatSession isBind:NO];
}

- (void)clickPhoneBtn {
    CLUIConfigure * baseUIConfigure = CLUIConfigure.new;
    baseUIConfigure.viewController = self;
    baseUIConfigure.clLogoImage = kImageMake(@"login_phone");
    baseUIConfigure.clNavigationBackBtnImage = kImageMake(@"global_back");
    baseUIConfigure.clLoginBtnBgColor = kColorThemefb4d56;
    baseUIConfigure.clLoginBtnTextColor = kColorThemefff;
    baseUIConfigure.clLoginBtnCornerRadius = @(7);
    CLOrientationLayOut *logoLayout = CLOrientationLayOut.new;
    logoLayout.clLayoutLogoTop = @(kTopBarHeight+20);
    logoLayout.clLayoutPhoneTop = @(kTopBarHeight+100);
    logoLayout.clLayoutAppPrivacyTop = @(kTopBarHeight+140);
    logoLayout.clLayoutLoginBtnTop = @(kTopBarHeight+180);
    logoLayout.clLayoutLogoCenterX = @(0);
    logoLayout.clLayoutPhoneCenterX = @(0);
    logoLayout.clLayoutAppPrivacyCenterX = @(0);
    logoLayout.clLayoutLoginBtnCenterX = @(0);
    logoLayout.clLayoutLoginBtnWidth = @(kScreenW-80);
    logoLayout.clLayoutLoginBtnHeight = @(50);
    baseUIConfigure.clOrientationLayOutPortrait = logoLayout;
    
    [QHWHttpLoading show];
    [CLShanYanSDKManager quickAuthLoginWithConfigure:baseUIConfigure openLoginAuthListener:^(CLCompleteResult * _Nonnull completeResult) {
        [QHWHttpLoading dismiss];
        if (completeResult.error) {
            //拉起授权页失败
            NSLog(@"openLoginAuthListener:%@",completeResult.error.userInfo);
            [SVProgressHUD showInfoWithStatus:@"登录失败"];
        } else {
           //拉起授权页成功
            NSLog(@"openLoginAuthListener:%@",completeResult.yy_modelToJSONObject);
        }
    } oneKeyLoginListener:^(CLCompleteResult * _Nonnull completeResult) {
        if (completeResult.error) {
            //一键登录失败
            NSLog(@"oneKeyLoginListener:%@",completeResult.error.description);
            
            //提示：错误无需提示给用户，可以在用户无感知的状态下直接切换登录方式
            if (completeResult.code == 1011){
                //用户取消登录（点返回）
                //处理建议：如无特殊需求可不做处理，仅作为交互状态回调，此时已经回到当前用户自己的页面
                //点击sdk自带的返回，无论是否设置手动销毁，授权页面都会强制关闭
            } else {
                //处理建议：其他错误代码表示闪验通道无法继续，可以统一走开发者自己的其他登录方式，也可以对不同的错误单独处理
                //关闭授权页，如果授权页还未拉起，此调用不会关闭当前用户vc，即不执行任何代码
                [CLShanYanSDKManager finishAuthControllerCompletion:nil];
            }
        } else {
            //一键登录获取Token成功
            NSLog(@"oneKeyLoginListener:%@",completeResult.yy_modelDescription);
            NSString *token = completeResult.data[@"token"];
            [self.loginService loginRequestWithSYToken:token];
        }
    }];
}

- (void)tapUserProtocol {
    [CTMediator.sharedInstance CTMediator_viewControllerForH5WithUrl:kServiceProtocol TitleName:@"服务协议"];
}

- (void)tapPrivacyProtocol {
    [CTMediator.sharedInstance CTMediator_viewControllerForH5WithUrl:kPrivacyProtocol TitleName:@"隐私协议"];
}

- (void)textFieldValueChanged:(UITextField *)textField {
    if (textField.tag == 111) {
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
            return;
        }
    } else if (textField.tag == 222) {
        if (textField.text.length > 6) {
            textField.text = [textField.text substringToIndex:6];
            return;
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.labelFrame(CGRectMake(15, kTopBarHeight+35, 100, 73)).labelText(@"注册登录").labelFont(kFontTheme20).labelTitleColor(kColorTheme000);
    }
    return _titleLabel;
}

- (UITextField *)phoneTextField {
    if (!_phoneTextField) {
        _phoneTextField = UITextField.tfFrame(CGRectMake(15, self.titleLabel.bottom+10, kScreenW-130, 50)).tfPlaceholder(@"请输入手机号").tfFont(kFontTheme15).tfTextColor(kColorTheme000);
        _phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
        _phoneTextField.tag = 111;
        [_phoneTextField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
        UIView *line = UIView.viewFrame(CGRectMake(15, _phoneTextField.bottom, kScreenW-30, 0.5)).bkgColor(kColorThemeeee);
        [self.view addSubview:line];
    }
    return _phoneTextField;
}

- (UITextField *)codeTextField {
    if (!_codeTextField) {
        _codeTextField = UITextField.tfFrame(CGRectMake(15, self.phoneTextField.bottom+5, kScreenW-30, 50)).tfPlaceholder(@"请输入验证码").tfFont(kFontTheme15).tfTextColor(kColorTheme000);
        _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
        _codeTextField.tag = 222;
        [_codeTextField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
        
        UIView *line = UIView.viewFrame(CGRectMake(15, _codeTextField.bottom, kScreenW-30, 0.5)).bkgColor(kColorThemeeee);
        [self.view addSubview:line];
        
        self.tipLabel = UILabel.labelFrame(CGRectMake(15, _codeTextField.bottom+18, kScreenW-30, 17)).labelText(@"点击注册登录表示您已阅读并同意去海外").labelFont(kFontTheme12).labelTitleColor(kColorTheme999);
        [self.view addSubview:self.tipLabel];
    }
    return _codeTextField;
}

- (UIButton *)codeBtn {
    if (!_codeBtn) {
        _codeBtn = UIButton.btnFrame(CGRectMake(kScreenW-115, self.phoneTextField.y, 100, 50)).btnTitle(@"获取验证码").btnFont(kFontTheme14).btnTitleColor(kColorTheme5c98f8);
        [_codeBtn addTarget:self action:@selector(clickCodeBtn) forControlEvents:UIControlEventTouchUpInside];
        _codeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    return _codeBtn;
}

- (UILabel *)codeLabel {
    if (!_codeLabel) {
        _codeLabel = UILabel.labelFrame(self.codeBtn.frame).labelFont(kFontTheme14).labelTitleColor(kColorTheme5c98f8).labelTextAlignment(NSTextAlignmentCenter);
        _codeLabel.hidden = YES;
    }
    return _codeLabel;
}

- (UIButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = UIButton.btnFrame(CGRectMake(15, self.userProtocolLabel.bottom+50, kScreenW-30, 50)).btnTitle(@"注册登录").btnTitleColor(kColorThemefff).btnFont(kFontTheme18).btnCornerRadius(4).btnBkgColor(kColorThemefb4d56);
        [_loginBtn addTarget:self action:@selector(clickLoginBtn) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *label = UILabel.labelFrame(CGRectMake((kScreenW-90)/2, _loginBtn.bottom+38, 90, 20)).labelText(@"其他登录方式").labelFont(kFontTheme14).labelTitleColor(kColorThemea4abb3).labelTextAlignment(NSTextAlignmentCenter);
        [self.view addSubview:label];
        UIView *line1 = UIView.viewFrame(CGRectMake(label.left-35-70, label.y+10, 70, 0.5)).bkgColor(kColorThemeeee);
        [self.view addSubview:line1];
        UIView *line2 = UIView.viewFrame(CGRectMake(label.right+35, line1.y, 70, 0.5)).bkgColor(kColorThemeeee);
        [self.view addSubview:line2];
    }
    return _loginBtn;
}

- (UILabel *)userProtocolLabel {
    if (!_userProtocolLabel) {
        _userProtocolLabel = UILabel.labelFrame(CGRectMake(15, self.tipLabel.bottom+10, 75, 17)).labelText(@"《服务协议》").labelFont(kFontTheme12).labelTitleColor(kColorTheme5c98f8);
        _userProtocolLabel.userInteractionEnabled = YES;
        [_userProtocolLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapUserProtocol)]];
    }
    return _userProtocolLabel;
}

- (UILabel *)userPrivacyLabel {
    if (!_userPrivacyLabel) {
        _userPrivacyLabel = UILabel.labelFrame(CGRectMake(_userProtocolLabel.right+5, _userProtocolLabel.y, 75, 17)).labelText(@"《隐私协议》").labelFont(kFontTheme12).labelTitleColor(kColorTheme5c98f8);
        _userPrivacyLabel.userInteractionEnabled = YES;
        [_userPrivacyLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPrivacyProtocol)]];
    }
    return _userPrivacyLabel;
}

- (UIButton *)wechatBtn {
    if (!_wechatBtn) {
        _wechatBtn = UIButton.btnFrame(CGRectMake((kScreenW-140)/2, self.loginBtn.bottom+85, 42, 42)).btnImage(kImageMake(@"login_wechat"));
        _wechatBtn.hidden = NO;
        [_wechatBtn addTarget:self action:@selector(clickWechatBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _wechatBtn;
}

- (UIButton *)phoneBtn {
    if (!_phoneBtn) {
        _phoneBtn = UIButton.btnFrame(CGRectMake(self.wechatBtn.right+55, self.wechatBtn.top, 42, 42)).btnImage(kImageMake(@"login_phone"));
        _phoneBtn.hidden = NO;
        [_phoneBtn addTarget:self action:@selector(clickPhoneBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _phoneBtn;
}

- (LoginService *)loginService {
    if (!_loginService) {
        _loginService = LoginService.new;
    }
    return _loginService;
}

@end
