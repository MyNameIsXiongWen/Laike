//
//  AppDelegate.h
//  Laike
//
//  Created by xiaobu on 2020/6/22.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QHWTabBarViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) QHWTabBarViewController *tabBarVC;
@property (nonatomic, strong) NSData *deviceToken;


@end

