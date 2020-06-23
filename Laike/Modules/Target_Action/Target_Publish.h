//
//  Target_Publish.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/9.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Target_Publish : NSObject

- (void)Action_nativePublishSuccessViewController:(NSDictionary *)params;
- (UICollectionViewCell *)Action_nativePublishImageCell:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
