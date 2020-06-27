//
//  CTMediator+ViewController.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/15.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "CTMediator+ViewController.h"

NSString * const kCTMediatorTargetViewController = @"ViewController";

NSString * const kCTMediatorActionNativeActivityViewController = @"nativeActivityViewController";
NSString * const kCTMediatorActionNativeActivityDetailViewController = @"nativeActivityDetailViewController";
NSString * const kCTMediatorActionNativeMainBusinessDetailViewController = @"nativeMainBusinessDetailViewController";
NSString * const kCTMediatorActionNativeUserDetailViewController = @"nativeUserDetailViewController";
NSString * const kCTMediatorActionNativeCommunityViewController = @"nativeCommunityViewController";
NSString * const kCTMediatorActionNativeCommunityDetailViewController = @"nativeCommunityDetailViewController";

NSString * const kCTMediatorActionNativeLoginViewController = @"nativeLoginViewController";
NSString * const kCTMediatorActionNativeH5ViewController = @"nativeH5ViewController";
NSString * const kCTMediatorActionNativeCRMViewController = @"nativeCRMViewController";
NSString * const kCTMediatorActionNativeCardViewController = @"nativeCardViewController";
NSString * const kCTMediatorActionNativeQSchoolViewController = @"nativeQSchoolViewController";
NSString * const kCTMediatorActionNativeLiveViewController = @"nativeLiveViewController";
NSString * const kCTMediatorActionNativeGalleryViewController = @"nativeGalleryViewController";

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
                          @"businessId": businessId}
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
                 params:@{@"userId": userId,
                          @"userType": @(userType),
                          @"businessType": @(businessType)}
    shouldCacheTarget:NO];
}

- (void)CTMediator_viewControllerForCommunityWithType:(NSInteger)communityType {
    [self performTarget:kCTMediatorTargetViewController
                 action:kCTMediatorActionNativeCommunityViewController
                 params:@{@"communityType": @(communityType)}
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

- (void)CTMediator_viewControllerForCRM {
    [self performTarget:kCTMediatorTargetViewController
                 action:kCTMediatorActionNativeCRMViewController
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

- (void)CTMediator_viewControllerForLive {
    [self performTarget:kCTMediatorTargetViewController
                 action:kCTMediatorActionNativeLiveViewController
                 params:@{}
    shouldCacheTarget:NO];
}

- (void)CTMediator_viewControllerForGallery {
    [self performTarget:kCTMediatorTargetViewController
                 action:kCTMediatorActionNativeGalleryViewController
                 params:@{}
    shouldCacheTarget:NO];
}

@end
