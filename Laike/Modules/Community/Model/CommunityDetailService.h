//
//  CommunityDetailService.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/22.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWBaseService.h"
#import "QHWBottomUserModel.h"

NS_ASSUME_NONNULL_BEGIN

@class CommunityDetailModel;
@interface CommunityDetailService : QHWBaseService

@property (nonatomic, copy) NSString *communityId;
@property (nonatomic, assign) NSInteger communityType;
@property (nonatomic, strong) CommunityDetailModel *detailModel;
- (void)getCommunityDetailRequestWithComplete:(void (^)(void))complete;

@end

@class BusinessListModel;
@interface CommunityDetailModel : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *articleDescribe;
@property (nonatomic, copy) NSString *articleTypeName;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *industryId;
@property (nonatomic, copy) NSString *industryName;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *Html2Text;
@property (nonatomic, copy) NSString *htmlUrl;
//头条
@property (nonatomic, copy) NSString *merchantId;
@property (nonatomic, copy) NSString *merchantName;
@property (nonatomic, copy) NSString *merchantHead;
@property (nonatomic, copy) NSString *serviceHotline;
//圈子
@property (nonatomic, copy) NSString *consultId;
@property (nonatomic, copy) NSString *consultName;
@property (nonatomic, copy) NSString *consultHead;
///视频状态：1-横向；2-竖向
@property (nonatomic, assign) NSInteger videoStatus;
@property (nonatomic, copy) NSString *qrCode;

///头条用
@property (nonatomic, strong) QHWBottomUserModel *subjectData;
///圈子用
@property (nonatomic, strong) QHWBottomUserModel *bottomData;

@property (nonatomic, strong) NSArray <BusinessListModel *>*businessList;
@property (nonatomic, strong) UIImage *videoImg;
@property (nonatomic, strong) NSArray *filePathList;
@property (nonatomic, strong) NSArray *coverPathList;
///文件类型：1--视频；2-图片（限制最多9张）
@property (nonatomic, assign) NSInteger fileType;
///允许转载:1-是；2-否
@property (nonatomic, assign) NSInteger repeat;
///来源：1-原创；2-转载
@property (nonatomic, assign) NSInteger source;
@property (nonatomic, copy) NSString *sourceStr;
///收藏状态：1-未收藏；2-已收藏
@property (nonatomic, assign) NSInteger collectionStatus;
///点赞状态：1-未点赞；2-已点赞
@property (nonatomic, assign) NSInteger likeStatus;
///关注状态：1-未关注；2-已关注
@property (nonatomic, assign) NSInteger concernStatus;
///认证状态：1-未认证；2-已认证
@property (nonatomic, assign) NSInteger authenStatus;
@property (nonatomic, assign) NSInteger browseCount;
@property (nonatomic, assign) NSInteger collectionCount;
@property (nonatomic, assign) NSInteger shareCount;
@property (nonatomic, assign) NSInteger commentCount;
@property (nonatomic, assign) NSInteger likeCount;

@property (nonatomic, assign) CGFloat headerTopHeight;
@property (nonatomic, assign) CGFloat headerContentHeight;
@property (nonatomic, strong) UIImage *snapShotImage;

@end

@interface BusinessListModel : NSObject

@property (nonatomic, assign) NSInteger businessType;
@property (nonatomic, copy) NSString *businessId;
@property (nonatomic, copy) NSString *coverPath;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) long price;

@end

NS_ASSUME_NONNULL_END
