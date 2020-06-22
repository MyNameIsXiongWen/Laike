//
//  QHWAlertView.h
//  GoOverSeas
//
//  Created by xiaobu on 2019/7/10.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "QHWPopView.h"

NS_ASSUME_NONNULL_BEGIN

@interface QHWAlertView : QHWPopView
@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UIView *lineView;
@property (nonatomic, strong, readonly) UIButton *cancelBtn;
@property (nonatomic, strong, readonly) UIButton *confirmBtn;
@property (nonatomic, assign, readonly) CGFloat selfHeight;
@property (nonatomic, assign) BOOL dismissAlert;

- (void)configWithTitle:(NSString *)title cancleText:(NSString *)cancleText confirmText:(NSString *)confirmText;

@property (nonatomic, copy) void (^cancelBlock)(void);
@property (nonatomic, copy) void (^confirmBlock)(void);
@property (nonatomic, strong) UIColor *cancelTextColor;
@property (nonatomic, strong) UIColor *confirmTextColor;

@end

NS_ASSUME_NONNULL_END
