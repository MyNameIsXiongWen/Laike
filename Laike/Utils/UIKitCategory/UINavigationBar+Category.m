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
+ (void)method_exchange:(SEL)oldMethod with:(SEL)newMethod{
    Class class = [self class];
    SEL originalSelector = oldMethod;
    SEL swizzledSelector = newMethod;
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL success = class_addMethod(class, originalSelector,method_getImplementation(swizzledMethod),method_getTypeEncoding(swizzledMethod));
    if (success) {
        class_replaceMethod(class, swizzledSelector,method_getImplementation(originalMethod),method_getTypeEncoding(originalMethod));
    }
    else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (void)customlayoutSubviews {
    [self customlayoutSubviews];
    @try {
        for (UIView *subview in self.subviews) {
            if ([NSStringFromClass(subview.class) containsString:@"_UINavigationBarContentView"]) {
                if (![NSStringFromClass(self.getCurrentMethodCallerVC.class) isEqualToString:@"CheckContractController"]) {
                    if (@available(iOS 13.0, *)) {
                        UIEdgeInsets margins = subview.layoutMargins;
                        subview.frame = CGRectMake(-margins.left, -margins.top, /*margins.left + */margins.right + subview.width, margins.top + margins.bottom + subview.height);
                    } else {
                        UIEdgeInsets earlyEdge = subview.layoutMargins;
                        earlyEdge.left -= 20;
                        subview.layoutMargins = earlyEdge;
                    }
                }
            }
        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

@end
