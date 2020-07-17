//
//  CRMDetailViewController.h
//  Laike
//
//  Created by xiaobu on 2020/7/2.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QHWTabScrollView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CRMDetailViewController : UIViewController

@property (nonatomic, copy) NSString *customerId;

@end

@interface CRMDetailSectionHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) QHWTabScrollView *tabScrollView;

@end

@interface CRMDetailBottomView : UIView

@property (nonatomic, strong) UIButton *infoBtn;
@property (nonatomic, strong) UIButton *trackBtn;
@property (nonatomic, strong) UIButton *contactBtn;
@property (nonatomic, copy) NSString *customerId;
@property (nonatomic, copy) NSString *mobilePhone;
- (void)clickInfoBtn;

@end

NS_ASSUME_NONNULL_END
