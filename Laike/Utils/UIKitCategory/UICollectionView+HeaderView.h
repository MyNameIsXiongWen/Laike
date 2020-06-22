//
//  UICollectionView+HeaderView.h 给collectionview添加headerview和footerview
//  GoOverSeas
//
//  Created by xiaobu on 2019/7/18.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionView (HeaderView)

@property (nonatomic, strong) UIView *qhw_collectionHeaderView;
@property (nonatomic, strong) UIView *qhw_collectionFooterView;

@property (nonatomic, assign) CGFloat qhw_collectionHeaderViewOffset;
@property (nonatomic, assign) CGFloat qhw_collectionFooterViewOffset;

@end

NS_ASSUME_NONNULL_END
