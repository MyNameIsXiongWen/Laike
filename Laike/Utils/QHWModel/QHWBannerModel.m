//
//  QHWBannerModel.m
//  GoOverSeas
//
//  Created by xiaobu on 2019/7/22.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "QHWBannerModel.h"
#import "CTMediator+ViewController.h"
#import "AppDelegate.h"

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
            case 102001: //产品详情
                [CTMediator.sharedInstance CTMediator_viewControllerForMainBusinessDetailWithBusinessType:self.businessType BusinessId:self.businessId];
                break;
            
            case 5: //海外头条
                [CTMediator.sharedInstance CTMediator_viewControllerForCommunityDetailWithCommunityId:self.businessId CommunityType:1];
                break;

            case 18:
            case 21:
            case 1821: //海外圈
            case 103010: //海外圈-视频
            case 103011: //海外圈-图文
                [CTMediator.sharedInstance CTMediator_viewControllerForCommunityDetailWithCommunityId:self.businessId CommunityType:2];
                break;
            
            case 24: //Q大学专业课堂
            case 27: //Q大学产品学习
                [CTMediator.sharedInstance CTMediator_viewControllerForQSchoolDetailWithSchoolId:self.businessId];
                break;

            case 17: //活动
                [CTMediator.sharedInstance CTMediator_viewControllerForActivityDetailWithActivityId:self.businessId];
                break;
            
            case 101001: //分销产品列表
            {
                AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                delegate.tabBarVC.selectedIndex = 3;
            }
                break;
                
            case 101002: //发布海外圈
                [self.getCurrentMethodCallerVC.navigationController pushViewController:NSClassFromString(@"CommunityPublishViewController").new animated:YES];
                break;
                    
            case 101003: //霸屏海报列表
                [CTMediator.sharedInstance CTMediator_viewControllerForGallery];
                break;

            case 103001: //视频
                [CTMediator.sharedInstance CTMediator_viewControllerForLiveDetailWithLiveId:self.businessId];
                break;

            default:
                break;
        }
    }
}

@end
