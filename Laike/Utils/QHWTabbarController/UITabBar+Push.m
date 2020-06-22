//
//  UITabBar+Push.m
//  GoOverSeas
//
//  Created by xiaobu on 2019/8/28.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "UITabBar+Push.h"
#import <objc/runtime.h>

CG_INLINE BOOL
OverrideImplementation(Class targetClass, SEL targetSelector, id (^implementationBlock)(Class originClass, SEL originCMD, IMP originIMP)) {
    Method originMethod = class_getInstanceMethod(targetClass, targetSelector);
    if (!originMethod) {
        return NO;
    }
    IMP originIMP = method_getImplementation(originMethod);
    method_setImplementation(originMethod, imp_implementationWithBlock(implementationBlock(targetClass, targetSelector, originIMP)));
    return YES;
}

static CGFloat const kIPhoneXTabbarHeight = 83;

@implementation UITabBar (Push)

+ (BOOL)deviceiPhoneX {
    if (@available(iOS 11.0, *)) {
        BOOL result = NO;
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
            if (orientation == UIInterfaceOrientationUnknown || orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
                result = window.safeAreaInsets.top > 0 && window.safeAreaInsets.bottom > 0;
            } else {
                result = window.safeAreaInsets.bottom > 0 && window.safeAreaInsets.left > 0 && window.safeAreaInsets.right > 0;
            }
        }
        return result;
    }
    return NO;
}


+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        OverrideImplementation(NSClassFromString(@"UITabBar"), @selector(setFrame:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP originIMP) {
            return ^(UIView *selfObject, CGRect firstArgv) {
                if ([self deviceiPhoneX]) {
                    if (firstArgv.size.height != kIPhoneXTabbarHeight) {
                        firstArgv.size.height = kIPhoneXTabbarHeight;
                    }
                    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
                    
                    CGFloat y =window.bounds.size.height -kIPhoneXTabbarHeight;
                    if (firstArgv.origin.y != y) {
                        firstArgv.origin.y = y;
                    }
                }
                
                // call super
                void (*originSelectorIMP)(id, SEL, CGRect);
                originSelectorIMP = (void (*)(id, SEL, CGRect))originIMP;
                originSelectorIMP(selfObject, originCMD, firstArgv);
            };
        });
    });
}

@end
