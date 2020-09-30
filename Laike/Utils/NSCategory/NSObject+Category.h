//
//  NSObject+Category.h
//  GoOverSeas
//
//  Created by xiaobu on 2019/3/13.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Category) <NSMutableCopying>

- (NSDictionary *)convertToDictionary;
//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentMethodCallerVC;
///判断当前类是否包含某个字段
- (BOOL)containsProperty:(NSString *)identifier;
/**
 交换方法，将IMP部分交换
 
 @param oldMethod 旧方法
 @param newMethod 新方法
 */
+ (void)method_exchange:(SEL)oldMethod with:(SEL)newMethod;

@end

@interface QHWUnrecognizedSelectorObject : NSObject

@property (nonatomic, weak) NSObject *objc;

@end

NS_ASSUME_NONNULL_END
