//
//  ChatFileHelper.m
//  TUIKit
//
//  Created by kennethmiao on 2018/11/1.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import "ChatFileHelper.h"
#import "EMVoiceConverter.h"
#import <HyphenateLite/HyphenateLite.h>

@implementation ChatFileHelper


+ (NSString *)genImageName:(NSString *)uuid
{
    NSString *sdkAppId = EMClient.sharedClient.options.appkey;
    NSString *identifier = EMClient.sharedClient.currentUsername;
    if(uuid == nil){
        uuid = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    }
    NSString *name = [NSString stringWithFormat:@"%@_%@_image_%@", sdkAppId, identifier, uuid];
    return name;
}

+ (NSString *)genSnapshotName:(NSString *)uuid
{
    NSString *sdkAppId = EMClient.sharedClient.options.appkey;
    NSString *identifier = EMClient.sharedClient.currentUsername;
    if(uuid == nil){
        uuid = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    }
    NSString *name = [NSString stringWithFormat:@"%@_%@_snapshot_%@", sdkAppId, identifier, uuid];
    return name;
}

+ (NSString *)genVideoName:(NSString *)uuid
{
    NSString *sdkAppId = EMClient.sharedClient.options.appkey;
    NSString *identifier = EMClient.sharedClient.currentUsername;
    if(uuid == nil){
        uuid = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    }
    NSString *name = [NSString stringWithFormat:@"%@_%@_video_%@", sdkAppId, identifier, uuid];
    return name;
}


+ (NSString *)genVoiceName:(NSString *)uuid withExtension:(NSString *)extent
{
    NSString *sdkAppId = EMClient.sharedClient.options.appkey;
    NSString *identifier = EMClient.sharedClient.currentUsername;
    if(uuid == nil){
        uuid = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    }
    NSString *name = [NSString stringWithFormat:@"%@_%@_voice_%@.%@", sdkAppId, identifier, uuid, extent];
    return name;
}

+ (NSString *)genFileName:(NSString *)uuid
{
    NSString *sdkAppId = EMClient.sharedClient.options.appkey;
    NSString *identifier = EMClient.sharedClient.currentUsername;
    if(uuid == nil){
        uuid = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    }
    NSString *name = [NSString stringWithFormat:@"%@_%@_file_%@", sdkAppId, identifier, uuid];
    return name;
}

+ (BOOL)isAmr:(NSString *)path
{
    return [EMVoiceConverter isAMRFile:path];
}

+ (BOOL)convertAmr:(NSString*)amrPath toWav:(NSString*)wavPath
{
    return [EMVoiceConverter amrToWav:amrPath wavSavePath:wavPath];
}

+ (BOOL)convertWav:(NSString*)wavPath toAmr:(NSString*)amrPath
{
    return [EMVoiceConverter wavToAmr:wavPath amrSavePath:amrPath];
}


+ (void)asyncDecodeImage:(NSString *)path complete:(TAsyncImageComplete)complete
{
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("com.qhw.asyncDecodeImage", DISPATCH_QUEUE_SERIAL);
    });
    
    dispatch_async(queue, ^{
        if(path == nil){
            return;
        }
        
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        if (image == nil) {
            return;
        }
        
        // 获取CGImage
        CGImageRef cgImage = image.CGImage;

        // alphaInfo
        CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(cgImage) & kCGBitmapAlphaInfoMask;
        BOOL hasAlpha = NO;
        if (alphaInfo == kCGImageAlphaPremultipliedLast ||
            alphaInfo == kCGImageAlphaPremultipliedFirst ||
            alphaInfo == kCGImageAlphaLast ||
            alphaInfo == kCGImageAlphaFirst) {
            hasAlpha = YES;
        }

        // bitmapInfo
        CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Host;
        bitmapInfo |= hasAlpha ? kCGImageAlphaPremultipliedFirst : kCGImageAlphaNoneSkipFirst;

        // size
        size_t width = CGImageGetWidth(cgImage);
        size_t height = CGImageGetHeight(cgImage);

        // 解码：把位图提前画到图形上下文，生成 cgImage，就完成了解码。
        // context
        CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, 0, CGColorSpaceCreateDeviceRGB(), bitmapInfo);

        // draw
        CGContextDrawImage(context, CGRectMake(0, 0, width, height), cgImage);

        // get CGImage
        cgImage = CGBitmapContextCreateImage(context);

        // 解码后的图片，包装成 UIImage 。
        // into UIImage
        UIImage *newImage = [UIImage imageWithCGImage:cgImage scale:image.scale orientation:image.imageOrientation];

        // release
        if(context) CGContextRelease(context);
        if(cgImage) CGImageRelease(cgImage);

        //callback
        if(complete){
            complete(path, newImage);
        }
    });
}

+ (NSString *)randAvatarUrl
{
    return [NSString stringWithFormat:@"https://picsum.photos/id/%d/200/200", rand()%999];
}

@end
