//
//  ThirdLoginHelper.h
//  GoOverSeas
//
//  Created by xiaobu on 2019/8/7.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMShare/UMShare.h>

NS_ASSUME_NONNULL_BEGIN

@interface ThirdLoginHelper : NSObject

+ (instancetype)sharedInstance;

/**
 第三方登录

 @param platformType qq/wechat/sina
 @param isBind 是否是绑定第三方账号 
 */
- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType isBind:(BOOL)isBind;
@end

NS_ASSUME_NONNULL_END
