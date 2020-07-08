//
//  CommunityService.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/18.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWBaseService.h"
#import "QHWItemPageModel.h"
#import "QHWCommunityArticleModel.h"
#import "QHWCommunityContentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommunityService : QHWBaseService

///社区类型 1:头条  2:圈子
@property (nonatomic, assign) NSInteger communityType;
@property (nonatomic, assign) NSInteger businessType;
@property (nonatomic, strong) QHWItemPageModel *itemPageModel;
@property (nonatomic, strong) NSMutableArray *dataArray;
- (void)getCoummunityDataWithComplete:(void (^)(void))complete;
- (void)deleteCommentRequestWithContentId:(NSString *)contentId Complete:(void (^)(void))complete;

@end

NS_ASSUME_NONNULL_END
