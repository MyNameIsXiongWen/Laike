//
//  HomeService.h
//  Laike
//
//  Created by xiaobu on 2020/6/22.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWBaseService.h"
#import "QHWItemPageModel.h"
#import "HomeModel.h"
#import "QHWMainBusinessDetailBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeService : QHWBaseService

@property (nonatomic, strong) HomeModel *homeModel;
@property (nonatomic, strong) QHWItemPageModel *itemPageModel;
@property (nonatomic, strong) NSMutableArray *iconArray;
@property (nonatomic, assign) CGFloat headerViewTableHeight;
@property (nonatomic, strong) NSArray *consultantArray;
@property (nonatomic, strong) NSArray *schoolArray;
@property (nonatomic, strong) NSArray *bannerArray;
@property (nonatomic, strong) NSMutableArray *reportArray;
///1: 首页  2:分销
@property (nonatomic, assign) NSInteger pageType;

- (void)handleHomeData;
- (void)getHomeReportDataWithComplete:(void (^)(void))complete;
- (void)getHomeConsultantDataWithComplete:(void (^)(void))complete;
- (void)getHomeReportCountDataRequestWithComplete:(void (^)(void))complete;

- (void)getHomePageProductListRequestWithIdentifier:(NSString *)identifier Complete:(void (^)(void))complete;

@end

NS_ASSUME_NONNULL_END
