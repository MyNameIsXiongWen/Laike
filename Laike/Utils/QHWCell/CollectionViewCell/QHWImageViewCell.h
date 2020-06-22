//
//  QHWImageViewCell.h 通用图片 cell
//  GoOverSeas
//
//  Created by xiaobu on 2019/7/11.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QHWImageViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UIView *centerView;
@property (nonatomic, strong) UILabel *centerLabel;
@property (nonatomic, strong) UIImageView *playImageView;//播放按钮

@end

NS_ASSUME_NONNULL_END
