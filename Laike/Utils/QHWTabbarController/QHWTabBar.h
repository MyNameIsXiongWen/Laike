//
//  QHWTabBar.h
//  GoOverSeas
//
//  Created by xiaobu on 2019/7/9.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QHWTabBar : UITabBar

@property (nonatomic, strong) UIButton *centerBtn;
@property (nonatomic, strong) UIView *msgView;
@property (nonatomic, strong) UILabel *msgCountLabel;

@end

NS_ASSUME_NONNULL_END
