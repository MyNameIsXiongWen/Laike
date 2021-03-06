//
//  CTMediator+ViewController.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/15.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "CTMediator+ViewController.h"
#import "UserModel.h"

NSString * const kCTMediatorTargetViewController = @"ViewController";

NSString * const kCTMediatorActionNativeActivityViewController = @"nativeActivityViewController";
NSString * const kCTMediatorActionNativeActivityDetailViewController = @"nativeActivityDetailViewController";
NSString * const kCTMediatorActionNativeMainBusinessDetailViewController = @"nativeMainBusinessDetailViewController";
NSString * const kCTMediatorActionNativeUserDetailViewController = @"nativeUserDetailViewController";
NSString * const kCTMediatorActionNativeCommunityContentViewController = @"nativeCommunityContentViewController";
NSString * const kCTMediatorActionNativeCommunityDetailViewController = @"nativeCommunityDetailViewController";

NSString * const kCTMediatorActionNativeLoginViewController = @"nativeLoginViewController";
NSString * const kCTMediatorActionNativeH5ViewController = @"nativeH5ViewController";
NSString * const kCTMediatorActionNativeIntervalCRMViewController = @"nativeIntervalCRMViewController";
NSString * const kCTMediatorActionNativeCardViewController = @"nativeCardViewController";
NSString * const kCTMediatorActionNativeQSchoolViewController = @"nativeQSchoolViewController";
NSString * const kCTMediatorActionNativeQSchoolDetailViewController = @"nativeQSchoolDetailViewController";
NSString * const kCTMediatorActionNativeLiveViewController = @"nativeLiveViewController";
NSString * const kCTMediatorActionNativeLiveDetailViewController = @"nativeLiveDetailViewController";
NSString * const kCTMediatorActionNativeGalleryViewController = @"nativeGalleryViewController";
NSString * const kCTMediatorActionNativeRateViewController = @"nativeRateViewController";
NSString * const kCTMediatorActionNativeAddCustomerViewController = @"nativeAddCustomerViewController";
NSString * const kCTMediatorActionNativeAddTrackViewController = @"nativeAddTrackViewController";
NSString * const kCTMediatorActionNativeCRMDetailViewController = @"nativeCRMDetailViewController";
NSString * const kCTMediatorActionNativeAdvisoryDetailViewController = @"nativeAdvisoryDetailViewController";
NSString * const kCTMediatorActionNativeBookAppointmentViewController = @"nativeBookAppointmentViewController";
NSString * const kCTMediatorActionNativeBindCompanyViewController = @"nativeBindCompanyViewController";
NSString * const kCTMediatorActionNativeCommentReplyViewController = @"nativeCommentReplyViewController";
NSString * const kCTMediatorActionNativeChatViewController = @"nativeChatViewController";
NSString * const kCTMediatorActionNativeBrandDetailViewController = @"nativeBrandDetailViewController";
NSString * const kCTMediatorActionNativeVisitorDetailViewController = @"nativeVisitorDetailViewController";

@implementation CTMediator (Login)

- (UIViewController *)CTMediator_viewControllerForLogin {
    UIViewController *vc = [self performTarget:kCTMediatorTargetViewController
                                        action:kCTMediatorActionNativeLoginViewController
                                        params:@{}
                             shouldCacheTarget:NO];
    if ([vc isKindOfClass:UIViewController.class]) {
        return vc;
    } else {
        return UIViewController.new;
    }
}

- (void)CTMediator_viewControllerForMainBusinessDetailWithBusinessType:(NSInteger)businessType BusinessId:(NSString *)businessId {
    [self performTarget:kCTMediatorTargetViewController
                 action:kCTMediatorActionNativeMainBusinessDetailViewController
                 params:@{@"businessType": @(businessType),
                          @"businessId": businessId
                 }
    shouldCacheTarget:NO];
}

- (void)CTMediator_viewControllerForActivityList {
    [self performTarget:kCTMediatorTargetViewController
                 action:kCTMediatorActionNativeActivityViewController
                 params:@{}
    shouldCacheTarget:NO];
}

