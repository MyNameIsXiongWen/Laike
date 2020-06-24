//
//  CRMScrollContentViewController.h
//  Laike
//
//  Created by xiaobu on 2020/6/23.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWBaseScrollContentViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CRMScrollContentViewController : QHWBaseScrollContentViewController

/// 客户类型 
@property (nonatomic, assign) NSInteger crmType;
@property (nonatomic, strong) NSDictionary *conditionDic;

@end

NS_ASSUME_NONNULL_END
