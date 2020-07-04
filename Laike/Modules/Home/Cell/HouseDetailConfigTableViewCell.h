//
//  HouseDetailConfigTableViewCell.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/27.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HouseDetailConfigTableViewCell : UITableViewCell

@property (nonatomic, strong) NSArray *dataArray;

@end

@interface ConfigCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *nameLabel;

@end

@interface ConfigCollectionHeaderView : UICollectionReusableView

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *nameLabel;

@end

NS_ASSUME_NONNULL_END
