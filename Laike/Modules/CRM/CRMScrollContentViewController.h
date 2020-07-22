//
//  CRMScrollContentViewController.h
//  Laike
//
//  Created by xiaobu on 2020/6/23.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWBaseScrollContentViewController.h"
#import "FilterBtnViewCellModel.h"
#import <CallKit/CallKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CRMScrollContentViewController : QHWBaseScrollContentViewController <CXCallObserverDelegate>

/// 客户类型 1:客户  2:获客（咨询）
@property (nonatomic, assign) NSInteger crmType;
@property (nonatomic, strong) NSMutableArray <FilterBtnViewCellModel *>*filterDataArray;

@property (nonatomic, assign) BOOL interval;
@property (nonatomic, strong, nullable) CXCallObserver *callObserve;

@end

NS_ASSUME_NONNULL_END
