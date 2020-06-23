//
//  MainBusinessFilterBtnView.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/19.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterBtnViewCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainBusinessFilterBtnView : UIView

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, copy) void (^ didSelectItemBlock)(FilterBtnViewCellModel *model);

@end

@interface FilterCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *imgView;

@end

NS_ASSUME_NONNULL_END
