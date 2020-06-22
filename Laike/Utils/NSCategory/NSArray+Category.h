//
//  NSArray+Category.h
//  GoOverSeas
//
//  Created by xiaobu on 2019/10/24.
//  Copyright © 2018年 xiaobu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (Category)

/**
 *  转换成JSON串字符串（没有可读性）
 *
 *  @return JSON字符串
 */
- (NSString *)toJSONString;

/**
 *  转换成JSON串字符串（有可读性）
 *
 *  @return JSON字符串
 */
- (NSString *)toReadableJSONString;

/**
 *  转换成JSON数据
 *
 *  @return JSON数据
 */
- (NSData *)toJSONData;
- (NSMutableArray *)convertToTitleArrayWithKeyName:(NSString *)keyName;
///上传图片返回图片url数组
//- (void)uploadImageWithComplete:(nonnull void (^)(BOOL status, NSMutableArray * _Nonnull urlArray))complete;

@end

NS_ASSUME_NONNULL_END
