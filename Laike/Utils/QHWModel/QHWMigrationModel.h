//
//  QHWMigrationModel.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/20.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWMainBusinessDetailBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QHWMigrationModel : QHWMainBusinessDetailBaseModel

///洲唯一标识
@property (nonatomic, copy) NSString *continentId;
@property (nonatomic, copy) NSString *continentName;
@property (nonatomic, copy) NSString *countryId;
@property (nonatomic, copy) NSString *countryName;
///居住要求
@property (nonatomic, copy) NSString *residencyRequirement;
///移民项目
@property (nonatomic, copy) NSString *migrationItem;
///移民类别
@property (nonatomic, strong) NSArray *migrationTypeList;
///身份类型List
@property (nonatomic, strong) NSArray *dentityTypeList;
@property (nonatomic, copy) NSString *dentityTypeName;

///项目介绍
@property (nonatomic, copy) NSString *projectDescribe;
///项目优势
@property (nonatomic, copy) NSString *projectFeature;
///申请条件
@property (nonatomic, copy) NSString *applyCondition;
///申请流程
@property (nonatomic, copy) NSString *applyProcess;
///费用详情
@property (nonatomic, copy) NSString *costDescribe;
///公司优势
@property (nonatomic, copy) NSString *companyFeature;

///币种:1-人民币；2-美元;3-欧元；4-日元；5-澳元；6-加元；7-新西兰元
@property (nonatomic, assign) NSInteger currency;
@property (nonatomic, copy) NSString *currencyName;
@property (nonatomic, copy) NSString *handleCycle;
///咨询量
@property (nonatomic, assign) NSInteger consultCount;

///数据集状态：1-历史数据；2-新数据（默认值：1）
@property (nonatomic, assign) double dataStatus;
///服务费（单位分 ps:展示单位万）
@property (nonatomic, assign) double serviceFee;
///投资额度（单位分ps:展示单位万)
@property (nonatomic, assign) double investmentQuota;

@end

NS_ASSUME_NONNULL_END
