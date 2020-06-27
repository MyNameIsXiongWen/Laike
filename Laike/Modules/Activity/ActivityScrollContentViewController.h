//
//  ActivityScrollContentViewController.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/6/2.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWBaseScrollContentViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ActivityScrollContentViewController : QHWBaseScrollContentViewController

///报名状态（0-不限,null 默认0；1-已报名；2-未报名）
@property (nonatomic, assign) NSInteger registerStatus;

@end

NS_ASSUME_NONNULL_END
