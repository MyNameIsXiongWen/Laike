//
//  QHWHttpManager.h
//  GoOverSeas
//
//  Created by xiaobu on 2019/7/15.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface QHWHttpManager : AFHTTPSessionManager

/**
 单例
 
 @return AFHTTPSessionManager
 */
+ (instancetype)sharedInstance;
@property (nonatomic, assign) AFNetworkReachabilityStatus networkStatus;

/**
 *  发送get请求
 *
 *  @param URLString  请求的网址字符串
 *  @param parameters 请求的参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
- (void)QHW_GET:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(id responseObject))success
    failure:(void (^)(NSError *error))failure;

/**
 *  发送post请求
 *
 *  @param URLString  请求的网址字符串
 *  @param parameters 请求的参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
- (void)QHW_POST:(NSString *)URLString
  parameters:(id)parameters
     success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure;

@end
