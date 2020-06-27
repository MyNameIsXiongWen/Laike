//
//  Target_ViewController.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/15.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Target_ViewController : NSObject

- (UIViewController *)Action_nativeLoginViewController:(NSDictionary *)params;

- (void)Action_nativeMainBusinessDetailViewController:(NSDictionary *)params;

- (void)Action_nativeActivityViewController:(NSDictionary *)params;

- (void)Action_nativeActivityDetailViewController:(NSDictionary *)params;

- (void)Action_nativeUserDetailViewController:(NSDictionary *)params;

- (void)Action_nativeCommunityViewController:(NSDictionary *)params;
- (void)Action_nativeCommunityDetailViewController:(NSDictionary *)params;

- (void)Action_nativeH5ViewController:(NSDictionary *)params;

- (void)Action_nativeCRMViewController:(NSDictionary *)params;

- (void)Action_nativeCardViewController:(NSDictionary *)params;

- (void)Action_nativeQSchoolViewController:(NSDictionary *)params;

- (void)Action_nativeLiveViewController:(NSDictionary *)params;

- (void)Action_nativeGalleryViewController:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
