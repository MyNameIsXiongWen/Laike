//
//  QHWActivityTableViewCell.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/29.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QHWActivityModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QHWActivityTableViewCell : UITableViewCell <QHWBaseCellProtocol>

@property (nonatomic, strong) UIImageView *coverImgView;
@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) QHWActivityModel *activityModel;

@end

NS_ASSUME_NONNULL_END
