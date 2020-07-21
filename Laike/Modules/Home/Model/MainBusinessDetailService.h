//
//  MainBusinessDetailService.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/26.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWBaseService.h"
#import "QHWSystemService.h"
#import "QHWMainBusinessDetailBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainBusinessDetailService : QHWBaseService

@property (nonatomic, assign) NSInteger businessType;
@property (nonatomic, copy) NSString *businessId;
@property (nonatomic, assign) BOOL isDistribution;

@property (nonatomic, strong) QHWMainBusinessDetailBaseModel *detailModel;
@property (nonatomic, assign) CGFloat headerViewHeight;
@property (nonatomic, strong) QHWSystemService *activityService;
@property (nonatomic, strong) NSMutableArray *tabDataArray;

- (void)getMainBusinessDetailInfoRequest:(void (^)(BOOL status))complete;

@end

NS_ASSUME_NONNULL_END
