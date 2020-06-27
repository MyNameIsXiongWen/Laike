//
//  CommunityDetailRecommendTableViewCell.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/6/16.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RecommendCollectionViewCell;
@interface CommunityDetailRecommendTableViewCell : UITableViewCell

@property (nonatomic, strong) NSArray *dataArray;

@end

@interface RecommendCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *bkgImgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;

@end

NS_ASSUME_NONNULL_END
