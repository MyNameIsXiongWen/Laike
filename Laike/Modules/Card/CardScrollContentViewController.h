//
//  CardScrollContentViewController.h
//  Laike
//
//  Created by xiaobu on 2020/6/23.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWBaseScrollContentViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardScrollContentViewController : QHWBaseScrollContentViewController

/// 名片类型  1:访客  2:获赞   3:粉丝
@property (nonatomic, assign) NSInteger cardType;

@end

@interface VisitorTableViewCell : UITableViewCell <QHWBaseCellProtocol>

@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIView *line;

@end

NS_ASSUME_NONNULL_END
