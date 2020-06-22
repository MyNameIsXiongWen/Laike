//
//  QHWBrokerCollectionViewCell.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/14.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QHWBrokerCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *brokerImgView;
@property (nonatomic, strong) UILabel *brokerTitleLabel;
@property (nonatomic, strong) UILabel *brokerSubTitleLabel;
@property (nonatomic, strong) UILabel *brokerTagLabel;

@end

NS_ASSUME_NONNULL_END
