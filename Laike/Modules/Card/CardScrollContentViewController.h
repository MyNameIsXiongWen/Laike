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

/// 名片类型 
@property (nonatomic, assign) NSInteger cardType;

@end

@interface VisitorTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIView *line;

@end

NS_ASSUME_NONNULL_END
