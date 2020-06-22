//
//  HomeViewController.h
//  Laike
//
//  Created by xiaobu on 2020/6/22.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QHWTabScrollView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeViewController : UIViewController

@end

@interface HomeCommunityTypeHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) QHWTabScrollView *tabScrollView;

@end

NS_ASSUME_NONNULL_END
