//
//  QHWGeneralTableViewCell.h 通用最简单的cell 左label 右label 箭头
//  GoOverSeas
//
//  Created by xiaobu on 2019/7/13.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QHWGeneralTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIView *line;
- (void)updateLeftImageViewConstraint:(CGFloat)width;

@end

NS_ASSUME_NONNULL_END
