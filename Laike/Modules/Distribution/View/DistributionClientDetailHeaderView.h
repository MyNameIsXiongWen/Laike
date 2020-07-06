//
//  DistributionClientDetailHeaderView.h
//  Laike
//
//  Created by xiaobu on 2020/7/6.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DistributionService.h"

NS_ASSUME_NONNULL_BEGIN

@interface DistributionClientDetailHeaderView : UIView

@property (nonatomic, strong) ClientModel *clientDetailModel;

@end

@interface DetailProcessView : UIView

///1审核中 2成功 3失败
@property (nonatomic, assign) NSInteger orderStatus;
@property (nonatomic, assign) NSInteger currentProcess;

@end

NS_ASSUME_NONNULL_END
