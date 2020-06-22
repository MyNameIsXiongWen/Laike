//
//  QHWHttpLoading.h
//  GoOverSeas
//
//  Created by xiaobu on 2019/7/25.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    MaskTypeDefault,//默认蒙层
    MaskTypeBlack,//黑色蒙层
} MaskType;

@interface QHWHttpLoading : NSObject

+ (instancetype)sharedInstance;

+ (void)show;
+ (void)showWithMaskTypeBlack;
+ (void)dismiss;

@end

NS_ASSUME_NONNULL_END
