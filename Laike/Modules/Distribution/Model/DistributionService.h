//
//  DistributionService.h
//  Laike
//
//  Created by xiaobu on 2020/7/4.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWBaseService.h"
#import "QHWItemPageModel.h"
#import "QHWFilterModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DistributionService : QHWBaseService

@property (nonatomic, strong) QHWItemPageModel *itemPageModel;
@property (nonatomic, strong) NSMutableArray <FilterCellModel *>*followStatusArray;
@property (nonatomic, strong) NSMutableArray *clientArray;

- (void)getClientFilterDataRequestWithComplete:(void (^)(void))complete;
- (void)getClientListRequestWithFollowStatusCode:(NSString *)code Complete:(void (^)(void))complete;

@end

@interface ClientModel : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *headPath;
@property (nonatomic, copy) NSString *realName;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *businessId;
@property (nonatomic, assign) NSInteger businessType;

@end

NS_ASSUME_NONNULL_END
