//
//  LiveOrganizerViewController.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/6/11.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWBaseScrollContentViewController.h"
#import "MainBusinessDetailBottomView.h"
#import "LiveService.h"

NS_ASSUME_NONNULL_BEGIN

@interface LiveOrganizerViewController : QHWBaseScrollContentViewController

@property (nonatomic, strong, readonly) MainBusinessDetailBottomView *bottomView;

@property (nonatomic, strong) LiveService *service;

@end

NS_ASSUME_NONNULL_END
