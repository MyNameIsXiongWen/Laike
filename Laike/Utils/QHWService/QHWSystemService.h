//
//  QHWSystemService.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/16.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWBaseService.h"
#import "QHWBannerModel.h"
#import "QHWConsultantModel.h"
#import "QHWActivityModel.h"
#import "QHWItemPageModel.h"
#import "QHWImageModel.h"
#import "QHWFilterModel.h"

NS_ASSUME_NONNULL_BEGIN

@class SearchContentModel;
@interface QHWSystemService : QHWBaseService

@property (nonatomic, strong) NSArray <QHWBannerModel *>*bannerArray;
@property (nonatomic, strong) NSMutableArray <QHWConsultantModel *>*consultantArray;
@property (nonatomic, strong) NSMutableArray <QHWActivityModel *>*activityArray;
@property (nonatomic, strong) NSArray <SearchContentModel *>*hotSearchArray;
@property (nonatomic, strong) NSArray <SearchContentModel *>*searchResultArray;
@property (nonatomic, strong) NSArray <FilterCellModel *>*countryArray;
@property (nonatomic, strong) QHWItemPageModel *itemPageModel;
///人气榜我的名次
@property (nonatomic, assign) NSInteger myRanking;

@property (nonatomic, strong) QHWActivityModel *activityDetailModel;
@property (nonatomic, assign) CGFloat activityDetailHeaderHeight;

+ (void)showLabelAlertViewWithTitle:(NSString *)title Img:(NSString *)img MerchantId:(NSString *)merchantId IndustryId:(NSInteger)industryId BusinessId:(NSString *)businessId DescribeCode:(NSInteger)describeCode PositionCode:(NSInteger)positionCode;

- (void)getCountryDataRequestWithComplete:(void (^)(void))complete;
- (void)getLikeRankRequestWithSubjectType:(NSInteger)subjectType Complete:(void (^)(void))complete;

/*
 advertPage:
101001:房产-列表-页面
101002:房产-详情-页面
102001:游学-列表-页面
102002:游学-详情-页面
103001:移民-列表-页面
103002:移民-详情-页面
104001:留学-列表-页面
104002:留学-详情-页面
105001:头条-列表-页面
105002:头条-详情-页面
106001:活动-列表-页面
106002:活动-详情-页面
107001:海外圈-列表-页面
107002:海外圈-详情-页面
108001:医疗-列表-页面
108002:医疗-详情-页面
109001:用户端-首页
 */
- (void)getBannerRequestWithAdvertPage:(NSInteger)advertPage Complete:(void (^)(_Nullable id response))complete;
- (void)getActivityListRequestWithIndustryId:(NSInteger)industryId RegisterStatus:(NSInteger)registerStatus Complete:(void (^)(void))complete;
- (void)getActivityDetailInfoRequestWithActivityId:(NSString *)activityId Complete:(void (^)(BOOL status))complete;
- (void)registerActivityRequestWithActivityId:(NSString *)activityId ColumnList:(NSArray *)columnList;

- (void)getHotSearchDataRequestWithBusinessPage:(NSInteger)businessPage Complete:(void (^)(void))complete;
- (void)getSearchContentDataRequestWithBusinessPage:(NSInteger)businessPage Content:(NSString *)content Complete:(void (^)(void))complete;

/*关注状态：1-取消；2-关注*/
- (void)clickConcernRequestWithSubject:(NSInteger)subject SubjectId:(NSString *)subjectId ConcernStatus:(NSInteger)concernStatus Complete:(void (^)(BOOL status))complete;
/*点赞状态：1-取消；2-点赞
业务类型：1-房产；2-游学；3-移民；4-留学；5-头条(内容);6-头条（评论）；7-头条(回复)；8-攻略（内容）；9-攻略（评论）；10-攻略（回复）；11-问答(回答)；12-问答(提问)；
 */
- (void)clickLikeRequestWithBusinessType:(NSInteger)businessType BusinessId:(NSString *)businessId LikeStatus:(NSInteger)likeStatus Complete:(void (^)(BOOL status))complete;
/*收藏状态：1-取消；2-收藏
业务类型：1-房产；2-游学；3-移民；4-留学；5-头条；6-攻略；7-问答；
 */
- (void)clickCollectRequestWithBusinessType:(NSInteger)businessType BusinessId:(NSString *)businessId CollectionStatus:(NSInteger)collectionStatus Complete:(void (^)(BOOL status))complete;

- (void)uploadImageWithArray:(NSArray *)imgArray Completed:(void (^)(NSMutableArray *pathArray))completed;
- (void)uploadVideoWithURL:(NSURL *)videoUrl Completed:(void (^)(NSMutableArray *pathArray))completed;

- (void)getMyCustomizeDataRequest;

///businessType：业务类型：1--房产；2-游学；3-移民；4-留学；5-头条；6-活动
- (void)getShareMiniCodeRequestWithBusinessType:(NSInteger)businessType BusinessId:(NSString *)businessId Completed:(void (^)(NSString *miniCodePath))completed;

@end

@interface SearchContentModel : NSObject <NSCoding>

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *list;
@property (nonatomic, assign) CGFloat contentWidth;
@property (nonatomic, assign) CGFloat contentHeight;

@end

NS_ASSUME_NONNULL_END
