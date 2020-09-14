//
//  QHWHttpAddress.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/2/29.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#ifndef QHWHttpAddress_h
#define QHWHttpAddress_h

static NSString *const kMainUrl = @"https://api.qhiwi.com/apiv1/";
//static NSString *const kMainUrl = @"https://api.qhiwi.com/apiv1test/";
//static NSString *const kMainUrl = @"http://120.78.158.34:8004/";

#pragma mark ------------协议相关-------------
static NSString *const kServiceProtocol = @"https://m.qhiwi.com/site/app/lk/service.html";
static NSString *const kPrivacyProtocol = @"https://m.qhiwi.com/site/app/lk/private.html";

static NSString *const kExpertCertification = @"http://file.qhiwi.com/manager_intro.png";
static NSString *const kAgencyCertification = @"http://file.qhiwi.com/merchant_intro.png";
static NSString *const kMyCustomizeUrl = @"https://m.qhiwi.com/site/custom/#/?channel=1&pass=4";
static NSString *const kRateUrl = @"https://sapi.k780.com/?app=finance.rate&scur=CNY&tcur=USD,JPY,AUD,GBP,NZD,THB,EUR,CAD,HKD&appkey=49989&sign=697bedf526e0b062a8c70ae8e0dd3271";


#pragma mark ------------用户模块-------------
static NSString *const kUserLogin = @"merchant/login/login";//登录注册
static NSString *const kMineMainPage = @"user/getTaInfo";//我的主页
static NSString *const kMineInfo = @"merchant/user/getInfo";//我的信息
static NSString *const kMineEdit = @"merchant/user/edit";//编辑信息
static NSString *const kUserConsultantInfo = @"user/userAndConsultTaInfo1";//个人/顾问主页
static NSString *const kMerchantInfo = @"merchant/getInfo";//商户主页
static NSString *const kConsultantList = @"merchant/user/getList";//顾问列表
static NSString *const kMyCommentList = @"user/comment/getMyList";//我的评论
static NSString *const kMyConcernList = @"concern/getMyList";//我的关注
static NSString *const kMyFansList = @"fans/getMyList";//我的粉丝
static NSString *const kMyBrowsedList = @"action/browse/getMyList";//我的浏览
static NSString *const kMyCollectList = @"action/collection/getMyList";//我的收藏
static NSString *const kDeleteMyComment = @"user/comment/delete";//删除我的评论
static NSString *const kFeedback = @"communication/add";//问题反馈

#pragma mark ------------系统-------------
static NSString *const kSystemSendCode = @"sms/sendCode2";//发送验证码
static NSString *const kSystemGetCode = @"sms/getCode2";//获取图片验证码
static NSString *const kSystemBanner = @"comAdvert/position/getInfo";//获取广告位
static NSString *const kSystemIcon = @"configure/control/getData";//获取Icon
static NSString *const kSystemQNToken = @"qiniu/user/queryQiniuUploadAuthen";//获取七牛token
static NSString *const kSystemAuthorize = @"user/intentionUser";//授权
static NSString *const kSystemSearchHotData = @"hot/industry/getSearch";//获取热门搜索
static NSString *const kSystemSearchContentData = @"hot/industry/getList";//获取搜索结果
static NSString *const kSystemCustomize = @"custom/user/myCustom";//获取我的定制
static NSString *const kSystemGetMiniCode = @"product/getQrcode";//获取分享的小程序码




#pragma mark ------------来客接口-------------
static NSString *const kSystemCountry = @"configure/city/getAllOverseasCountryTree";//所有国家

static NSString *const kHomeReport = @"report/getHome";//主页报表
static NSString *const kHomeReportCount = @"report/getCount";//主页报表
static NSString *const kHomeConsultant = @"merchant/user/getHome";//主页顾问
static NSString *const kSystemLike = @"action/like/top";//点赞排行榜
static NSString *const kProductList = @"product/getList";//产品列表

static NSString *const kDistributionFilter = @"distribution/client/getVariable";//筛选条件
static NSString *const kDistributionList = @"distribution/release/getList";//分销列表
static NSString *const kDistributionTrackList = @"distribution/follow/getList";//分销模块-进度-列表
static NSString *const kDistributionClientInfo = @"distribution/client/getInfo";//分销模块-客户-信息
static NSString *const kDistributionClientList = @"distribution/client/getList";//分销模块-客户-列表
static NSString *const kDistributionClientAdd = @"distribution/client/add";//分销模块-客户-添加

static NSString *const kSchoolList = @"learn/getList";//Q大学列表
static NSString *const kSchoolInfo = @"learn/getInfo";//Q大学详情
static NSString *const kSchoolCommentList = @"learn/comment/getList";//Q大学评论列表
static NSString *const kSchoolCommentAdd = @"learn/comment/add";//Q大学添加评论

static NSString *const kMerchantBind = @"merchant/user/bindMerchant";//绑定公司
static NSString *const kMerchantGetCompanyName = @"merchant/user/getBindMerchant";//


