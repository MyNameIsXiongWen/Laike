//
//  UIImage+Category.m
//  GoOverSeas
//
//  Created by xiaobu on 2019/1/23.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import "UIImage+Category.h"

@implementation UIImage (Category)
+ (UIImage *)imageWithColor:(UIColor *)color
                          size:(CGSize)size
                          text:(NSString *)text
                textAttributes:(NSDictionary *)textAttributes
                      circular:(BOOL)isCircular
{
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // circular
    if (isCircular) {
        CGPathRef path = CGPathCreateWithEllipseInRect(rect, NULL);
        CGContextAddPath(context, path);
        CGContextClip(context);
        CGPathRelease(path);
    }
    
    // color
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    
    // text
    CGSize textSize = [text sizeWithAttributes:textAttributes];
    [text drawInRect:CGRectMake((size.width - textSize.width) / 2, (size.height - textSize.height) / 2, textSize.width, textSize.height) withAttributes:textAttributes];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage*)imageToTransparent {
    // 分配内存
    const int imageWidth = self.size.width;
    const int imageHeight = self.size.height;
    size_t bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    // 创建context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
    kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), self.CGImage);
    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++) {
        if ((*pCurPtr & 0xFFFFFF00) == 0xffffff00) {
            // 此处把白色背景颜色给变为透明
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        } else {
            // 改成下面的代码，会将图片转成想要的颜色
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = 0; //0~255
            ptr[2] = 0;
            ptr[1] = 0;
        }
    }
    // 将内存转成image
    CGDataProviderRef dataProvider =CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight,8, 32, bytesPerRow, colorSpace,
    kCGImageAlphaLast |kCGBitmapByteOrder32Little, dataProvider,
    NULL, true,kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    // 释放
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}

void ProviderReleaseData (void *info, const void *data, size_t size) {
    free((void*)data);
}

@end
