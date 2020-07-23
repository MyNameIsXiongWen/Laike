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
@property (nonatomic, strong) NSMutableArray *trackArray;
@property (nonatomic, strong) NSMutableArray *advisoryArray;
@property (nonatomic, strong) NSArray *countryArray;
@property (nonatomic, strong) NSMutableArray *intentionCountryArray;
@property (nonatomic, assign) CGFloat tableHeaderViewHeight;
@property (nonatomic, assign) CGFloat intentionCountryHeight;
@property (nonatomic, assign) NSInteger crmCount;
@property (nonatomic, assign) NSInteger clueCount;
@property (nonatomic, assign) NSInteger consultCount;

@property (nonatomic, strong) NSArray <FilterCellModel *>*clientSourceList;
@property (nonatomic, strong) NSArray <FilterCellModel *>*clientLevelList;
@property (nonatomic, strong) NSArray <FilterCellModel *>*industryList;
@property (nonatomic, strong) NSArray <FilterCellModel *>*intentionLevelList;
@property (nonatomic, strong) NSArray <FilterCellModel *>*followStatusList;

- (void)getHomeReportCountDataWithComplete:(void (^)(void))complete;
- (void)getCRMFilterDataRequestWithComplete:(void (^)(_Nullable id responseObject))complete;
- (void)getCRMListDataRequestWithCondition:(NSDictionary *)condition Complete:(void (^)(void))complete;
- (void)getClueListDataRequestWithComplete:(void (^)(void))complete;
- (void)getClueActionListDataRequestWithComplete:(void (^)(void))complete;
- (void)getClueActionAllListDataRequestWithComplete:(void (^)(void))complete;


- (void)getCRMDetailInfoRequestWithComplete:(void (^)(void))complete;
- (void)handleCRMDetailInfoData;
- (void)getCRMTrackListDataRequestWithComplete:(void (^)(void))complete;

- (void)CRMAddCustomerRequestWithComplete:(void (^)(void))complete;
- (void)CRMAddTrackRequestWithFollowStatusCode:(NSInteger)followStatusCode Remark:(NSString *)remark Complete:(void (^)(void))complete;
- (void)CRMGiveUpTrackRequest;
- (void)advisoryGiveUpTrackRequest;

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
@property (nonatomic, strong) NSArray *industryList;
@property (nonatomic, strong) NSArray *countryList;
@property (nonatomic, copy) NSString *genderStr;
@property (nonatomic, copy) NSString *industryStr;
@property (nonatomic, strong) NSArray *industryNameArray;
@property (nonatomic, copy) NSString *countryStr;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, assign) NSInteger actionCount;

///客户状态1-未添加；2-已添加，此字段用于判断显示是否已添加到客户
@property (nonatomic, assign) NSInteger clientStatus;
///客户来源：1-网路客；2-自拓客；3-渠道客；4-其它
@property (nonatomic, assign) NSInteger clientSourceCode;
@property (nonatomic, copy) NSString *clientSourceName;
///客户等级：1-A重点关注；2-B日常维护；3-C仅做记录
@property (nonatomic, assign) NSInteger clientLevel;
@property (nonatomic, copy) NSString *clientLevelName;
///客户意向等级代码：1-高；2-中；3-低；4-放弃：
@property (nonatomic, assign) NSInteger intentionLevelCode;
@property (nonatomic, copy) NSString *intentionLevelName;

@property (nonatomic, assign) CGFloat detailRemarkStrH;
@property (nonatomic, assign) CGFloat detailIndustryStrH;
@property (nonatomic, assign) CGFloat detailCountryStrH;

@end

@interface CRMTrackModel : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *followName;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *note;
@property (nonatomic, assign) CGFloat trackHeight;

@end

@interface CRMAdvisoryModel : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *title1;
@property (nonatomic, copy) NSString *title2;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *businessId;
@property (nonatomic, assign) NSInteger businessType;
@property (nonatomic, assign) CGFloat advisoryHeight;

@end

NS_ASSUME_NONNULL_END
