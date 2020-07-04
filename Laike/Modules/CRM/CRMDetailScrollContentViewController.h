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

@interface CRMTrackCell : UITableViewCell

@property (nonatomic, strong) UIView *circle;
@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIView *btmLine;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

NS_ASSUME_NONNULL_END
