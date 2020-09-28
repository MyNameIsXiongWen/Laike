//
//  UILabel+Category.m
//  MANKUProject
//
//  Created by xiaobu on 2019/7/23.
//  Copyright © 2018年 MANKU. All rights reserved.
//

#import "UILabel+Category.h"

@implementation UILabel (Category)

//- (instancetype)initWithFrame:(CGRect)frame {
//    if (self == [super initWithFrame:frame]) {
//
//    }
//    return self;
//}

+ (UILabel *(^)(void))labelInit {
    return ^(void) {
        return [[UILabel alloc] init];
    };
}

+ (UILabel *(^)(CGRect))labelFrame {
    return ^(CGRect labelFrame) {
        return [[UILabel alloc] initWithFrame:labelFrame];
    };
}

- (UILabel *(^)(NSString *))labelText {
    return ^(NSString *labelText) {
        self.text = labelText;
        return self;
    };
}

- (UILabel *(^)(UIColor *))labelTitleColor {
    return ^(UIColor *labelTitleColor) {
        self.textColor = labelTitleColor;
        return self;
    };
}

- (UILabel *(^)(UIColor *))labelBkgColor {
    return ^(UIColor *labelBkgColor) {
        self.backgroundColor = labelBkgColor;
        return self;
    };
}

- (UILabel *(^)(NSInteger))labelNumberOfLines {
    return ^(NSInteger number) {
        self.numberOfLines = number;
        return self;
    };
}

- (UILabel *(^)(UIFont *))labelFont {
    return ^(UIFont *labelFont) {
        self.font = labelFont;
        return self;
    };
}

- (UILabel *(^)(NSTextAlignment ))labelTextAlignment {
    return ^(NSTextAlignment alignment) {
        self.textAlignment = alignment;
        return self;
    };
}

- (UILabel *(^)(BOOL))labelCopyEnable {
    return ^(BOOL labelCopyEnable) {
        self.userInteractionEnabled = labelCopyEnable;
        if (labelCopyEnable) {
            UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGes:)];
            [self addGestureRecognizer:longpress];
        }
        return self;
    };
}

- (UILabel *(^)(UIColor *))labelBorderColor {
    return ^(UIColor *labelBorderColor) {
        self.layer.borderColor = labelBorderColor.CGColor;
        self.layer.borderWidth = 0.5;
        return self;
    };
}

- (UILabel *(^)(CGFloat))labelCornerRadius {
    return ^(CGFloat labelCornerRadius) {
        self.layer.cornerRadius = labelCornerRadius;
        self.layer.masksToBounds = YES;
        return self;
    };
}

- (UILabel *(^)(id, SEL))labelAction {
    return ^(id target, SEL labelSEL) {
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:target action:labelSEL]];
        return self;
    };
}

- (void)longPressGes:(UILongPressGestureRecognizer *)recognizer {
    UIMenuController *menu = [UIMenuController sharedMenuController];
    if (!menu.isMenuVisible) {
        if ([self becomeFirstResponder]) {
            UIMenuItem * item1 = [[UIMenuItem alloc]initWithTitle:@"复制" action:@selector(copyText:)];
            menu.menuItems = @[item1];
            [menu setTargetRect:self.bounds inView:self];
            [menu setMenuVisible:YES animated:YES];
        }
    }
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(copyText:)) {
        return YES;
    }
    return NO;
}

- (void)copyText:(UIMenuController *)menu {
    if (!self.text) return;
    UIPasteboard.generalPasteboard.string = self.text;
    [SVProgressHUD showInfoWithStatus:@"已复制到粘贴板"];
}

+ (CGFloat)calculateHeightWithString:(NSString*)string lineSpace:(NSInteger)lineSpace paragraphSpace:(NSInteger)paragraphSpace font:(UIFont*)font size:(CGSize)size label:(UILabel*)label{
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"];
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)};
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithData:data options:options documentAttributes:nil error:nil];
    NSMutableParagraphStyle *para = [[NSMutableParagraphStyle alloc] init];
    para.lineSpacing = lineSpace;
    para.paragraphSpacing = paragraphSpace;
    [attStr addAttributes:@{NSParagraphStyleAttributeName: para, NSFontAttributeName: font} range:NSMakeRange(0, attStr.length)];
    label.attributedText = attStr;
    if (string.length == 0) {
        return 0;
    }
    CGSize resultSize = [attStr boundingRectWithSize:CGSizeMake(kScreenW-30, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    return MAX(25, resultSize.height);
}

@end
