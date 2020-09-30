//
//  NSObject+Category.m
//  GoOverSeas
//
//  Created by xiaobu on 2019/3/13.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import "NSObject+Category.h"

@implementation NSObject (Category)

//- (id)mutableCopyWithZone:(NSZone *)zone {
//    MKDictModel *model = [[MKDictModel allocWithZone:zone] init];
//    
//    return model;
//}

/**
 在NSObject的load方法中交换方法内容。
 先走load方法再走viewdidload
 */
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self method_exchange:@selector(forwardingTargetForSelector:) with:@selector(QHW_forwardingTargetForSelector:)];
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

//model转化为字典
- (NSDictionary *)convertToDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int count;
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    
    for (int i = 0; i < count; i++) {
        objc_property_t property = propertyList[i];
        const char *cName = property_getName(property);
        NSString *name = [NSString stringWithUTF8String:cName];
        NSObject *value = [self valueForKey:name];//valueForKey返回的数字和字符串都是对象
        
        if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
            //string , bool, int ,NSinteger
            [dic setObject:value forKey:name];
            
        } else if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]) {
            //字典或字典
            [dic setObject:[self arrayOrDicWithObject:(NSArray*)value] forKey:name];
            
        } else if (value == nil) {
            //null
            //[dic setObject:[NSNull null] forKey:name];//这行可以注释掉?????
            
        } else {
            //model
            [dic setObject:[value convertToDictionary] forKey:name];
        }
    }
    free(propertyList);
    
    return [dic copy];
}

//将可能存在model数组转化为普通数组
- (id)arrayOrDicWithObject:(id)origin {
    if ([origin isKindOfClass:[NSArray class]]) {
        //数组
        NSMutableArray *array = [NSMutableArray array];
        for (NSObject *object in origin) {
            if ([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSNumber class]]) {
                //string , bool, int ,NSinteger
                [array addObject:object];
                
            } else if ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSDictionary class]]) {
                //数组或字典
                [array addObject:[self arrayOrDicWithObject:(NSArray *)object]];
                
            } else {
                //model
                [array addObject:[object convertToDictionary]];
            }
        }
        
        return [array copy];
        
    } else if ([origin isKindOfClass:[NSDictionary class]]) {
        //字典
        NSDictionary *originDic = (NSDictionary *)origin;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        for (NSString *key in originDic.allKeys) {
            id object = [originDic objectForKey:key];
            
            if ([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSNumber class]]) {
                //string , bool, int ,NSinteger
                [dic setObject:object forKey:key];
                
            } else if ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSDictionary class]]) {
                //数组或字典
                [dic setObject:[self arrayOrDicWithObject:object] forKey:key];
                
            } else {
                //model
                [dic setObject:[object convertToDictionary] forKey:key];
            }
        }
        
        return [dic copy];
    }
    
    return [NSNull null];
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentMethodCallerVC {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    return currentVC;
}

- (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC {
    UIViewController *currentVC;
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        rootVC = [rootVC presentedViewController];
    }
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
    } else {
        // 根视图为非导航类
        currentVC = rootVC;
    }
    return currentVC;
}

- (BOOL)containsProperty:(NSString *)identifier {
    BOOL existCurrentProperty = NO;
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(self.class, &outCount);
    for (i=0; i<outCount; i++) {
        objc_property_t property = properties[i];
        const char *char_name = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_name];
        if ([propertyName isEqualToString:identifier]) {
            existCurrentProperty = YES;
            break;
        }
    }
    free(properties);
    return existCurrentProperty;
}

- (id)QHW_forwardingTargetForSelector:(SEL)aSelector {
    if (class_respondsToSelector(self.class, @selector(forwardInvocation:))) {
        IMP impIfNSObject = class_getMethodImplementation(NSObject.class, @selector(forwardInvocation:));
        IMP imp = class_getMethodImplementation(self.class, @selector(forwardInvocation:));
        if (impIfNSObject != imp) {
            return nil;
        }
    }
#ifdef DEBUG
    return nil;
#else
    QHWUnrecognizedSelectorObject *selectorObject = QHWUnrecognizedSelectorObject.new;
    selectorObject.objc = self;
    return selectorObject;
#endif
}

@end

@implementation QHWUnrecognizedSelectorObject

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    class_addMethod([self class], sel, (IMP)testMethod, "v@:");
    return YES;
}

void testMethod(id obj, SEL _cmd) {
    NSLog(@"resolveInstanceMethod");
}

+ (BOOL)resolveClassMethod:(SEL)sel {
    class_addMethod([self class], sel, (IMP)testMethod, "v@:");
    return YES;
}

@end
