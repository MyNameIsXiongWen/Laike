//
//  DistributionSearchViewController.h
//  Laike
//
//  Created by xiaobu on 2020/9/16.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DistributionSearchViewController : UIViewController

@end

@interface SearchHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, copy) void (^ clickDeleteBlock)(void);

@end

@interface SearchContentCell : UITableViewCell

@property (nonatomic, strong) UIView *bkgView;
@property (nonatomic, strong) UILabel *contentLabel;
- (void)updateContentLabelConstraintsWidth:(CGFloat)width;

@end

NS_ASSUME_NONNULL_END
