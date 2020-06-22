//
//  UIImage+Category.h
//  GoOverSeas
//
//  Created by xiaobu on 2019/1/23.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Category)
+ (UIImage *)imageWithColor:(UIColor *)color
                          size:(CGSize)size
                          text:(NSString *)text
                textAttributes:(NSDictionary *)textAttributes
                      circular:(BOOL)isCircular;
- (UIImage*)imageToTransparent;

@end

NS_ASSUME_NONNULL_END
