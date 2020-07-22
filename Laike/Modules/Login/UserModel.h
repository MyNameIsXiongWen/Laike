//
//  UserModel.h
//  GoOverSeas
//
//  Created by xiaobu on 2019/7/31.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QHWConsultantModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserModel : NSObject <NSCoding>

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *subjectId;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *realName;
///头像路径,七牛云
@property (nonatomic, copy) NSString *headPath;
///背景路径,七牛云
@property (nonatomic, copy) NSString *bgPath;
@property (nonatomic, copy) NSString *mail;
///职业
@property (nonatomic, copy) NSString *occupation;

@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *slogan;
@property (nonatomic, copy) NSString *mobileNumber;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *merchantId;
@property (nonatomic, copy) NSString *merchantHead;
@property (nonatomic, copy) NSString *merchantInfo;
@property (nonatomic, copy) NSString *merchantName;
@property (nonatomic, copy) NSString *compositeScore;
@property (nonatomic, copy) NSString *html;
@property (nonatomic, copy) NSString *htmlUrl;
@property (nonatomic, copy) NSString *qrCode;
@property (nonatomic, copy) NSString *wechatNo;
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *hideNumber;


///客户来源：1-网路客；2-自拓客；3-渠道客；4-其它
@property (nonatomic, assign) NSInteger clientSourceCode;
@property (nonatomic, copy) NSString *clientSourceName;
///客户意向等级代码(1-高；2-中；3-低；4-放弃)
@property (nonatomic, assign) NSInteger intentionLevelCode;
@property (nonatomic, copy) NSString *intentionLevelName;
@property (nonatomic, copy) NSString *industryName;
@property (nonatomic, copy) NSString *industryId;

///商户绑定状态:1-已绑定；2未绑定
@property (nonatomic, assign) NSInteger bindStatus;
///分销状态：1-未代理分销；2-已代理分销
@property (nonatomic, assign) NSInteger distributionStatus;
///1-账户存在登录；2-新账户注册登录
@property (nonatomic, assign) NSInteger loginStatus;
///用户性别（默认为0）：0-无；1-男；2-女
@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, copy) NSString *genderStr;
///婚姻状态（默认为0）：0-无；1-未婚；2-已婚；3-丧偶；4-离异
@property (nonatomic, assign) NSInteger marriageStatus;
@property (nonatomic, copy) NSString *marriageStr;
///环信状态：1-未注册；2-注册成功;3-注册失败；（默认值1）
@property (nonatomic, assign) NSInteger hxStatus;
///角色状态：1-普通用户；2-顾问；  3:商户
@property (nonatomic, assign) NSInteger roleStatus;
@property (nonatomic, assign) NSInteger subject;
///认证状态：1-未认证；2-已认证
@property (nonatomic, assign) NSInteger authenStatus;
///关注状态：1-未关注；2-已关注
@property (nonatomic, assign) NSInteger concernStatus;
///浏览数量
@property (nonatomic, assign) NSInteger browseCount;
///收藏数量
@property (nonatomic, assign) NSInteger collectionCount;
///点赞数量
@property (nonatomic, assign) NSInteger likeCount;
@property (nonatomic, assign) NSInteger visitCount;
///关注数量
@property (nonatomic, assign) NSInteger concernCount;
///咨询数量
@property (nonatomic, assign) NSInteger consultCount;
///粉丝数量
@property (nonatomic, assign) NSInteger fansCount;
@property (nonatomic, assign) NSInteger productCount;
@property (nonatomic, assign) NSInteger contentCount;
@property (nonatomic, assign) NSInteger distributionCount;
///访客总量
@property (nonatomic, assign) NSInteger userCount;
@property (nonatomic, assign) NSInteger crmCount;
///去海外咨询总量
@property (nonatomic, assign) NSInteger clueCount;

@property (nonatomic, strong) NSArray *countryList;
@property (nonatomic, strong) NSArray *contentList;
@property (nonatomic, strong) NSArray *industryList;
@property (nonatomic, strong) NSArray <QHWConsultantModel *>*consultantList;


@property (nonatomic, assign) NSInteger unreadMsgCount;
@property (nonatomic, assign) NSInteger officialUnreadMsgCount;
@property (nonatomic, strong) UIImage *snapShotImage;
@property (nonatomic, assign) NSInteger businessType;

/**
 单例
 @return UserModel
 */
+ (UserModel *)shareUser;

/**
 清除user，移除观察者
 */
+ (void)clearUser;

+ (void)logout;
- (void)hxLogin;

/**
 归档
 */
- (void)keyArchiveUserModel;

/**
 解档
 @return UserModel
 */
+ (UserModel *)keyUnarchiveUserModel;

@end

NS_ASSUME_NONNULL_END
