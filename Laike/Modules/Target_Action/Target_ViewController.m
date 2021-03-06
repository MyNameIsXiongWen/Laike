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
#import "MainBusinessDetailViewController.h"
#import "ActivityViewController.h"
#import "ActivityDetailViewController.h"
#import "CommunityContentViewController.h"
#import "CommunityDetailViewController.h"
#import "QHWH5ViewController.h"
#import "IntervalCRMViewController.h"
#import "CardViewController.h"
#import "QSchoolViewController.h"
#import "LiveListViewController.h"
#import "GalleryViewController.h"
#import "RateViewController.h"
#import "QSchoolDetailViewController.h"
#import "CRMAddCustomerViewController.h"
#import "CRMAddTrackViewController.h"
#import "CRMDetailViewController.h"
#import "AdvisoryDetailViewController.h"
#import "BookAppointmentViewController.h"
#import "BindCompanyViewController.h"
#import "LiveDetailViewController.h"
#import "CommentReplyListViewController.h"
#import "ChatViewController.h"
#import "BrandDetailViewController.h"
#import "VisitorDetailViewController.h"

@implementation Target_ViewController

- (UIViewController *)Action_nativeLoginViewController:(NSDictionary *)params {
    LoginViewController *viewController = LoginViewController.new;
    QHWNavigationController *nav = [[QHWNavigationController alloc] initWithRootViewController:viewController];
    nav.navigationBar.hidden = YES;
    return nav;
}

- (void)Action_nativeMainBusinessDetailViewController:(NSDictionary *)params {
    NSInteger businessType = [params[@"businessType"] integerValue];
    NSString *businessId = params[@"businessId"];
    MainBusinessDetailViewController *vc = MainBusinessDetailViewController.new;
    vc.businessType = businessType;
    vc.businessId = businessId;
    [self.getCurrentMethodCallerVC.navigationController pushViewController:vc animated:YES];
}

- (void)Action_nativeActivityViewController:(NSDictionary *)params {
    ActivityViewController *vc = ActivityViewController.new;
    [self.getCurrentMethodCallerVC.navigationController pushViewController:vc animated:YES];
}

