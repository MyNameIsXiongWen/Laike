//
//  CRMScrollContentViewController.h
//  Laike
//
//  Created by xiaobu on 2020/6/23.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWBaseScrollContentViewController.h"
#import "FilterBtnViewCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CRMScrollContentViewController : QHWBaseScrollContentViewController

/// 客户类型 1:CRM 2:获客（咨询）
@property (nonatomic, assign) NSInteger crmType;
@property (nonatomic, strong) NSMutableArray <FilterBtnViewCellModel *>*filterDataArray;

@end

NS_ASSUME_NONNULL_END
