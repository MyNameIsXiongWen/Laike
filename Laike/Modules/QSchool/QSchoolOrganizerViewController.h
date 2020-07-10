//
//  QSchoolOrganizerViewController.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/6/11.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWBaseScrollContentViewController.h"
#import "MainBusinessDetailBottomView.h"
#import "QSchoolService.h"

NS_ASSUME_NONNULL_BEGIN

@interface QSchoolOrganizerViewController : QHWBaseScrollContentViewController

@property (nonatomic, strong, readonly) MainBusinessDetailBottomView *bottomView;

@property (nonatomic, strong) QSchoolService *service;

@end

NS_ASSUME_NONNULL_END
