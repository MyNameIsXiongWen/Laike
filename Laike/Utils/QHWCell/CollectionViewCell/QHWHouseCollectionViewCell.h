//
//  QHWHouseCollectionViewCell.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/14.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QHWHouseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QHWHouseCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *houseImgView;
@property (nonatomic, strong) UILabel *houseTitleLabel;
@property (nonatomic, strong) UILabel *houseSubTitleLabel;
@property (nonatomic, strong) UILabel *houseMoneyLabel;
@property (nonatomic, strong) QHWHouseModel *houseModel;

@end

NS_ASSUME_NONNULL_END
