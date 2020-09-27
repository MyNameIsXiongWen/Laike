//
//  CRMViewController.h
//  Laike
//
//  Created by xiaobu on 2020/6/23.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QHWTabScrollView.h"
#import "SearchBkgView.h"
#import "CRMTopOperationView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CRMViewController : UIViewController

@property (nonatomic, assign) BOOL interval;

@end

@interface CRMTypeHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) QHWTabScrollView *tabScrollView;

@end

@interface CRMTableHeaderView : UIView

@property (nonatomic, strong) SearchBkgView *searchBkgView;
@property (nonatomic, strong) CRMTopOperationView *topOperationView;

@end

NS_ASSUME_NONNULL_END
