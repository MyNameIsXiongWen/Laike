//
//  QSchoolScrollContentViewController.h
//  Laike
//
//  Created by xiaobu on 2020/6/27.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWBaseScrollContentViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface QSchoolScrollContentViewController : QHWBaseScrollContentViewController

@property (nonatomic, assign) NSInteger schoolType;

@end

@interface QSchoolTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *bkgImgView;
@property (nonatomic, strong) UIImageView *playImageView;//播放按钮
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *countLabel;

@end

NS_ASSUME_NONNULL_END
