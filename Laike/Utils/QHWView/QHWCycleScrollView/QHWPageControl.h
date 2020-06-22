//  楼盘详情页面
//  QHWPageControl.h
//  GoOverSeas
//
//  Created by xiaobu on 2019/7/25.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QHWPageControl : UIView

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger numberOfPages;

@end

NS_ASSUME_NONNULL_END
