//
//  CTMediator+TZImgPicker.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/11.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "CTMediator.h"

NS_ASSUME_NONNULL_BEGIN

@interface CTMediator (TZImgPicker)

- (void)CTMediator_showTZImagePickerWithMaxCount:(NSInteger)maxCount ResultBlk:(void (^)(NSArray <UIImage *>* photos))blk;

@end

NS_ASSUME_NONNULL_END
