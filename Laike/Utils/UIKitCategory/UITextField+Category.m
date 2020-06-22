//
//  UITextField+Category.m
//  MANKUProject
//
//  Created by xiaobu on 2019/8/9.
//  Copyright © 2018年 MANKU. All rights reserved.
//

#import "UITextField+Category.h"

@implementation UITextField (Category)

+ (UITextField *(^)(CGRect))tfFrame {
    return ^(CGRect tfFrame) {
        return [[UITextField alloc] initWithFrame:tfFrame];
    };
}

- (UITextField *(^)(NSString *))tfText {
    return ^(NSString *tfText) {
        self.text = tfText;
        return self;
    };
}

- (UITextField *(^)(NSString *))tfPlaceholder {
    return ^(NSString *tfPlaceholder) {
        self.placeholder = tfPlaceholder;
        return self;
    };
}

- (UITextField *(^)(UIFont *))tfFont {
    return ^(UIFont *tfFont) {
        self.font = tfFont;
        return self;
    };
}

- (UITextField *(^)(UIColor *))tfTextColor {
    return ^(UIColor *tfTextColor) {
        self.textColor = tfTextColor;
        return self;
    };
}

- (UITextField *(^)(UIColor *))tfBorderColor {
    return ^(UIColor *tfBorderColor) {
        self.layer.borderColor = tfBorderColor.CGColor;
        self.layer.borderWidth = 0.5;
        return self;
    };
}

- (UITextField *(^)(CGFloat))tfCornerRadius {
    return ^(CGFloat tfCornerRadius) {
        self.layer.cornerRadius = tfCornerRadius;
        self.layer.masksToBounds = YES;
        return self;
    };
}

@end
