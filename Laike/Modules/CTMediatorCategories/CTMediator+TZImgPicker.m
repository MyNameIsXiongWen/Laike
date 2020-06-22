//
//  CTMediator+TZImgPicker.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/11.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "CTMediator+TZImgPicker.h"

NSString * const kCTMediatorTargetTZImgPicker = @"TZImgPicker";

NSString * const kCTMediatorActionNativeShowTZImagePickerViewController = @"nativeShowTZImagePickerViewController";

@implementation CTMediator (TZImgPicker)

- (void)CTMediator_showTZImagePickerWithMaxCount:(NSInteger)maxCount ResultBlk:(void (^)(NSArray<UIImage *> * _Nonnull))blk {
    [self performTarget:kCTMediatorTargetTZImgPicker
                 action:kCTMediatorActionNativeShowTZImagePickerViewController
                 params:@{@"maxCount": @(maxCount),
                          @"block": blk}
      shouldCacheTarget:NO];
}

@end
