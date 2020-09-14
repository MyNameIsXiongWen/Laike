//
//  DistributionScrollContentViewController.h
//  Laike
//
//  Created by xiaobu on 2020/9/14.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWBaseScrollContentViewController.h"
#import "MainBusinessFilterBtnView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DistributionScrollContentViewController : QHWBaseScrollContentViewController

///业务类型 /*1-房产；2-游学；3-移民；4-留学；102001-医疗*/
@property (nonatomic, assign) NSInteger businessType;

@end

@interface MainBusinessTypeHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) MainBusinessFilterBtnView *filterBtnView;

@end

NS_ASSUME_NONNULL_END
