//
//  Target_TZImgPicker.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/11.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "Target_TZImgPicker.h"
#import "TZImagePickerController.h"
#import "QHWPermissionManager.h"

@interface Target_TZImgPicker ()

@end

@implementation Target_TZImgPicker

- (void)Action_nativeOnlyPhotoShowTZImagePickerViewController:(NSDictionary *)params {
    [QHWPermissionManager openAlbumService:^(BOOL isOpen) {
        if (isOpen) {
            NSInteger count = [params[@"maxCount"] integerValue];
            __block void (^blk)(NSArray<UIImage *> *photos) = params[@"block"];
            TZImagePickerController *imagePickerVC = [[TZImagePickerController alloc] init];
            imagePickerVC.maxImagesCount = count;
            imagePickerVC.allowPickingVideo = NO;
            imagePickerVC.allowPickingGif = NO;
            [imagePickerVC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                if (blk) {
                    blk(photos);
                }
            }];
            imagePickerVC.modalPresentationStyle = UIModalPresentationFullScreen;
            [self.getCurrentMethodCallerVC presentViewController:imagePickerVC animated:YES completion:nil];
        }
    }];
}

- (void)Action_nativeOnlyVideoShowTZImagePickerViewController:(NSDictionary *)params {
    [QHWPermissionManager openAlbumService:^(BOOL isOpen) {
        if (isOpen) {
            TZImagePickerController *imagePickerVC = [[TZImagePickerController alloc] init];
            imagePickerVC.preferredLanguage = @"zh-Hans";
            imagePickerVC.iconThemeColor = kColorTheme21a8ff;
            imagePickerVC.showPhotoCannotSelectLayer = YES;
            imagePickerVC.showSelectedIndex = YES;
            imagePickerVC.allowPickingOriginalPhoto = NO;
            imagePickerVC.allowPickingGif = NO;
            imagePickerVC.allowPickingMultipleVideo = NO;
            imagePickerVC.allowPickingImage = NO;
            __block void (^blk)(NSURL *videoUrl, UIImage * _Nullable coverImage) = params[@"block"];
            [imagePickerVC setDidFinishPickingVideoHandle:^(UIImage *coverImage, PHAsset *asset) {
                [TZImageManager.manager getVideoWithAsset:asset completion:^(AVPlayerItem *playerItem, NSDictionary *info) {
                    AVURLAsset *urlAsset = (AVURLAsset *)playerItem.asset;
                    if (blk) {
                        blk(urlAsset.URL, coverImage);
                    }
                }];
            }];
            imagePickerVC.modalPresentationStyle = UIModalPresentationFullScreen;
            [self.getCurrentMethodCallerVC presentViewController:imagePickerVC animated:YES completion:nil];
        }
    }];
}

- (void)Action_nativeShowTZImagePickerViewController:(NSDictionary *)params {
    [QHWPermissionManager openAlbumService:^(BOOL isOpen) {
        if (isOpen) {
            NSInteger count = [params[@"maxCount"] integerValue];
            TZImagePickerController *imagePickerVC = [[TZImagePickerController alloc] init];
            imagePickerVC.maxImagesCount = count;
            imagePickerVC.preferredLanguage = @"zh-Hans";
            imagePickerVC.iconThemeColor = kColorTheme21a8ff;
            imagePickerVC.showPhotoCannotSelectLayer = YES;
            imagePickerVC.showSelectedIndex = YES;
            imagePickerVC.allowPickingOriginalPhoto = NO;
            imagePickerVC.allowPickingGif = NO;
            imagePickerVC.allowPickingMultipleVideo = NO;
            __block void (^blk)(id selectedObject, UIImage * _Nullable coverImage) = params[@"block"];
            [imagePickerVC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                if (blk) {
                    blk(photos, nil);
                }
            }];
            [imagePickerVC setDidFinishPickingVideoHandle:^(UIImage *coverImage, PHAsset *asset) {
                [TZImageManager.manager getVideoWithAsset:asset completion:^(AVPlayerItem *playerItem, NSDictionary *info) {
                    AVURLAsset *urlAsset = (AVURLAsset *)playerItem.asset;
                    if (blk) {
                        blk(urlAsset.URL, coverImage);
                    }
                }];
            }];
            imagePickerVC.modalPresentationStyle = UIModalPresentationFullScreen;
            [self.getCurrentMethodCallerVC presentViewController:imagePickerVC animated:YES completion:nil];
        }
    }];
}

@end
