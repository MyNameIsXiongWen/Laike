//
//  UIViewController+Category.h
//  ManKuIPad
//
//  Created by xiaobu on 2019/9/15.
//  Copyright © 2018年 jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QHWNavgationView.h"

@interface UIViewController (Category)

//导航栏
@property (nonatomic, strong) QHWNavgationView *kNavigationView;

//左侧按钮事件
- (void)leftNavBtnAction:(UIButton *)sender;
//右侧第一个按钮事件
- (void)rightNavBtnAction:(UIButton *)sender;
//右侧第二个按钮事件
- (void)rightAnthorNavBtnAction:(UIButton *)sender;

///vc传递参数
@property (nonatomic, strong) NSDictionary *params;
- (void)getMainData;

@end
