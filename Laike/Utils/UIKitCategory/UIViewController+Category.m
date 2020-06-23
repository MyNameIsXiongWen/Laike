//
//  UIViewController+Category.m
//  ManKuIPad
//
//  Created by xiaobu on 2019/9/15.
//  Copyright © 2018年 jason. All rights reserved.
//

#import "UIViewController+Category.h"
#import <objc/runtime.h>
//#import <UMMobClick/MobClick.h>
#import "AppDelegate.h"
#import <UMAnalytics/MobClick.h>

@implementation UIViewController (Category)

- (void)QHW_viewDidLoad {
    [self QHW_viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    if (@available(iOS 11.0, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self getMainData];
}

#pragma mark ------------自定义导航条-------------
- (QHWNavgationView *)kNavigationView {
    return objc_getAssociatedObject(self, @"kNavigationView");
}

- (void)setKNavigationView:(QHWNavgationView *)kNavigationView {
    objc_setAssociatedObject(self, @"kNavigationView", kNavigationView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark ------------传参-------------
- (NSDictionary *)params {
    return objc_getAssociatedObject(self, @"Params");
}

- (void)setParams:(NSDictionary *)params {
    objc_setAssociatedObject(self, @"Params", params, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)getMainData {
    
}

#pragma mark ------------事件-------------
//左侧按钮事件
- (void)leftNavBtnAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//右侧按钮事件
- (void)rightNavBtnAction:(UIButton *)sender {
    
}
//右侧按钮事件
- (void)rightAnthorNavBtnAction:(UIButton *)sender {
    
}

/**
 在NSObject的load方法中交换方法内容。
 先走load方法再走viewdidload
 */
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self method_exchange:@selector(viewDidLoad) with:@selector(QHW_viewDidLoad)];
        [self method_exchange:@selector(viewWillAppear:)with:@selector(QHW_viewWillAppear:)];
        [self method_exchange:@selector(viewWillDisappear:)with:@selector(QHW_viewWillDisappear:)];
        [self method_exchange:@selector(viewDidDisappear:) with:@selector(QHW_viewDidDisappear:)];
    });
}

/**
 交换方法，将IMP部分交换
 
 @param oldMethod 旧方法
 @param newMethod 新方法
 */
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

/**
 重写后的viewWillAppear方法
 */
- (void)QHW_viewWillAppear:(BOOL)animated {
    [self QHW_viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

/**
 重写后的viewWillDisappear方法
 */
-(void)QHW_viewWillDisappear:(BOOL)animated {
    [self QHW_viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)QHW_viewDidDisappear:(BOOL)animated {
    [self QHW_viewDidDisappear:animated];
}

@end
