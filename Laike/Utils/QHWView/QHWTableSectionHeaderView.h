//
//  QHWTableSectionHeaderView.h
//  Laike
//
//  Created by xiaobu on 2020/6/22.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QHWTableSectionHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) UIImageView *tagImgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, copy) void (^ clickMoreBtnBlock)(void);

@property (nonatomic, assign) CGFloat tagImgWidth;

@end

NS_ASSUME_NONNULL_END