- (void)Action_nativeActivityDetailViewController:(NSDictionary *)params {
    NSString *activityId = params[@"activityId"];
    ActivityDetailViewController *vc = ActivityDetailViewController.new;
    vc.activityId = activityId;
    [self.getCurrentMethodCallerVC.navigationController pushViewController:vc animated:YES];
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

- (void)Action_nativeCommunityContentViewController:(NSDictionary *)params {
    CommunityContentViewController *vc = CommunityContentViewController.new;
    [self.getCurrentMethodCallerVC.navigationController pushViewController:vc animated:YES];
}

- (void)Action_nativeCommunityDetailViewController:(NSDictionary *)params {
    NSString *communityId = params[@"communityId"];
    NSInteger communityType = [params[@"communityType"] integerValue];
    CommunityDetailViewController *vc = CommunityDetailViewController.new;
    vc.communityId = communityId;
    vc.communityType = communityType;
    [self.getCurrentMethodCallerVC.navigationController pushViewController:vc animated:YES];
}

- (void)Action_nativeH5ViewController:(NSDictionary *)params {
    NSString *url = params[@"url"];
    NSString *titleName = params[@"titleName"];
    QHWH5ViewController *vc = QHWH5ViewController.new;
    vc.titleName = titleName;
    vc.h5Url = url;
    [self.getCurrentMethodCallerVC.navigationController pushViewController:vc animated:YES];
}

- (void)Action_nativeIntervalCRMViewController:(NSDictionary *)params {
    IntervalCRMViewController *vc = IntervalCRMViewController.new;
    [self.getCurrentMethodCallerVC.navigationController pushViewController:vc animated:YES];
}

- (void)Action_nativeCardViewController:(NSDictionary *)params {
    CardViewController *vc = CardViewController.new;
    [self.getCurrentMethodCallerVC.navigationController pushViewController:vc animated:YES];
}

- (void)Action_nativeQSchoolViewController:(NSDictionary *)params {
    QSchoolViewController *vc = QSchoolViewController.new;
    [self.getCurrentMethodCallerVC.navigationController pushViewController:vc animated:YES];
}

- (void)Action_nativeQSchoolDetailViewController:(NSDictionary *)params {
    NSString *schoolId = params[@"schoolId"];
    QSchoolDetailViewController *vc = QSchoolDetailViewController.new;
    vc.schoolId = schoolId;
    [self.getCurrentMethodCallerVC.navigationController pushViewController:vc animated:YES];
}

- (void)Action_nativeLiveViewController:(NSDictionary *)params {
    LiveListViewController *vc = LiveListViewController.new;
    [self.getCurrentMethodCallerVC.navigationController pushViewController:vc animated:YES];
}

- (void)Action_nativeLiveDetailViewController:(NSDictionary *)params {
    NSString *liveId = params[@"liveId"];
    LiveDetailViewController *vc = LiveDetailViewController.new;
    vc.liveId = liveId;
    [self.getCurrentMethodCallerVC.navigationController pushViewController:vc animated:YES];
}

- (void)Action_nativeGalleryViewController:(NSDictionary *)params {
    GalleryViewController *vc = GalleryViewController.new;
    [self.getCurrentMethodCallerVC.navigationController pushViewController:vc animated:YES];
}

- (void)Action_nativeRateViewController:(NSDictionary *)params {
    RateViewController *vc = RateViewController.new;
    [self.getCurrentMethodCallerVC.navigationController pushViewController:vc animated:YES];
}

- (void)Action_nativeAddCustomerViewController:(NSDictionary *)params {
    NSString *customerId = params[@"customerId"];
    NSString *realName = params[@"realName"];
    NSString *mobilePhone = params[@"mobilePhone"];
    CRMAddCustomerViewController *vc = CRMAddCustomerViewController.new;
    vc.customerId = customerId;
    vc.realName = realName;
    vc.mobilePhone = mobilePhone;
    [self.getCurrentMethodCallerVC.navigationController pushViewController:vc animated:YES];
}

- (void)Action_nativeAddTrackViewController:(NSDictionary *)params {
    NSString *customerId = params[@"customerId"];
    CRMAddTrackViewController *vc = CRMAddTrackViewController.new;
    vc.customerId = customerId;
    [self.getCurrentMethodCallerVC.navigationController pushViewController:vc animated:YES];
}

- (void)Action_nativeCRMDetailViewController:(NSDictionary *)params {
    NSString *customerId = params[@"customerId"];
    CRMDetailViewController *vc = CRMDetailViewController.new;
    vc.customerId = customerId;
    [self.getCurrentMethodCallerVC.navigationController pushViewController:vc animated:YES];
}

- (void)Action_nativeAdvisoryDetailViewController:(NSDictionary *)params {
    NSString *customerId = params[@"customerId"];
    NSString *clueId = params[@"clueId"];
    AdvisoryDetailViewController *vc = AdvisoryDetailViewController.new;
    vc.customerId = customerId;
    vc.clueId = clueId;
    [self.getCurrentMethodCallerVC.navigationController pushViewController:vc animated:YES];
}

- (void)Action_nativeBookAppointmentViewController:(NSDictionary *)params {
    NSString *businessId = params[@"businessId"];
    NSString *businessName = params[@"businessName"];
    NSInteger businessType = [params[@"businessType"] integerValue];
    BookAppointmentViewController *vc = BookAppointmentViewController.new;
    vc.businessId = businessId;
    vc.businessName = businessName;
    vc.businessType = businessType;
    [self.getCurrentMethodCallerVC.navigationController pushViewController:vc animated:YES];
}

- (void)Action_nativeBindCompanyViewController:(NSDictionary *)params {
    BindCompanyViewController *vc = BindCompanyViewController.new;
    [self.getCurrentMethodCallerVC.navigationController pushViewController:vc animated:YES];
}

- (void)Action_nativeCommentReplyViewController:(NSDictionary *)params {
    NSString *commentId = params[@"commentId"];
    NSInteger communityType = [params[@"communityType"] integerValue];
    CommentReplyListViewController *vc = CommentReplyListViewController.new;
    vc.commentId = commentId;
    vc.communityType = communityType;
    [self.getCurrentMethodCallerVC.navigationController pushViewController:vc animated:YES];
}

- (void)Action_nativeChatViewController:(NSDictionary *)params {
    NSString *conversationId = params[@"conversationId"];
    NSString *receiverNickName = params[@"receiverNickName"];
    NSString *receiverHeadPath = params[@"receiverHeadPath"];
    
    ChatViewController *chatVC;
    BOOL existChatVC = NO;
    for (UIViewController *vc in self.getCurrentMethodCallerVC.navigationController.viewControllers) {
        if ([NSStringFromClass(vc.class) isEqualToString:@"ChatViewController"]) {
            chatVC = (ChatViewController *)vc;
            existChatVC = YES;
            break;
        }
    }
    if (!existChatVC) {
        chatVC = ChatViewController.new;
    }
    chatVC.conversation = [EMClient.sharedClient.chatManager getConversation:conversationId type:EMConversationTypeChat createIfNotExist:YES];
    chatVC.receiverNickName = receiverNickName;
    chatVC.receiverHeadPath = receiverHeadPath;
    if (existChatVC) {
        [self.getCurrentMethodCallerVC.navigationController popToViewController:chatVC animated:YES];
    } else {
        [self.getCurrentMethodCallerVC.navigationController pushViewController:chatVC animated:YES];
    }
}

- (void)Action_nativeBrandDetailViewController:(NSDictionary *)params {
    NSString *brandId = params[@"brandId"];
    BrandDetailViewController *vc = BrandDetailViewController.new;
    vc.brandId = brandId;
    [self.getCurrentMethodCallerVC.navigationController pushViewController:vc animated:YES];
}

- (void)Action_nativeVisitorDetailViewController:(NSDictionary *)params {
    NSString *visitorId = params[@"visitorId"];
    VisitorDetailViewController *vc = VisitorDetailViewController.new;
    vc.userId = visitorId;
    [self.getCurrentMethodCallerVC.navigationController pushViewController:vc animated:YES];
}

@end
