//
//  QHWHttpLoading.m
//  GoOverSeas
//
//  Created by xiaobu on 2019/7/25.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "QHWHttpLoading.h"

static NSInteger loadingCount = 0;
@interface QHWHttpLoading ()

@property (nonatomic, assign) MaskType maskType;

@end

@implementation QHWHttpLoading

+ (instancetype)sharedInstance {
    static QHWHttpLoading *loading = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loading = [[QHWHttpLoading alloc] init];
        loading.maskType = MaskTypeDefault;
    });
    return loading;
}

+ (void)show {
    [QHWHttpLoading.sharedInstance showPrivateMethod];
}

+ (void)showWithMaskTypeBlack {
    QHWHttpLoading.sharedInstance.maskType = MaskTypeBlack;
    [QHWHttpLoading show];
}

+ (void)dismiss {
    [QHWHttpLoading.sharedInstance dismissPrivateMethod];
}

- (void)showPrivateMethod {
    loadingCount++;
    if (loadingCount == 1) {
        [SVProgressHUD show];
        if (self.maskType == MaskTypeBlack) {
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        }
    }
}

- (void)dismissPrivateMethod {
    if (loadingCount > 0) {
        loadingCount--;
    }
    if (loadingCount == 0) {
        [SVProgressHUD dismiss];
        self.maskType = MaskTypeDefault;
    }
}

@end
