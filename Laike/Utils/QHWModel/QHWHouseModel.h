//
//  QHWHouseModel.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/18.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWMainBusinessDetailBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QHWHouseModel : QHWMainBusinessDetailBaseModel

@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, copy) NSString *cityId;
@property (nonatomic, copy) NSString *countryName;
@property (nonatomic, strong) NSArray *coverPathList;

@property (nonatomic, assign) double areaMin;
@property (nonatomic, assign) double areaMax;
@property (nonatomic, assign) double firstPaymentRate;
///总价（单位分）
@property (nonatomic, assign) double totalPrice;
///总价（美元后端费率除7保留整数）
@property (nonatomic, assign) double totalPrice1;
///单位（美元）
@property (nonatomic, copy) NSString *totalPrice1Unit;
///交房标准：1-精装；2-其他
@property (nonatomic, assign) NSInteger deliveryStandard;
@property (nonatomic, copy) NSString *deliveryStandardName;
@property (nonatomic, copy) NSString *deliveryTime;
///可选户型：1-非复式户型；2-复式户型
@property (nonatomic, assign) NSInteger houseLayout;
///房源类型（ps：0-所有;1-新手房；2-二手房
@property (nonatomic, assign) NSInteger houseResourceType;
@property (nonatomic, copy) NSString *houseType;
@property (nonatomic, copy) NSString *houseTypeName;
@property (nonatomic, strong) NSArray *labelList;
///购房需求
@property (nonatomic, strong) NSArray *buyDemandList;
///可选房型List：1-一室；2-二室；3-三室；4-四室；5-四室以上
@property (nonatomic, strong) NSArray *roomTypeList;
///产权年限（年）
@property (nonatomic, assign) NSInteger propertyYears;
@property (nonatomic, copy) NSString *propertyYearsName;
///年回报率（百分比）
@property (nonatomic, copy) NSString *yearReturnRate;

/*详情所需字端*/

///项目简介
@property (nonatomic, copy) NSString *intro;
///医疗描述
@property (nonatomic, copy) NSString *medicalDescription;
///休闲娱乐
@property (nonatomic, copy) NSString *relaxationRecreation;
///购物描述
@property (nonatomic, copy) NSString *shoppingDescription;
///教育描述
@property (nonatomic, copy) NSString *educationDescription;
///交通描述
@property (nonatomic, copy) NSString *trafficDescription;

///佣金比例
@property (nonatomic, copy) NSString *commissionRate;
///佣金额度
@property (nonatomic, copy) NSString *commissionQuota;
///分销规则
@property (nonatomic, copy) NSString *distributionRules;
///分销手册
@property (nonatomic, copy) NSString *distributionManual;

@property (nonatomic, strong) NSArray <QHWHouseModel *>*alikeList;

@property (nonatomic, strong) NSArray *bathroomConfigList;
@property (nonatomic, strong) NSArray *airConditionerConfigList;
@property (nonatomic, strong) NSArray *parkConfigList;
@property (nonatomic, strong) NSArray *gardenConfigList;
@property (nonatomic, strong) NSArray *kitchenConfigList;

@end

NS_ASSUME_NONNULL_END
