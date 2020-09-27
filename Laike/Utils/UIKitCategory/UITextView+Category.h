//
//  UITextView+Category.h
//  GoOverSeas
//
//  Created by xiaobu on 2019/1/18.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (Category)

+ (UITextView *(^)(void))tvInit;
+ (UITextView *(^)(CGRect tvFrame))tvFrame;
- (UITextView *(^)(NSString *tvText))tvText;
- (UITextView *(^)(UIColor *tvBkgColor))tvBkgColor;
- (UITextView *(^)(UIFont *tvFont))tvFont;
- (UITextView *(^)(UIColor *tvTextColor))tvTextColor;
///要先调用tvFont，这样tvPlaceholder才能获得font
- (UITextView *(^)(NSString *tvPlaceholder))tvPlaceholder;

@end

NS_ASSUME_NONNULL_END
