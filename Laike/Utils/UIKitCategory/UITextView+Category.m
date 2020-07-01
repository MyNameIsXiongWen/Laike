//
//  UITextView+Category.m
//  GoOverSeas
//
//  Created by xiaobu on 2019/1/18.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import "UITextView+Category.h"

@implementation UITextView (Category)

+ (UITextView * _Nonnull (^)(CGRect))tvFrame {
    return ^(CGRect tvFrame) {
        return [[UITextView alloc] initWithFrame:tvFrame];
    };
}

- (UITextView * _Nonnull (^)(NSString * _Nonnull))tvText {
    return ^(NSString *tvText) {
        self.text = tvText;
        return self;
    };
}

- (UITextView * _Nonnull (^)(NSString * _Nonnull))tvPlaceholder {
    return ^(NSString *tvPlaceholder) {
        UILabel *label = UILabel.labelFrame(CGRectMake(5, 9, self.width-10, 16)).labelText(tvPlaceholder).labelTitleColor(kColorFromHexString(@"bfbfbf")).labelNumberOfLines(0).labelFont(self.font);
        [label sizeToFit];
        [self addSubview:label];
        [self setValue:label forKey:@"_placeholderLabel"];
        return self;
    };
}

- (UITextView * _Nonnull (^)(UIFont * _Nonnull))tvFont {
    return ^(UIFont *tvFont) {
        self.font = tvFont;
        return self;
    };
}

- (UITextView * _Nonnull (^)(UIColor * _Nonnull))tvTextColor {
    return ^(UIColor *tvTextColor) {
        self.textColor = tvTextColor;
        return self;
    };
}

@end
