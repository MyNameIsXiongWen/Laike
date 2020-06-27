//
//  ActivityListViewController.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/6/12.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QHWCycleScrollView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ActivityListViewController : UIViewController

@end

@interface ActivityHeaderView : UIView

@property (nonatomic, strong) QHWCycleScrollView *bannerView;

@end

NS_ASSUME_NONNULL_END
