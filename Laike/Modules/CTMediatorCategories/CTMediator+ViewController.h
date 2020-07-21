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

- (void)CTMediator_viewControllerForActivityList;

- (void)CTMediator_viewControllerForActivityDetailWithActivityId:(NSString *)activityId;

- (void)CTMediator_viewControllerForMainBusinessDetailWithBusinessType:(NSInteger)businessType BusinessId:(NSString *)businessId IsDistribution:(BOOL)isDistribution;

- (void)CTMediator_viewControllerForUserDetailWithUserId:(NSString *)userId UserType:(NSInteger)userType BusinessType:(NSInteger)businessType;

- (void)CTMediator_viewControllerForCommunity;
- (void)CTMediator_viewControllerForCommunityDetailWithCommunityId:(NSString *)communityId CommunityType:(NSInteger)communityType;

- (void)CTMediator_viewControllerForH5WithUrl:(NSString *)url TitleName:(NSString *)titleName;

- (void)CTMediator_viewControllerForIntervalCRM;

- (void)CTMediator_viewControllerForCard;

- (void)CTMediator_viewControllerForQSchool;

- (void)CTMediator_viewControllerForQSchoolDetailWithSchoolId:(NSString *)schoolId;

- (void)CTMediator_viewControllerForLive;

- (void)CTMediator_viewControllerForGallery;

- (void)CTMediator_viewControllerForRate;

- (void)CTMediator_viewControllerForAddCustomerWithCustomerId:(NSString *)customerId RealName:(NSString *)realName MobilePhone:(NSString *)mobilePhone;

- (void)CTMediator_viewControllerForAddTrackWithCustomerId:(NSString *)customerId;

- (void)CTMediator_viewControllerForCRMDetailWithCustomerId:(NSString *)customerId;

- (void)CTMediator_viewControllerForAdvisoryDetailWithCustomerId:(NSString *)customerId;

- (void)CTMediator_viewControllerForBookAppointmentWithBusinessId:(NSString *)businessId BusinessName:(NSString *)businessName BusinessType:(NSInteger)businessType;

- (void)CTMediator_viewControllerForBindCompany;

@end

NS_ASSUME_NONNULL_END
