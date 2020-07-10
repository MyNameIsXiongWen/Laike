//
//  RankScrollContentViewController.h
//  Laike
//
//  Created by xiaobu on 2020/6/23.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWBaseScrollContentViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RankScrollContentViewController : QHWBaseScrollContentViewController

/// 榜单类型 1:顾问  2:公司
@property (nonatomic, assign) NSInteger rankType;

@end

@interface RankTableHeaderView : UIView

@property (nonatomic, strong) UILabel *rankKeyLabel;
@property (nonatomic, strong) UILabel *rankValueLabel;
@property (nonatomic, strong) UIImageView *avatarImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *likeLabel;
@property (nonatomic, strong) UILabel *likeNameLabel;

@end

@interface RankTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *rankImgView;
@property (nonatomic, strong) UIImageView *avatarImgView;
@property (nonatomic, strong) UILabel *rankLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *sloganLabel;
@property (nonatomic, strong) UILabel *likeLabel;
@property (nonatomic, strong) UILabel *likeNameLabel;

@end

NS_ASSUME_NONNULL_END
