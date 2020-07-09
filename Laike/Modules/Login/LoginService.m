//
//  LoginService.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/15.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "LoginService.h"
#import "UserModel.h"
#import "AppDelegate.h"
#import "LoginImageCodeView.h"
#import <HyphenateLite/HyphenateLite.h>

@interface LoginService ()

@property (nonatomic, copy) NSString *phone;

@property (nonatomic, strong) LoginImageCodeView *codeView;

//干扰图片验证码
@property (nonatomic, copy) NSString *imageCode;
@property (nonatomic, copy) NSString *uuid;

@property (nonatomic, copy) NSString *verifyType;

@end

@implementation LoginService

- (void)sendCodeRequestWithPhone:(NSString *)phone Complete:(void (^)(void))complete TimerHandler:(nonnull void (^)(void))timerHandler {
    if (phone.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入手机号"];
        return;
    }
    if (![phone isValidatePhone]) {
        [SVProgressHUD showInfoWithStatus:@"手机号格式错误"];
        return;
    }
    self.phone = phone;
    NSMutableDictionary *params = @{@"mobileNumber": phone, @"type": @"401", @"verifyType": self.verifyType ?: @""}.mutableCopy;
    if (self.imageCode.length > 0 && self.uuid.length > 0) {
        params[@"codeBase64"] = self.imageCode;
        params[@"uuid"] = self.uuid;
    }
    [QHWHttpLoading showWithMaskTypeBlack];
    [QHWHttpManager.sharedInstance QHW_POST:kSystemSendCode parameters:params success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 200) {
            [SVProgressHUD showInfoWithStatus:@"验证码发送成功"];
            complete();
            [self configTimerWithTimerHandler:timerHandler];
            if (self.imageCode && self.codeView) {
                [self.codeView dismiss];
                self.codeView = nil;
                self.imageCode = @"";
            }
        } else if ([responseObject[@"code"] integerValue] == 101001) { // 图片验证码
            self.verifyType = @"1";
            self.uuid = responseObject[@"data"][@"uuid"];
            if (self.imageCode.length > 0) {
                self.codeView.tipLabel.hidden = NO;
            } else {
                self.codeView = [[LoginImageCodeView alloc] initWithFrame:CGRectMake((kScreenW-300)/2, 200, 300, 260)];
                [self.codeView show];
            }
            self.codeView.codeBase64 = responseObject[@"data"][@"codeBase64"];
            WEAKSELF
            self.codeView.getCodeBlock = ^{
                [weakSelf getCodeRequestWithComplete:complete];
            };
            self.codeView.submitBlock = ^(NSString * _Nonnull code) {
                weakSelf.imageCode = code;
                [weakSelf sendCodeRequestWithPhone:phone Complete:complete TimerHandler:timerHandler];
            };
        } else if ([responseObject[@"code"] integerValue] == 101004) { // 滑块验证码
            self.imageCode = self.uuid = @"";
            
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)configTimerWithTimerHandler:(nonnull void (^)(void))timerHandler {
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0.1 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(self.timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (timerHandler) {
                timerHandler();
            }
        });
    });
    dispatch_resume(self.timer);
}

- (void)getCodeRequestWithComplete:(void (^)(void))complete {
    [QHWHttpLoading showWithMaskTypeBlack];
    [QHWHttpManager.sharedInstance QHW_POST:kSystemGetCode parameters:@{@"type": @"2"} success:^(id responseObject) {
        self.codeView.codeBase64 = responseObject[@"data"][@"codeBase64"];
        self.uuid = responseObject[@"data"][@"uuid"];
        complete();
    } failure:^(NSError *error) {
        complete();
    }];
}

- (void)loginRequestWithPhone:(NSString *)phone Code:(NSString *)code {
    /*accountType 账号类型：1-手机号；2-邮箱；3-账号；4-微信登录；5-微信登录绑定手机号；6-闪验*/
    NSDictionary *parameters = @{@"account": phone,
                                 @"code": code,
                                 @"accountType": @(1)
    };
    [self loginWithParams:parameters];
}

- (void)loginRequestWithWechatParams:(NSDictionary *)params {
    /*accountType 账号类型：1-手机号；2-邮箱；3-账号；4-微信登录；5-微信登录绑定手机号；6-闪验*/
    NSDictionary *parameters = @{@"accountType":@(4),
                                 @"nickname":params[@"nickname"],
                                 @"headPath":params[@"headPath"],
                                 @"unionId":params[@"unionid"]};
    [self loginWithParams:parameters];
}

- (void)loginRequestWithSYToken:(NSString *)syToken {
    /*accountType 账号类型：1-手机号；2-邮箱；3-账号；4-微信登录；5-微信登录绑定手机号；6-闪验*/
    NSDictionary *parameters = @{@"accountType":@(6),
                                 @"syToken":syToken};
    [self loginWithParams:parameters];
}

- (void)loginWithParams:(NSDictionary *)params {
    [QHWHttpLoading showWithMaskTypeBlack];
    [QHWHttpManager.sharedInstance QHW_POST:kUserLogin parameters:params success:^(id responseObject) {
        [self loginSuccessWithResponse:responseObject];
    } failure:^(NSError *error) {
    }];
}

- (void)loginSuccessWithResponse:(NSDictionary *)responseObject {
    [SVProgressHUD showInfoWithStatus:@"登录成功"];
    [UserModel clearUser];
    UserModel *model = [UserModel yy_modelWithJSON:responseObject[@"data"]];
    [model keyArchiveUserModel];
    [model hxLogin];
    [kUserDefault setObject:model.mobileNumber forKey:kConstPhoneNumber];
    AppDelegate *delegate = (AppDelegate *)UIApplication.sharedApplication.delegate;
    delegate.tabBarVC = QHWTabBarViewController.new;
    delegate.window.rootViewController = delegate.tabBarVC;
}

@end
