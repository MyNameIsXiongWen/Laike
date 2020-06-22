//
//  UserDataView.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/29.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserDataView : UIView

@property (nonatomic, strong) UIColor *countColor;
@property (nonatomic, strong) UIColor *nameColor;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, copy) void (^ didSelectedItemBlock)(NSInteger index);

@end

@interface UserDataCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UILabel *nameLabel;

@end

NS_ASSUME_NONNULL_END
