//
//  DistributionTableHeaderView.h
//  Laike
//
//  Created by xiaobu on 2020/9/27.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchBkgView.h"
#import "CRMTopOperationView.h"
#import "BrandView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DistributionTableHeaderView : UIView

@property (nonatomic, strong) SearchBkgView *searchBkgView;
@property (nonatomic, strong) CRMTopOperationView *topOperationView;
@property (nonatomic, strong) BrandView *brandView;

@end

NS_ASSUME_NONNULL_END
