//
//  QHWStudyModel.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/20.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWMainBusinessDetailBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QHWStudyModel : QHWMainBusinessDetailBaseModel

@property (nonatomic, copy) NSString *subtitle;
///洲唯一标识
@property (nonatomic, copy) NSString *tripEndDate;
@property (nonatomic, copy) NSString *tripStartDate;
@property (nonatomic, copy) NSString *entryEndDate;
///洲唯一标识
@property (nonatomic, copy) NSString *studyContinentId;
@property (nonatomic, copy) NSString *studyContinentName;
@property (nonatomic, copy) NSString *studyCity;
@property (nonatomic, copy) NSString *studyCityName;
@property (nonatomic, copy) NSString *studyCountry;
@property (nonatomic, copy) NSString *studyCountryName;
///行程天数
@property (nonatomic, assign) NSInteger tripDays;
///出发城市数据集
@property (nonatomic, strong) NSArray *departureCityList;
@property (nonatomic, copy) NSString *departureCityName;

@property (nonatomic, strong) NSArray *studyThemeList;
@property (nonatomic, copy) NSString *studyThemeName;

@property (nonatomic, strong) NSArray *studentObjectList;
@property (nonatomic, copy) NSString *studentObjectName;

@property (nonatomic, strong) NSArray *labelList;

///服务费（单位分 ps:展示单位万）
@property (nonatomic, assign) long price;
@property (nonatomic, assign) double areaMin;
@property (nonatomic, assign) double areaMax;

@property (nonatomic, assign) NSInteger ageMin;
@property (nonatomic, assign) NSInteger ageMax;

///详细行程数据集合
@property (nonatomic, strong) NSArray *tripDescribeList;
///费用说明
@property (nonatomic, copy) NSString *costDescribe;
///行前准备
@property (nonatomic, copy) NSString *tripReady;
///常见问题
@property (nonatomic, copy) NSString *commonProblem;

@end

NS_ASSUME_NONNULL_END
