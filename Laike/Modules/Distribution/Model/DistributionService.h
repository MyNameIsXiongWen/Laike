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

@class ClientModel;
@interface DistributionService : QHWBaseService

@property (nonatomic, strong) QHWItemPageModel *itemPageModel;
@property (nonatomic, strong) NSMutableArray <FilterCellModel *>*followStatusArray;
//@property (nonatomic, strong) NSMutableArray *clientArray;

@property (nonatomic, strong) ClientModel *clientDetailModel;
@property (nonatomic, copy) NSString *customerId;
@property (nonatomic, assign) CGFloat tableHeaderViewHeight;

- (void)getClientFilterDataRequestWithComplete:(void (^)(void))complete;
- (void)getClientListRequestWithFollowStatusCode:(NSString *)code Complete:(void (^)(void))complete;
- (void)getClientDetailInfoRequestComplete:(void (^)(void))complete;
- (void)getClientDetailTrackListRequestComplete:(void (^)(void))complete;

@end

@interface ClientModel : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *headPath;
@property (nonatomic, copy) NSString *realName;
@property (nonatomic, copy) NSString *mobileNumber;
@property (nonatomic, copy) NSString *idNumber;
@property (nonatomic, copy) NSString *passportNumber;
@property (nonatomic, copy) NSString *note;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *businessId;
@property (nonatomic, copy) NSString *businessName;
@property (nonatomic, assign) NSInteger businessType;
@property (nonatomic, assign) CGFloat businessHeight;
@property (nonatomic, assign) CGFloat productHeight;
@property (nonatomic, assign) CGFloat infoHeight;

@end

NS_ASSUME_NONNULL_END
