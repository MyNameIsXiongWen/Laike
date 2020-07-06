//
//  HomeIconTableViewCell.h
//  Laike
//
//  Created by xiaobu on 2020/6/22.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeIconTableViewCell : UITableViewCell

@property (nonatomic, strong, readonly) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *btnArray;

@end

@interface BtnViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *btnImgView;
@property (nonatomic, strong) UILabel *btnTitleLabel;

@end

NS_ASSUME_NONNULL_END
