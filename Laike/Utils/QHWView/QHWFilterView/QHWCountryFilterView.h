//
//  QHWCountryFilterView.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/19.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWPopView.h"
#import "QHWFilterModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QHWCountryFilterView : QHWPopView

///是否是医疗
@property (nonatomic, assign) BOOL isTreatment;
@property (nonatomic, strong) NSArray <FilterCellModel *>*dataArray;
@property (nonatomic, copy) void (^ didSelectedBlock)(FilterCellModel *countryCellModel, FilterCellModel *cityCellModel);

@end

NS_ASSUME_NONNULL_END
