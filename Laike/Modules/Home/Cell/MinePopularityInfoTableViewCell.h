//
//  MinePopularityInfoTableViewCell.h
//  Laike
//
//  Created by xiaobu on 2020/6/22.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWShadowTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MinePopularityInfoTableViewCell : QHWShadowTableViewCell 

@end

@interface HomePopularitySubCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *consultantImgView;
@property (nonatomic, strong) UILabel *consultantNameLabel;
@property (nonatomic, strong) UILabel *consultantCountLabel;
@property (nonatomic, copy) void (^ clickConsultBlock)(void);

@end

NS_ASSUME_NONNULL_END
