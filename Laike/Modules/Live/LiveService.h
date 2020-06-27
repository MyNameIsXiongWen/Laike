//
//  LiveService.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/6/11.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWBaseService.h"
#import "QHWItemPageModel.h"
#import "LiveModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LiveService : QHWBaseService

@property (nonatomic, strong) QHWItemPageModel *itemPageModel;
@property (nonatomic, strong) NSMutableArray <LiveModel *>*dataArray;
@property (nonatomic, strong) LiveModel *liveDetailModel;

- (void)getLiveListRequestWithComplete:(void (^)(void))complete;
- (void)getLiveDetailInfoRequestWithLiveId:(NSString *)liveId Complete:(void (^)(BOOL status))complete;

@end

NS_ASSUME_NONNULL_END
