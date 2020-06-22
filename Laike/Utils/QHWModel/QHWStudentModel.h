//
//  QHWStudentModel.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/20.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWMainBusinessDetailBaseModel.h"
#import "QHWSchoolModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QHWStudentModel : QHWMainBusinessDetailBaseModel

@property (nonatomic, copy) NSString *subtitle;
///洲唯一标识
@property (nonatomic, copy) NSString *continentId;
@property (nonatomic, copy) NSString *continentName;
@property (nonatomic, copy) NSString *countryId;
@property (nonatomic, copy) NSString *countryName;
@property (nonatomic, copy) NSString *typeName;

///学历阶段List(1-初中；2-高中；3-本科；4-硕士；5-博士；6-其他)
@property (nonatomic, strong) NSArray *educationList;
@property (nonatomic, copy) NSString *educationString;
@property (nonatomic, strong) NSArray *labelList;

///是否包括第三方费用：1-不包括；2-包括
@property (nonatomic, assign) NSInteger feesStatus;
@property (nonatomic, copy) NSString *feesStatusName;
///收费模式:1-一次性付费；2-分阶段付费
@property (nonatomic, assign) NSInteger feesMode;
@property (nonatomic, copy) NSString *feesModeName;
///服务费（单位分 ps:展示单位万）
@property (nonatomic, assign) double serviceFee;
///申请周期（单位月）
@property (nonatomic, assign) NSInteger applyCycle;

@property (nonatomic, strong) NSArray <QHWSchoolModel *>*likeList;
@property (nonatomic, strong) NSArray *groupList;

@property (nonatomic, copy) NSString *serviceContent;
@property (nonatomic, copy) NSString *serviceFeature;
@property (nonatomic, copy) NSString *remind;
@property (nonatomic, copy) NSString *serviceProcess;
@property (nonatomic, copy) NSString *costDescribe;
@property (nonatomic, copy) NSString *teamDescribe;
@property (nonatomic, copy) NSString *successCase;
@property (nonatomic, copy) NSString *commonProblem;

@end

NS_ASSUME_NONNULL_END
