//
//  SelectCountryView.h
//  Laike
//
//  Created by xiaobu on 2020/7/3.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWPopView.h"
#import "QHWFilterModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SelectCountryView : QHWPopView

@property (nonatomic, strong) NSArray <FilterCellModel *>*dataArray;
@property (nonatomic, copy) void (^ didSelectedBlock)(FilterCellModel *cityCellModel);

@end

NS_ASSUME_NONNULL_END
