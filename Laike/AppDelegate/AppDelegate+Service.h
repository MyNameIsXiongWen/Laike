//
//  AppDelegate+Service.h
//  GoOverSeas
//
//  Created by xiaobu on 2019/7/16.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (Service)

/**
 初始化window
 */
- (void)initWindow;

/**
 设置一些tableview信息
 */
- (void)initTableView;

/**
 设置SVProgress信息
 */
- (void)initSVProgress;

/**
 初始化avoidcrash
 */
- (void)initAvoidCrash;

/**
 初始化友盟
 */
- (void)initUM;

- (void)initHXIMWithApplication:(UIApplication *)application Options:(NSDictionary *)launchOptions;

/**
 初始化微信
 */
- (void)initWX;

@end

NS_ASSUME_NONNULL_END