- (void)CTMediator_viewControllerForActivityDetailWithActivityId:(NSString *)activityId {
    [self performTarget:kCTMediatorTargetViewController
                 action:kCTMediatorActionNativeActivityDetailViewController
                 params:@{@"activityId": activityId}
    shouldCacheTarget:NO];
}

- (void)CTMediator_viewControllerForUserDetailWithUserId:(NSString *)userId UserType:(NSInteger)userType BusinessType:(NSInteger)businessType {
    [self performTarget:kCTMediatorTargetViewController
                 action:kCTMediatorActionNativeUserDetailViewController
                 params:@{@"userId": userId ?: @"",
                          @"userType": @(userType),
                          @"businessType": @(businessType)}
    shouldCacheTarget:NO];
}

- (void)CTMediator_viewControllerForCommunity {
    [self performTarget:kCTMediatorTargetViewController
                 action:kCTMediatorActionNativeCommunityContentViewController
                 params:@{}
    shouldCacheTarget:NO];
}

- (void)CTMediator_viewControllerForCommunityDetailWithCommunityId:(NSString *)communityId CommunityType:(NSInteger)communityType {
    [self performTarget:kCTMediatorTargetViewController
                 action:kCTMediatorActionNativeCommunityDetailViewController
                 params:@{@"communityId": communityId,
                          @"communityType": @(communityType)}
    shouldCacheTarget:NO];
}

- (void)CTMediator_viewControllerForH5WithUrl:(NSString *)url TitleName:(NSString *)titleName {
    [self performTarget:kCTMediatorTargetViewController
                 action:kCTMediatorActionNativeH5ViewController
                 params:@{@"url": url,
                          @"titleName": titleName}
    shouldCacheTarget:NO];
}

- (void)CTMediator_viewControllerForIntervalCRM {
    [self performTarget:kCTMediatorTargetViewController
                 action:kCTMediatorActionNativeIntervalCRMViewController
                 params:@{}
    shouldCacheTarget:NO];
}

- (void)CTMediator_viewControllerForCard {
    [self performTarget:kCTMediatorTargetViewController
                 action:kCTMediatorActionNativeCardViewController
                 params:@{}
    shouldCacheTarget:NO];
}

- (void)CTMediator_viewControllerForQSchool {
    [self performTarget:kCTMediatorTargetViewController
                 action:kCTMediatorActionNativeQSchoolViewController
                 params:@{}
    shouldCacheTarget:NO];
}

- (void)CTMediator_viewControllerForQSchoolDetailWithSchoolId:(NSString *)schoolId {
    [self performTarget:kCTMediatorTargetViewController
                 action:kCTMediatorActionNativeQSchoolDetailViewController
                 params:@{@"schoolId": schoolId ?: @""}
    shouldCacheTarget:NO];
}

- (void)CTMediator_viewControllerForLive {
    [self performTarget:kCTMediatorTargetViewController
                 action:kCTMediatorActionNativeLiveViewController
                 params:@{}
    shouldCacheTarget:NO];
}

- (void)CTMediator_viewControllerForLiveDetailWithLiveId:(NSString *)liveId {
    [self performTarget:kCTMediatorTargetViewController
                 action:kCTMediatorActionNativeLiveDetailViewController
                 params:@{@"liveId": liveId ?: @""}
    shouldCacheTarget:NO];
}

- (void)CTMediator_viewControllerForGallery {
    [self performTarget:kCTMediatorTargetViewController
                 action:kCTMediatorActionNativeGalleryViewController
                 params:@{}
    shouldCacheTarget:NO];
}

- (void)CTMediator_viewControllerForRate {
    [self performTarget:kCTMediatorTargetViewController
                 action:kCTMediatorActionNativeRateViewController
                 params:@{}
    shouldCacheTarget:NO];
}

- (void)CTMediator_viewControllerForAddCustomerWithCustomerId:(NSString *)customerId RealName:(NSString *)realName MobilePhone:(NSString *)mobilePhone {
    if (UserModel.shareUser.bindStatus == 2) {
        [self CTMediator_viewControllerForBindCompany];
        return;
    }
    [self performTarget:kCTMediatorTargetViewController
                 action:kCTMediatorActionNativeAddCustomerViewController
                 params:@{@"customerId": customerId ?: @"",
                          @"realName": realName ?: @"",
                          @"mobilePhone": mobilePhone ?: @""}
    shouldCacheTarget:NO];
}

