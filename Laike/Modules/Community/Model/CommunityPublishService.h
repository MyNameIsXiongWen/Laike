//
//  CommunityPublishService.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/21.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWBaseService.h"
#import "QHWImageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommunityPublishService : QHWBaseService

//- (void)publishRequestWithImage:(NSArray *)array Completed:(void (^)(void))completed;
- (void)uploadImageWithContent:(NSString *)content Completed:(void (^)(void))completed;
@property (nonatomic, strong) NSArray *dataSource;
///1--视频；2-图片
@property (nonatomic, assign) NSInteger fileType;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, assign) NSInteger industryId;
@property (nonatomic, strong) NSArray *industryArray;
@property (nonatomic, strong) NSMutableArray *selectedProductArray;

@end

NS_ASSUME_NONNULL_END
