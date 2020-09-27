//
//  BrandView.h
//  Laike
//
//  Created by xiaobu on 2020/9/24.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BrandView : UIView

@property (nonatomic, strong) NSArray *dataArray;

@end

@interface BrandCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *logoImgView;

@end

NS_ASSUME_NONNULL_END
