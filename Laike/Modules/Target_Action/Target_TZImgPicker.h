//
//  Target_TZImgPicker.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/11.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Target_TZImgPicker : NSObject

- (void)Action_nativeOnlyPhotoShowTZImagePickerViewController:(NSDictionary *)params;

- (void)Action_nativeShowTZImagePickerViewController:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
