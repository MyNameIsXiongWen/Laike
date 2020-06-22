//
//  QHWConsultantCollectionViewCell.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/14.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWShadowCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface QHWConsultantCollectionViewCell : QHWShadowCollectionViewCell

@property (nonatomic, strong) UIImageView *consultantImgView;
@property (nonatomic, strong) UIImageView *tagImgView;
@property (nonatomic, strong) UILabel *consultantNameLabel;
@property (nonatomic, strong) UILabel *consultantTitleLabel;
@property (nonatomic, strong) UILabel *consultantTagLabel;

@end

NS_ASSUME_NONNULL_END
