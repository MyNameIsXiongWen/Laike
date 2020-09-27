//
//  HomeBannerTableViewCell.h
//  Laike
//
//  Created by xiaobu on 2020/6/22.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QHWCycleScrollView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeBannerTableViewCell : UITableViewCell <QHWBaseCellProtocol>

@property (nonatomic, strong) QHWCycleScrollView *bannerView;

@end

NS_ASSUME_NONNULL_END
