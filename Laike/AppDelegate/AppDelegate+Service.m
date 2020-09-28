//
//  AppDelegate+Service.m
//  GoOverSeas
//
//  Created by xiaobu on 2019/7/16.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "AppDelegate+Service.h"
#import <IQKeyboardManager.h>
#import <AvoidCrash.h>
#import <UMShare/UMShare.h>
#import <UMCommon/UMCommon.h>
#import <UMCommonLog/UMCommonLogHeaders.h>
#import <UMCommon/MobClick.h>
#import <UserNotifications/UserNotifications.h>
#import <WXApi.h>

#import "UserModel.h"
#import "AppGuideViewController.h"
#import "CTMediator+ViewController.h"

#import <HyphenateLite/HyphenateLite.h>

@interface AppDelegate ()

@end

@implementation AppDelegate (Service)

- (void)initWindow {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = kColorThemefff;
    IQKeyboardManager.sharedManager.enable = YES;
    IQKeyboardManager.sharedManager.shouldResignOnTouchOutside = YES;
    [kUserDefault removeObjectForKey:kConstConsultantId];

    if (![[NSUserDefaults standardUserDefaults] boolForKey:kConstFirstIn]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kConstFirstIn];
        AppGuideViewController *guideController = [[AppGuideViewController alloc] init];
        self.window.rootViewController = guideController;
    } else {
        if (kTOKEN) {
            self.tabBarVC = [[QHWTabBarViewController alloc] init];
            self.window.rootViewController = self.tabBarVC;
        } else {
            self.window.rootViewController = [CTMediator.sharedInstance CTMediator_viewControllerForLogin];
        }
    }
    [self.window makeKeyAndVisible];
}

- (void)initTableView {
    [UITableView appearance].estimatedRowHeight = 0;
    [UITableView appearance].estimatedSectionHeaderHeight = 0;
    [UITableView appearance].estimatedSectionFooterHeight = 0;
    [UITableViewCell appearance].selectionStyle = UITableViewCellSelectionStyleNone;
    UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleDefault;
    UIButton.appearance.exclusiveTouch = YES;
}

- (void)initSVProgress {
    [SVProgressHUD setMinimumDismissTimeInterval:1.5];
    [SVProgressHUD setInfoImage:kImageMake(@"")];
    [SVProgressHUD setErrorImage:kImageMake(@"")];
    [SVProgressHUD setSuccessImage:kImageMake(@"")];
    [SVProgressHUD setCornerRadius:5];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.8]];
    [SVProgressHUD setForegroundColor:UIColor.whiteColor];
}

- (void)initAvoidCrash {
#ifdef DEBUG
#else
    [AvoidCrash makeAllEffective];
    NSArray *noneSelClassStrings = @[@"NSNull",
                                     @"NSNumber",
                                     @"NSString",
                                     @"NSDictionary",
                                     @"NSArray"];
    [AvoidCrash setupNoneSelClassStringsArr:noneSelClassStrings];
#endif
}

- (void)initUM {
    //开发者需要显式的调用此函数，日志系统才能工作
//    [UMCommonLogManager setUpUMCommonLogManager];
//    [UMConfigure setLogEnabled:YES];
    [MobClick setCrashReportEnabled:YES];
    [UMConfigure initWithAppkey:kUMKey channel:@"App Store"];
    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    [self configUSharePlatforms];
}

- (void)initHXIMWithApplication:(UIApplication *)application Options:(NSDictionary *)launchOptions {
    [UNUserNotificationCenter.currentNotificationCenter requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [application registerForRemoteNotifications];
            });
        }
    }];
    [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[NSSet set]];
    
    EMOptions *options = [EMOptions optionsWithAppkey:kHXKey];
#ifdef DEBUG
    options.apnsCertName = @"manager_dev_apns";
#else
    options.apnsCertName = @"manager_dis_apns";
#endif
    options.enableConsoleLog = YES;
    options.logLevel = EMLogLevelError;
    [EMClient.sharedClient initializeSDKWithOptions:options];
    [UserModel.shareUser hxLogin];
}

- (void)initWX {
    [WXApi registerApp:kWechatAppKey universalLink:kUniversalLink];
}

- (void)configUSharePlatforms {
//对于新浪平台，redirectURL参数为新浪官方验证使用，参数内传递的URL必须和微博开放平台设置的授权回调页一致，对于QQ、微信等其他平台，redirectURL参数为webpage类型默认的URL参数，但由于webpage链接设置有单独接口，因此该参数无实际意义
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:kWechatAppKey appSecret:kWechatSecret redirectURL:nil];
    /*
     * 移除相应平台的分享，如微信收藏
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
     UMSocialGlobal.shareInstance.universalLinkDic = @{@(UMSocialPlatformType_WechatSession): kUniversalLink};
}

// 设置系统回调 - 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

//iOS9以上系统
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
    if (!result) {
        return NO;
    }
    return result;
}

//支持目前所有iOS系统
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Required - 注册 DeviceToken
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [EMClient.sharedClient bindDeviceToken:deviceToken];
    });
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification{
    if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //从通知界面直接进入应用
    }else{
        //从通知设置界面进入应用
    }
}

// iOS 10 Support应用处于前台的状态下收到推送消息会调用此方法
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary *userInfo = notification.request.content.userInfo;
    if ([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
    }
    [self handleRemoteNotificationWithUserInfo:userInfo HandleBanner:NO];
    completionHandler(UNNotificationPresentationOptionBadge);

    if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
        NSInteger number = [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:number];
        
    } else {
        completionHandler(UNNotificationPresentationOptionSound);
    }
}

// iOS 10 Support当收到推送通知后打开推送消息会调用此方法
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {

    }
    [self handleRemoteNotificationWithUserInfo:userInfo HandleBanner:YES];
    completionHandler();
}

- (void)handleRemoteNotificationWithUserInfo:(NSDictionary *)userInfo HandleBanner:(BOOL)handder {
    NSDictionary *dataInfo = userInfo[@"data"];
    if ([dataInfo isKindOfClass:NSDictionary.class]) {
       
    } else {
       
    }
}

- (void)enterBackground:(UIApplication *)application {
    [EMClient.sharedClient applicationDidEnterBackground:application];
    __block UIBackgroundTaskIdentifier bgTaskID;
    bgTaskID = [application beginBackgroundTaskWithExpirationHandler:^ {
        //不管有没有完成，结束 background_task 任务
        [application endBackgroundTask: bgTaskID];
        bgTaskID = UIBackgroundTaskInvalid;
    }];
    UserModel *user = UserModel.shareUser;
    [UIApplication sharedApplication].applicationIconBadgeNumber = user.unreadMsgCount;
}

- (void)becomeActive:(UIApplication *)application {
    [EMClient.sharedClient applicationWillEnterForeground:application];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    
}

@end
