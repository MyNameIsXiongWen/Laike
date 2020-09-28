//
//  UIImageView+Category.h
//  MANKUProject
//
//  Created by xiaobu on 2019/7/23.
//  Copyright © 2018年 MANKU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Category)

+ (UIImageView *(^)(void))ivInit;
+ (UIImageView *(^)(CGRect ivFrame))ivFrame;
- (UIImageView *(^)(UIColor *color))ivBkgColor;
- (UIImageView *(^)(UIImage *ivImage))ivImage;
- (UIImageView *(^)(UIViewContentMode ivMode))ivMode;
///最好先调用ivImage
- (UIImageView *(^)(NSString *ivImageUrl))ivImageUrl;
- (UIImageView *(^)(CGFloat ivCornerRadius))ivCornerRadius;
- (UIImageView *(^)(UIColor *tfBorderColor))ivBorderColor;
- (UIImageView *(^)(id target, SEL ivSEL))ivAction;

@end
