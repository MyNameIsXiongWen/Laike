//  自定义导航条
//  QHWNavgationView.h
//  GoOverSeas
//
//  Created by xiaobu on 2019/7/27.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QHWNavgationView : UIView

@property (nonatomic, strong) UIButton *leftBtn;//左边按钮
@property (nonatomic, strong) UIButton *rightBtn;//右边按钮
@property (nonatomic, strong) UIButton *rightAnotherBtn;//正常右边只有一个按钮，特殊情况会有多个按钮
@property (nonatomic, strong) UIView *titleView;//titleview
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *redPointView;//红点view

@end

NS_ASSUME_NONNULL_END
