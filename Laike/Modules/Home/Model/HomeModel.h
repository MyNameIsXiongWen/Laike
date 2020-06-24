//
//  HomeModel.h
//  Laike
//
//  Created by xiaobu on 2020/6/23.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

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

@property (nonatomic, strong) NSArray *countryList;
@property (nonatomic, strong) NSArray *industryList;
@property (nonatomic, strong) NSDictionary *clientData;

@property (nonatomic, assign) NSInteger bindStatus;
@property (nonatomic, assign) NSInteger payStatus;
@property (nonatomic, assign) NSInteger clueCount;
@property (nonatomic, assign) NSInteger productCount;
@property (nonatomic, assign) NSInteger shareCount;
@property (nonatomic, assign) NSInteger distributionCount;
@property (nonatomic, assign) NSInteger userCount;
@property (nonatomic, assign) NSInteger userDays;

@end

NS_ASSUME_NONNULL_END
