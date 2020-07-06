//
//  HomeSchoolTableViewCell.h
//  Laike
//
//  Created by xiaobu on 2020/6/22.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeSchoolTableViewCell : UITableViewCell

@end

@interface HomeSchoolSubCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *bkgImgView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

NS_ASSUME_NONNULL_END
