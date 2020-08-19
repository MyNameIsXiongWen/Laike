//
//  HomeModel.h
//  Laike
//
//  Created by xiaobu on 2020/6/23.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class HomeClientModel;
@interface HomeModel : NSObject

@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *headPath;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *merchantHead;
@property (nonatomic, copy) NSString *merchantId;
@property (nonatomic, copy) NSString *merchantInfo;
@property (nonatomic, copy) NSString *merchantName;
@property (nonatomic, copy) NSString *mobileNumber;
@property (nonatomic, copy) NSString *qrCode;
@property (nonatomic, copy) NSString *realName;
@property (nonatomic, copy) NSString *slogan;
@property (nonatomic, copy) NSString *visitHeadPath;
@property (nonatomic, copy) NSString *visitTip;
@property (nonatomic, copy) NSString *wechatNo;
@property (nonatomic, copy) NSString *htmlUrl;

@property (nonatomic, strong) NSArray *countryList;
@property (nonatomic, strong) NSArray *industryList;
@property (nonatomic, strong) HomeClientModel *clientData;

@property (nonatomic, assign) NSInteger bindStatus;
@property (nonatomic, assign) NSInteger payStatus;
@property (nonatomic, assign) NSInteger clueCount;
@property (nonatomic, assign) NSInteger consultCount;
@property (nonatomic, assign) NSInteger productCount;
@property (nonatomic, assign) NSInteger shareCount;
@property (nonatomic, assign) NSInteger distributionCount;
///访客总量
@property (nonatomic, assign) NSInteger userCount;
///近7日访客
@property (nonatomic, assign) NSInteger userDays;
///分销状态：1-未代理分销；2-已代理分销
@property (nonatomic, assign) NSInteger distributionStatus;

@end

@interface HomeClientModel : NSObject

@property (nonatomic, assign) NSInteger intentionLevel1Count;
@property (nonatomic, assign) NSInteger intentionLevel2Count;
@property (nonatomic, assign) NSInteger intentionLevel3Count;
@property (nonatomic, assign) NSInteger crmCount;

@end

NS_ASSUME_NONNULL_END
