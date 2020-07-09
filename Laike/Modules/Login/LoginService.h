//
//  LoginService.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/15.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    LoginTypePhone,
    LoginTypeWechat,
} LoginType;

@interface LoginService : NSObject

@property (nonatomic, strong) NSDictionary *paramDict;
@property (nonatomic, assign) BOOL isThirdLogin;
@property (nonatomic, assign) LoginType loginType;
@property (nonatomic, strong) dispatch_source_t timer;

- (void)sendCodeRequestWithPhone:(NSString *)phone Complete:(void(^)(void))complete TimerHandler:(void(^)(void))timerHandler;
- (void)getCodeRequestWithComplete:(void(^)(void))complete;
- (void)loginRequestWithPhone:(NSString *)phone Code:(NSString *)code;
- (void)loginRequestWithWechatParams:(NSDictionary *)params;
- (void)loginRequestWithSYToken:(NSString *)syToken;

@end

NS_ASSUME_NONNULL_END
