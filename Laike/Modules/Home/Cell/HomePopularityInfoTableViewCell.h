//
//  HomePopularityInfoTableViewCell.h
//  Laike
//
//  Created by xiaobu on 2020/6/22.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomePopularityInfoTableViewCell : UITableViewCell

@end

@interface HomePopularitySubCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *consultantImgView;
@property (nonatomic, strong) UILabel *consultantNameLabel;
@property (nonatomic, strong) UILabel *consultantCountLabel;
@property (nonatomic, copy) void (^ clickConsultBlock)(void);

@end

NS_ASSUME_NONNULL_END