static NSString *const kCRMFilter = @"client/getVariable";//crm筛选条件
static NSString *const kCRMList = @"client/getList";//crm列表
static NSString *const kCRMDetailInfo = @"client/getInfo";
static NSString *const kCRMAdd = @"client/add";//crm add
static NSString *const kCRMEdit = @"client/edit";//crm edit
static NSString *const kCRMAddTrack = @"client/follow/add";//crm add track
static NSString *const kCRMGiveUpTrack = @"client/giveUp";//crm giveUp track
static NSString *const kCRMTrackList = @"client/follow/getList";//crm track list
static NSString *const kCRMAdvisoryGiveUpTrack = @"clue/action/giveUp";

static NSString *const kClueList = @"clue/getList";//咨询(获客)列表
static NSString *const kClueActionAllList = @"clue/action/getAllList";//线索模块-行为-客户所有列表
static NSString *const kClueActionList = @"clue/action/getList";//线索模块-行为-列表

static NSString *const kActionBrowseList = @"action/browse/getMyList";//访客列表
static NSString *const kActionBrowseInfo = @"action/browse/getMyInfo";//访客详情
static NSString *const kActionLikeList = @"action/like/getMyList";//点赞列表
static NSString *const kFansList = @"fans/getMyList";//粉丝列表


static NSString *const kGalleryList = @"gallery/getList";//图库列表
static NSString *const kGalleryFilter = @"gallery/getVariable";//图库选项

static NSString *const kHomeBanner = @"advert/home/getInfo";//首页广告位
static NSString *const kHomeWindowBanner = @"advert/window/getInfo";//首页弹框广告位

#pragma mark ------------产品-------------
static NSString *const kHouseList = @"house/getList";//房产列表
static NSString *const kHouseFilter = @"house/getVariable";//房产筛选条件
static NSString *const kHouseInfo = @"house/getInfo";//房产详情
static NSString *const kStudyList = @"study/getList";//游学列表
static NSString *const kStudyFilter = @"study/getVariable";//游学筛选条件
static NSString *const kStudyInfo = @"study/getInfo";//游学详情
static NSString *const kMigrationList = @"migration/getList";//移民列表
static NSString *const kMigrationFilter = @"migration/getVariable";//移民筛选条件
static NSString *const kMigrationInfo = @"migration/getInfo";//移民详情
static NSString *const kStudentList = @"student/getList";//留学列表
static NSString *const kStudentFilter = @"student/getVariable";//留学筛选条件
static NSString *const kStudentInfo = @"student/getInfo";//留学详情
static NSString *const kTreatmentList = @"treatment/getList";//医疗列表
static NSString *const kTreatmentFilter = @"treatment/getVariable";//医疗筛选条件
static NSString *const kTreatmentInfo = @"treatment/getInfo";//医疗详情

static NSString *const kActivityList = @"activity/getList";//活动列表
static NSString *const kActivityInfo = @"activity/getInfo";//活动详情
static NSString *const kActivityRegister = @"activity/register";//活动报名

static NSString *const kLiveList = @"video/getList";//直播列表
static NSString *const kLiveInfo = @"video/getInfo";//直播详情
static NSString *const kLiveCommentList = @"comComment/getList";//直播评论列表
static NSString *const kLiveCommentAdd = @"comComment/add";//直播添加评论

#pragma mark ------------热搜-------------
static NSString *const kHotIndustryList = @"hot/industry/getList";//热门结果列表
static NSString *const kHotIndustryCountry = @"configure/city/getHotIndustryCountry";//根据行业查询热门国家
static NSString *const kIndustryOverseasCountry = @"configure/city/getIndustryOverseasCountryTree";//根据行业查询海外洲国家城市类

#pragma mark ------------头条圈子-------------
static NSString *const kCommunityArticleList = @"article/getList";//头条列表
static NSString *const kCommunityArticleDetail = @"article/getInfo";//头条详情
static NSString *const kCommunityArticleCommentList = @"article/comment/getList";//头条评论列表
static NSString *const kCommunityArticleCommentAdd = @"article/comment/add";//头条添加评论
static NSString *const kCommunityArticleCommentReply = @"article/answer/add";//头条回复评论
static NSString *const kCommunityArticleReplyList = @"article/answer/getList";//头条回复列表

static NSString *const kCommunityRelateProdect = @"content/relateProduct";//关联产品
static NSString *const kCommunityAdd = @"content/add";//圈子发布
static NSString *const kCommunityDelete = @"content/delete";//圈子删除
static NSString *const kCommunityContentList = @"content/getList";//圈子列表
static NSString *const kCommunityContentDetail = @"content/getInfo";//圈子详情
static NSString *const kCommunityContentCommentList = @"content/comment/getList";//圈子评论列表
static NSString *const kCommunityContentCommentAdd = @"content/comment/add";//圈子添加评论
static NSString *const kCommunityContentCommentReply = @"content/answer/add";//圈子回复评论
static NSString *const kCommunityContentReplyList = @"content/answer/getList";//圈子回复列表

#pragma mark ------------操作-------------
static NSString *const kActionCollect = @"action/collection/clikCollection";//收藏
static NSString *const kActionLike = @"action/like/clickLike";//点赞
static NSString *const kActionConcern = @"concern/clickConcern";//关注

static NSString *const kIMAuthorizeRequest = @"chat/authorize/request";//授权请求

#endif /* QHWHttpAddress_h */
