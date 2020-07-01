//
//  CRMService.h
//  Laike
//
//  Created by xiaobu on 2020/6/24.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWBaseService.h"
#import "QHWItemPageModel.h"
#import "FilterBtnViewCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@class CRMModel;
@interface CRMService : QHWBaseService

@property (nonatomic, strong) QHWItemPageModel *itemPageModel;
@property (nonatomic, strong) NSMutableArray <FilterBtnViewCellModel *>*filterDataArray;
@property (nonatomic, strong) NSMutableArray <CRMModel *>*crmArray;

- (void)getCRMFilterDataRequestWithComplete:(void (^)(void))complete;
- (void)getCRMListDataRequestWithCondition:(NSDictionary *)condition Complete:(void (^)(void))complete;
- (void)getClueListDataRequestWithComplete:(void (^)(void))complete;
- (void)CRMAddCustomerRequestWithName:(NSString *)name Phone:(NSString *)phone Source:(NSInteger)source Remark:(NSString *)remark Complete:(void (^)(void))complete;

@end

@interface CRMModel : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *lastTime;
@property (nonatomic, copy) NSString *realName;
@property (nonatomic, copy) NSString *userInfoId;
@property (nonatomic, strong) NSArray *industryList;
@property (nonatomic, copy) NSString *headPath;

@end

NS_ASSUME_NONNULL_END
