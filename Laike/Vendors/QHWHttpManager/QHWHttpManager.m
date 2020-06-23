//
//  QHWHttpManager.m
//  GoOverSeas
//
//  Created by xiaobu on 2019/7/15.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import "QHWHttpManager.h"
#import "UserModel.h"

@implementation QHWHttpManager

+ (instancetype)sharedInstance {
    static QHWHttpManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [QHWHttpManager manager];
        manager.networkStatus = AFNetworkReachabilityStatusReachableViaWiFi;
        manager.requestSerializer = AFJSONRequestSerializer.serializer;
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/javascript",@"application/json",@"text/json", @"text/html",@"text/plain",@"application/x-www-form-urlencoded", nil];
        manager.requestSerializer.timeoutInterval = 15;

        NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        currentVersion = [currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
        [manager.requestSerializer setValue:@"6" forHTTPHeaderField:@"pass"];
        [manager.requestSerializer setValue:currentVersion forHTTPHeaderField:@"version"];
        [manager.requestSerializer setValue:manager.getDeviceId forHTTPHeaderField:@"deviceId"];
        [manager.requestSerializer setValue:@"AppStore" forHTTPHeaderField:@"channel"];
        
        [manager monitorInternet];
    });
    return manager;
}

- (void)monitorInternet {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    WEAKSELF
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (weakSelf.networkStatus == status) {
            return;
        }
        weakSelf.networkStatus = status;
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                [SVProgressHUD showInfoWithStatus:@"网络断开链接，请检查网络"];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                break;
        }
    }];
}

- (void)configSuccessResponseResult:(id  _Nullable)responseObject url:(NSString *)url success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    [QHWHttpLoading dismiss];
    if (([[responseObject allKeys] containsObject:@"code"]
        && [responseObject[@"code"] integerValue] == 200) || ([url isEqualToString:kSystemSendCode] && [responseObject[@"code"] integerValue] != 201)) {
        if (success) {
            success(responseObject);
        }
    } else {
        if ([responseObject[@"code"] integerValue] == 400) {
            [UserModel logout];
        } else {
            if (![NSString isBlankString:responseObject[@"msg"]]) {
                [SVProgressHUD showInfoWithStatus:responseObject[@"msg"]];
            } else {
                [SVProgressHUD showInfoWithStatus:@"请求失败"];
            }
        }
        if (failure) {
            failure(responseObject);
        }
    }
}

- (void)configFailResult:(NSError * _Nonnull)error {
    [QHWHttpLoading dismiss];
    if (error.code == 1001) {
        [SVProgressHUD showInfoWithStatus:@"请求超时"];
    } else {
        if (self.networkStatus == AFNetworkReachabilityStatusNotReachable) {
            [SVProgressHUD showInfoWithStatus:@"当前未连接到网络，请检查网络"];
        } else {
            [SVProgressHUD showInfoWithStatus:@"请求失败"];
        }
    }
}

#pragma mark -- GET请求 --
- (void)QHW_GET:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(id))success
    failure:(void (^)(NSError *))failure {
    NSLog(@"\n%@==========%@",URLString,parameters);
    [self configRequestHttpHeader];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kMainUrl,URLString];
    if ([URLString containsString:@"http"]) {
        urlStr = URLString;
    }
    [self GET:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self configSuccessResponseResult:responseObject url:nil success:success failure:failure];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self configFailResult:error];
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark -- POST请求 --
- (void)QHW_POST:(NSString *)URLString
  parameters:(id)parameters
     success:(void (^)(id))success
     failure:(void (^)(NSError *))failure {
    NSLog(@"\n%@==========%@",URLString,parameters);
    [self configRequestHttpHeader];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kMainUrl,URLString];
    if ([URLString containsString:@"http"]) {
        urlStr = URLString;
    }
    [self POST:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSDictionary *dic = response.allHeaderFields;
        if ([dic.allKeys containsObject:@"token"]) {
            [kUserDefault setValue:dic[@"token"] forKey:kConstToken];
        }
        [self configSuccessResponseResult:responseObject url:URLString success:success failure:failure];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self configFailResult:error];
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark ------------设置请求头-------------
- (void)configRequestHttpHeader {
    [self.requestSerializer setValue:kTOKEN ?: @"" forHTTPHeaderField:@"token"];
}

- (NSString *)getDeviceId {
    NSString *deviceid = [kUserDefault objectForKey:kConstUUID];
    if (deviceid.length == 0) {
        deviceid = [[NSUUID UUID] UUIDString];
        deviceid = [deviceid stringByReplacingOccurrencesOfString:@"-" withString:@""];
        [kUserDefault setObject:deviceid forKey:kConstUUID];
    }
    return deviceid;
}

@end
