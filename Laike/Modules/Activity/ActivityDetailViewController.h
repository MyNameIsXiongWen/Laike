//
//  ActivityDetailViewController.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/30.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ActivityDetailViewController : UIViewController

@property (nonatomic, copy) NSString *activityId;

@end

@interface ActivityDetailSectionHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) UILabel *titleLabel;

@end

NS_ASSUME_NONNULL_END
