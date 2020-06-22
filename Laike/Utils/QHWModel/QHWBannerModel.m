//
//  QHWBannerModel.m
//  GoOverSeas
//
//  Created by xiaobu on 2019/7/22.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "QHWBannerModel.h"
#import "CTMediator+ViewController.h"

@implementation QHWBannerModel

- (void)setBannerTapAction {
    if (self.advertSource == 2) {
        if (self.advertUrl.length > 0) {
            [CTMediator.sharedInstance CTMediator_viewControllerForH5WithUrl:self.advertUrl TitleName:self.title];
        }
    } else if (self.advertSource == 1) {
        switch (self.businessType) {
            case 1:
            case 2:
            case 3:
            case 4:
                [CTMediator.sharedInstance CTMediator_viewControllerForMainBusinessDetailWithBusinessType:self.businessType BusinessId:self.businessId];
                break;
                
            case 5:
                [CTMediator.sharedInstance CTMediator_viewControllerForCommunityDetailWithCommunityId:self.businessId CommunityType:1];
                break;
                
            case 18:
            case 21:
                [CTMediator.sharedInstance CTMediator_viewControllerForCommunityDetailWithCommunityId:self.businessId CommunityType:2];
                break;
                
            case 14:
                [CTMediator.sharedInstance CTMediator_viewControllerForUserDetailWithUserId:self.businessId UserType:3 BusinessType:0];
                break;
            case 15:
                [CTMediator.sharedInstance CTMediator_viewControllerForUserDetailWithUserId:self.businessId UserType:2 BusinessType:0];
                break;
            case 16:
                [CTMediator.sharedInstance CTMediator_viewControllerForUserDetailWithUserId:self.businessId UserType:1 BusinessType:0];
                
            default:
                break;
        }
    }
}

@end
