//
//  Target_TZImgPicker.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/11.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "Target_TZImgPicker.h"
#import "TZImagePickerController.h"

@interface Target_TZImgPicker () <TZImagePickerControllerDelegate>

@end

@implementation Target_TZImgPicker

- (void)Action_nativeShowTZImagePickerViewController:(NSDictionary *)params {
    NSInteger count = [params[@"maxCount"] integerValue];
    __block void (^blk)(NSArray<UIImage *> *photos) = params[@"block"];
    TZImagePickerController *imagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:count delegate:self];
    [imagePickerVC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if (blk) {
            blk(photos);
        }
    }];
    [self.getCurrentMethodCallerVC presentViewController:imagePickerVC animated:YES completion:nil];
}

@end
