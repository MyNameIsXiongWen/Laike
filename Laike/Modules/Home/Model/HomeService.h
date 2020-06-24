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

- (void)handleHomeData;
- (void)getHomeDataWithComplete:(void (^)(BOOL status, id responseObject))complete;

- (void)getSchoolDataWithComplete:(void (^)(void))complete;

- (void)getHomePageProductListRequestWithBusinessType:(NSInteger)businessType Complete:(void (^)(void))complete;

@end

NS_ASSUME_NONNULL_END
