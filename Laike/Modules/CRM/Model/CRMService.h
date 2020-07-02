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
@property (nonatomic, strong) CRMModel *crmModel;
@property (nonatomic, copy) NSString *customerId;
@property (nonatomic, strong) NSMutableArray <FilterBtnViewCellModel *>*filterDataArray;
@property (nonatomic, strong) NSMutableArray <CRMModel *>*crmArray;
@property (nonatomic, assign) CGFloat tableHeaderViewHeight;

- (void)getCRMFilterDataRequestWithComplete:(void (^)(_Nullable id responseObject))complete;
- (void)getCRMListDataRequestWithCondition:(NSDictionary *)condition Complete:(void (^)(void))complete;
- (void)getClueListDataRequestWithComplete:(void (^)(void))complete;

- (void)getCRMDetailInfoRequestWithComplete:(void (^)(void))complete;

- (void)CRMAddCustomerRequestWithName:(NSString *)name Phone:(NSString *)phone Source:(NSInteger)source Remark:(NSString *)remark Complete:(void (^)(void))complete;
- (void)CRMAddTrackRequestWithCustomerId:(NSString *)customerId FollowStatusCode:(NSInteger)followStatusCode Remark:(NSString *)remark Complete:(void (^)(void))complete;

@end

@interface CRMModel : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *lastTime;
@property (nonatomic, copy) NSString *realName;
@property (nonatomic, copy) NSString *userInfoId;
@property (nonatomic, copy) NSString *headPath;
@property (nonatomic, copy) NSString *wechatNumber;
@property (nonatomic, copy) NSString *mobileNumber;
@property (nonatomic, copy) NSString *note;
///用户性别（默认为0）：0-无；1-男；2-女
@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, copy) NSString *genderStr;
@property (nonatomic, copy) NSString *industryStr;
@property (nonatomic, copy) NSString *countryStr;
@property (nonatomic, strong) NSArray *industryList;
@property (nonatomic, strong) NSArray *countryList;

///客户来源：1-网路客；2-自拓客；3-渠道客；4-其它
@property (nonatomic, assign) NSInteger clientSourceCode;
@property (nonatomic, copy) NSString *clientSourceName;
///客户意向等级代码(1-高；2-中；3-低；4-放弃)
@property (nonatomic, assign) NSInteger intentionLevelCode;
@property (nonatomic, copy) NSString *intentionLevelName;

@property (nonatomic, assign) CGFloat remarkH;
@property (nonatomic, assign) CGFloat industryH;
@property (nonatomic, assign) CGFloat countryH;

@end

NS_ASSUME_NONNULL_END
