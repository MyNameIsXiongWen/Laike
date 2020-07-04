//
//  CRMDetailScrollContentViewController.h
//  Laike
//
//  Created by xiaobu on 2020/7/2.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWBaseScrollContentViewController.h"
#import "CRMService.h"

NS_ASSUME_NONNULL_BEGIN

@interface CRMDetailScrollContentViewController : QHWBaseScrollContentViewController

@property (nonatomic, strong) CRMService *crmService;

@end

NS_ASSUME_NONNULL_END
