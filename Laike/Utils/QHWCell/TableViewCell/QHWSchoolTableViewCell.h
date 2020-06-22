//
//  QHWSchoolTableViewCell.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/28.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QHWSchoolTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *schoolImgView;
@property (nonatomic, strong) UILabel *schoolCNTitleLabel;
@property (nonatomic, strong) UILabel *schoolENTitleLabel;
@property (nonatomic, strong) UILabel *countryLabel;
@property (nonatomic, strong) UILabel *rateLabel;
@property (nonatomic, strong) UILabel *rankLabel;

@end

NS_ASSUME_NONNULL_END
