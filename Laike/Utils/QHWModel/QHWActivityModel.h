//
//  QHWActivityModel.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/28.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QHWMainBusinessDetailBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QHWActivityModel : QHWMainBusinessDetailBaseModel

@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, copy) NSString *cityId;
@property (nonatomic, copy) NSString *startTimeMobile;
@property (nonatomic, copy) NSString *startEnd;
@property (nonatomic, copy) NSString *addres;
@property (nonatomic, copy) NSString *activityStatusName;

@property (nonatomic, copy) NSString *activityTypeId;
@property (nonatomic, copy) NSString *activityTypeName;
@property (nonatomic, copy) NSString *activityContent;
@property (nonatomic, copy) NSString *mainName;
@property (nonatomic, copy) NSString *mainHead;
@property (nonatomic, copy) NSString *mainDescribe;
@property (nonatomic, copy) NSString *speakerName;
@property (nonatomic, copy) NSString *speakerHead;
@property (nonatomic, copy) NSString *speakerDescribe;
@property (nonatomic, copy) NSString *industryId;
@property (nonatomic, copy) NSString *industryName;
///活动持续天数
@property (nonatomic, assign) NSInteger days;
///活动状态（1-待开始；2-进行中；3-已结束；4-已暂停
@property (nonatomic, assign) NSInteger activityStatus;
///报名状态：1-可以报名；2-报名已结束
@property (nonatomic, assign) NSInteger entryStatus;
@property (nonatomic, assign) CGFloat longitude;
@property (nonatomic, assign) CGFloat latitude;
///报名费用（自定义，单位分，展示元）
@property (nonatomic, assign) CGFloat registerCost;
///报名数量
@property (nonatomic, assign) NSInteger registerCount;
///报名方式List（1-name-姓名；2-mobileNumber-手机号；3-profession-职业；4-mail-邮箱；）
@property (nonatomic, strong) NSArray *registerModeList;
@property (nonatomic, strong) NSArray *coverPathList;

@property (nonatomic, assign) CGFloat cellHeight;

@end

NS_ASSUME_NONNULL_END
