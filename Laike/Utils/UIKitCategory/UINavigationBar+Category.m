//
//  UINavigationBar+Category.m
//  GoOverSeas
//
//  Created by xiaobu on 2019/4/15.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import "UINavigationBar+Category.h"
#import <objc/runtime.h>

@implementation UINavigationBar (Category)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self method_exchange:@selector(layoutSubviews) with:@selector(customlayoutSubviews)];
    });
}

- (void)customlayoutSubviews {
    [self customlayoutSubviews];
    @try {
//        for (UIView *subview in self.subviews) {
//            if ([NSStringFromClass(subview.class) containsString:@"_UINavigationBarContentView"]) {
//                if (![NSStringFromClass(self.getCurrentMethodCallerVC.class) isEqualToString:@"TZPhotoPickerController"]) {
//                    if (@available(iOS 13.0, *)) {
//                        UIEdgeInsets margins = subview.layoutMargins;
//                        subview.frame = CGRectMake(-margins.left, -margins.top, /*margins.left + */margins.right + subview.width, margins.top + margins.bottom + subview.height);
//                    } else {
//                        UIEdgeInsets earlyEdge = subview.layoutMargins;
//                        earlyEdge.left -= 20;
//                        subview.layoutMargins = earlyEdge;
//                    }
//                }
//            }
//        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

@end
