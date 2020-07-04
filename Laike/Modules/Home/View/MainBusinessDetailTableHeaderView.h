//
//  MainBusinessDetailTableHeaderView.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/26.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QHWCycleScrollView.h"
#import "QHWTagView.h"
#import "QHWMainBusinessDetailBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@class DiscountView;
@interface MainBusinessDetailTableHeaderView : UIView

@property (nonatomic, strong) QHWCycleScrollView *cycleScrollView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) QHWTagView *tagView;
@property (nonatomic, strong) DiscountView *discountView;
@property (nonatomic, strong) UICollectionView *collectionView;

///1-房产；2-游学；3-移民；4-留学 102001:医疗
@property (nonatomic, assign) NSInteger businessType;
@property (nonatomic, strong) QHWMainBusinessDetailBaseModel *detailModel;

@end

@interface DiscountView : UIView

@property (nonatomic, strong) UILabel *discountLabel;
@property (nonatomic, strong) UILabel *discountNameLabel;
@property (nonatomic, strong) UIButton *getDiscountBtn;
@property (nonatomic, copy) void (^ clickBtnBlock)(void);

@end

@interface ParamInfoCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *paramKeyLabel;
@property (nonatomic, strong) UILabel *paramValueLabel;

@end

NS_ASSUME_NONNULL_END
