//
//  HomeScrollContentViewController.h
//  GoOverSeas
//
//  Created by xiaobu on 2019/9/17.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "QHWBaseScrollContentViewController.h"
#import "QHWBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeScrollContentViewController : QHWBaseScrollContentViewController

///1: 首页  2:分销
@property (nonatomic, assign) NSInteger pageType;

@end

NS_ASSUME_NONNULL_END
