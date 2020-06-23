//
//  CTMediator+ViewController.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/15.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "CTMediator.h"

NS_ASSUME_NONNULL_BEGIN

@interface CTMediator (ViewController)

- (UIViewController *)CTMediator_viewControllerForLogin;

- (void)CTMediator_viewControllerForActivityListWithMerchantId:(NSString *)merchantId;

- (void)CTMediator_viewControllerForActivityDetailWithActivityId:(NSString *)activityId;

- (void)CTMediator_viewControllerForMainBusinessDetailWithBusinessType:(NSInteger)businessType BusinessId:(NSString *)businessId;

- (void)CTMediator_viewControllerForUserDetailWithUserId:(NSString *)userId UserType:(NSInteger)userType BusinessType:(NSInteger)businessType;

- (void)CTMediator_viewControllerForCommunityDetailWithCommunityId:(NSString *)communityId CommunityType:(NSInteger)communityType;

- (void)CTMediator_viewControllerForH5WithUrl:(NSString *)url TitleName:(NSString *)titleName;

- (void)CTMediator_viewControllerForCRM;

- (void)CTMediator_viewControllerForCard;

@end

NS_ASSUME_NONNULL_END
