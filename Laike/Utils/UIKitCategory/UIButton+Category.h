//
//  UIButton+Category.h
//  MANKUProject
//
//  Created by xiaobu on 2019/7/23.
//  Copyright © 2018年 MANKU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Category)

+ (UIButton *(^)(void))btnInit;
+ (UIButton *(^)(CGRect btnFrame))btnFrame;
- (UIButton *(^)(NSString *btnTitle))btnTitle;
- (UIButton *(^)(NSString *btnSelectedTitle))btnSelectedTitle;
- (UIButton *(^)(UIImage *btnImage))btnImage;
- (UIButton *(^)(UIImage *btnSelectedImage))btnSelectedImage;
- (UIButton *(^)(UIFont *btnFont))btnFont;
- (UIButton *(^)(UIColor *btnTitleColor))btnTitleColor;
- (UIButton *(^)(UIColor *btnBkgColor))btnBkgColor;
- (UIButton *(^)(CGFloat btnCornerRadius))btnCornerRadius;
- (UIButton *(^)(UIColor *tfBorderColor))btnBorderColor;
- (UIButton *(^)(id target, SEL btnSEL))btnAction;

@property (nonatomic, strong) UILabel *btnBadgeLabel;
@property (nonatomic, copy) NSString *btnIdentifier;

/**
 扩展button的点击范围
 [hidePasswordBtn setHitTestEdgeInsets:UIEdgeInsetsMake(44, -44, 44, -44)];
 @param hitTestEdgeInsets 传入的范围
 */
- (void)setHitTestEdgeInsets:(UIEdgeInsets)hitTestEdgeInsets;
@property (nonatomic, assign) UIEdgeInsets hitTestEdgeInsets;

@end
