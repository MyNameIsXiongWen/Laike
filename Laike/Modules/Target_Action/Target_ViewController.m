//
//  Target_ViewController.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/15.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "Target_ViewController.h"
#import "QHWNavigationController.h"
#import "QHWNavgationView.h"
#import "LoginViewController.h"
//#import "MainBusinessDetailViewController.h"
//#import "ActivityListViewController.h"
//#import "ActivityDetailViewController.h"
//#import "UserDetailViewController.h"
//#import "CommunityDetailViewController.h"
#import "QHWH5ViewController.h"
#import "CRMViewController.h"
#import "CardViewController.h"

@implementation Target_ViewController

- (UIViewController *)Action_nativeLoginViewController:(NSDictionary *)params {
    LoginViewController *viewController = LoginViewController.new;
    QHWNavigationController *nav = [[QHWNavigationController alloc] initWithRootViewController:viewController];
    nav.navigationBar.hidden = YES;
    return nav;
}

- (void)Action_nativeMainBusinessDetailViewController:(NSDictionary *)params {
//    NSInteger businessType = [params[@"businessType"] integerValue];
//    NSString *businessId = params[@"businessId"];
//    MainBusinessDetailViewController *vc = MainBusinessDetailViewController.new;
//    vc.businessType = businessType;
//    vc.businessId = businessId;
//    [self.getCurrentMethodCallerVC.navigationController pushViewController:vc animated:YES];
}

- (void)Action_nativeActivityListViewController:(NSDictionary *)params {
//    NSString *merchantId = params[@"merchantId"];
//    ActivityListViewController *vc = ActivityListViewController.new;
//    vc.merchantId = merchantId;
//    [self.getCurrentMethodCallerVC.navigationController pushViewController:vc animated:YES];
}

- (void)Action_nativeActivityDetailViewController:(NSDictionary *)params {
//    NSString *activityId = params[@"activityId"];
//    ActivityDetailViewController *vc = ActivityDetailViewController.new;
//    vc.activityId = activityId;
//    [self.getCurrentMethodCallerVC.navigationController pushViewController:vc animated:YES];
}

- (void)Action_nativeUserDetailViewController:(NSDictionary *)params {
//    NSString *userId = params[@"userId"];
//    NSInteger userType = [params[@"userType"] integerValue];
//    NSInteger businessType = [params[@"businessType"] integerValue];
//    UserDetailViewController *vc = UserDetailViewController.new;
//    vc.userId = userId;
//    vc.userType = userType;
//    vc.businessType = businessType;
//    [self.getCurrentMethodCallerVC.navigationController pushViewController:vc animated:YES];
}

- (void)Action_nativeCommunityDetailViewController:(NSDictionary *)params {
//    NSString *communityId = params[@"communityId"];
//    NSInteger communityType = [params[@"communityType"] integerValue];
//    CommunityDetailViewController *vc = CommunityDetailViewController.new;
//    vc.communityId = communityId;
//    vc.communityType = communityType;
//    [self.getCurrentMethodCallerVC.navigationController pushViewController:vc animated:YES];
}

- (void)Action_nativeH5ViewController:(NSDictionary *)params {
    NSString *url = params[@"url"];
    NSString *titleName = params[@"titleName"];
    QHWH5ViewController *vc = QHWH5ViewController.new;
    vc.titleName = titleName;
    vc.h5Url = url;
    [self.getCurrentMethodCallerVC.navigationController pushViewController:vc animated:YES];
}

- (void)Action_nativeCRMViewController:(NSDictionary *)params {
    CRMViewController *vc = CRMViewController.new;
    [self.getCurrentMethodCallerVC.navigationController pushViewController:vc animated:YES];
}

- (void)Action_nativeCardViewController:(NSDictionary *)params {
    CardViewController *vc = CardViewController.new;
    [self.getCurrentMethodCallerVC.navigationController pushViewController:vc animated:YES];
}

@end
