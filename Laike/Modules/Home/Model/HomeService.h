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

NS_ASSUME_NONNULL_BEGIN

@interface HomeService : QHWBaseService

@property (nonatomic, strong) HomeModel *homeModel;
@property (nonatomic, strong) QHWItemPageModel *itemPageModel;
@property (nonatomic, assign) CGFloat headerViewTableHeight;

- (void)getHomeDataWithComplete:(void (^)(BOOL status, id responseObject))complete;
- (void)getHomePageProductListRequestWithIdentifier:(NSString *)identifier Complete:(void (^)(void))complete;

@end

NS_ASSUME_NONNULL_END
