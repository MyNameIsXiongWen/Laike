//
//  CRMTrackCell.h
//  Laike
//
//  Created by xiaobu on 2020/7/4.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CRMTrackCell : UITableViewCell

@property (nonatomic, strong) UIView *circle;
@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIView *btmLine;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *arrowImgView;
@property (nonatomic, assign) BOOL showArrowImgView;

@end

NS_ASSUME_NONNULL_END
