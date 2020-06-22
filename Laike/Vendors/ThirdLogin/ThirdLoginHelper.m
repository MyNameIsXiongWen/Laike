//
//  ThirdLoginHelper.m
//  GoOverSeas
//
//  Created by xiaobu on 2019/8/7.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "ThirdLoginHelper.h"
#import "UserModel.h"
#import "LoginService.h"

@implementation ThirdLoginHelper
+ (instancetype)sharedInstance{
    static ThirdLoginHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[ThirdLoginHelper alloc] init];
    });
    return helper;
}

//三方登录支持的平台
/*
 UMSocialPlatformType_Sina               = 0, //新浪
 UMSocialPlatformType_WechatSession      = 1, //微信聊天
 UMSocialPlatformType_WechatTimeLine     = 2,//微信朋友圈
 UMSocialPlatformType_WechatFavorite     = 3,//微信收藏
 UMSocialPlatformType_QQ                 = 4,//QQ聊天页面
 UMSocialPlatformType_Qzone              = 5,//qq空间
 */
- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType isBind:(BOOL)isBind {
    WEAKSELF
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            //failed
            NSDictionary *dict = error.userInfo;
            [SVProgressHUD showInfoWithStatus:dict[@"message"]];
        } else {
            if ([result isKindOfClass:[UMSocialUserInfoResponse class]]) {
                UMSocialUserInfoResponse *resp = result;
                if (resp != nil) {
                    [weakSelf authLoginWithType:LoginTypeWechat resp:resp isBind:isBind];
                } else {
                    [SVProgressHUD showInfoWithStatus:@"您已取消登录"];
                }
            } else {
                //failed
                NSLog(@"失败了");
            }
        }
    }];
}

//授权登录接口
- (void)authLoginWithType:(LoginType)type resp:(UMSocialUserInfoResponse *)resp isBind:(BOOL)isBind {
     NSDictionary *dict = @{@"nickname":resp.name,
                            @"headPath":resp.iconurl,
                            @"unionid":resp.unionId};
    [LoginService.new loginRequestWithWechatParams:dict];
}

@end