- (void)CTMediator_viewControllerForAddTrackWithCustomerId:(NSString *)customerId {
    [self performTarget:kCTMediatorTargetViewController
                 action:kCTMediatorActionNativeAddTrackViewController
                 params:@{@"customerId": customerId ?: @""}
    shouldCacheTarget:NO];
}

- (void)CTMediator_viewControllerForCRMDetailWithCustomerId:(NSString *)customerId {
    [self performTarget:kCTMediatorTargetViewController
                 action:kCTMediatorActionNativeCRMDetailViewController
                 params:@{@"customerId": customerId ?: @""}
    shouldCacheTarget:NO];
}

- (void)CTMediator_viewControllerForAdvisoryDetailWithCustomerId:(NSString *)customerId ClueId:(NSString *)clueId {
    [self performTarget:kCTMediatorTargetViewController
                 action:kCTMediatorActionNativeAdvisoryDetailViewController
                 params:@{@"customerId": customerId ?: @"",
                          @"clueId": clueId ?: @""
                 }
    shouldCacheTarget:NO];
}

- (void)CTMediator_viewControllerForBookAppointmentWithBusinessId:(NSString *)businessId BusinessName:(NSString *)businessName BusinessType:(NSInteger)businessType {
    if (UserModel.shareUser.bindStatus == 2) {
        [self CTMediator_viewControllerForBindCompany];
        return;
    }
    if (UserModel.shareUser.distributionStatus == 1) {
        [SVProgressHUD showInfoWithStatus:@"您公司尚未开通分销业务"];
        return;
    }
    [self performTarget:kCTMediatorTargetViewController
                 action:kCTMediatorActionNativeBookAppointmentViewController
                 params:@{@"businessId": businessId ?: @"",
                          @"businessName": businessName ?: @"",
                          @"businessType": @(businessType)}
    shouldCacheTarget:NO];
}

- (void)CTMediator_viewControllerForBindCompany {
    [self performTarget:kCTMediatorTargetViewController
                 action:kCTMediatorActionNativeBindCompanyViewController
                 params:@{}
    shouldCacheTarget:NO];
}

- (void)CTMediator_viewControllerForCommentReplyWithCommentId:(NSString *)commentId CommunityType:(NSInteger)communityType {
    [self performTarget:kCTMediatorTargetViewController
                 action:kCTMediatorActionNativeCommentReplyViewController
                 params:@{@"commentId": commentId ?: @"",
                          @"communityType": @(communityType)}
    shouldCacheTarget:NO];
}

- (void)CTMediator_viewControllerForChatWithConversationId:(NSString *)conversationId ReceiverNickName:(NSString *)receiverNickName ReceiverHeadPath:(NSString *)receiverHeadPath {
    UserModel *user = UserModel.shareUser;
    [self performTarget:kCTMediatorTargetViewController
                 action:kCTMediatorActionNativeChatViewController
                 params:@{@"conversationId": conversationId ?: user.customerData.id ?: kHXCustomerServiceId,
                          @"receiverNickName": receiverNickName ?: user.customerData.name ?: kHXCustomerServiceName,
                          @"receiverHeadPath": receiverHeadPath ?: user.customerData.headPath ?: kHXCustomerServiceHead}
    shouldCacheTarget:NO];
}

- (void)CTMediator_viewControllerForBrandDetailWithBrandId:(NSString *)brandId {
    [self performTarget:kCTMediatorTargetViewController
                 action:kCTMediatorActionNativeBrandDetailViewController
                 params:@{@"brandId": brandId ?: @""}
    shouldCacheTarget:NO];
}

- (void)CTMediator_viewControllerForVisitorDetailWithVisitorId:(NSString *)visitorId {
    [self performTarget:kCTMediatorTargetViewController
                 action:kCTMediatorActionNativeVisitorDetailViewController
                 params:@{@"visitorId": visitorId ?: @""}
    shouldCacheTarget:NO];
}

@end
