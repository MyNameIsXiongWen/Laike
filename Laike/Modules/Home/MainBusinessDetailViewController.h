//
//  MainBusinessDetailViewController.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/26.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainBusinessDetailViewController : UIViewController

@property (nonatomic, assign) NSInteger businessType;
@property (nonatomic, copy) NSString *businessId;

@end

@interface MainBusinessDetailSectionHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, copy) void (^ clickMoreBtnBlock)(void);

@end

@interface MainBusinessDetailSectionFooterView : UITableViewHeaderFooterView

@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, copy) void (^ clickBtnBlock)(void);

@end

NS_ASSUME_NONNULL_END
