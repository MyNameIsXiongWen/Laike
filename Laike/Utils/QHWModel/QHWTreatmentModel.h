//
//  QHWTreatmentModel.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/6/9.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWMainBusinessDetailBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QHWTreatmentModel : QHWMainBusinessDetailBaseModel

///洲唯一标识
@property (nonatomic, copy) NSString *continentId;
@property (nonatomic, copy) NSString *continentName;
@property (nonatomic, copy) NSString *countryId;
@property (nonatomic, copy) NSString *countryName;
@property (nonatomic, copy) NSString *subtitle;

///医疗类型List（1-体检筛查；2-远程会诊；3-辅助生殖；4-疫苗；5-重疾治疗；6-医疗美容；7-医疗观光；）
@property (nonatomic, strong) NSArray *treatmentTypeList;
@property (nonatomic, strong) NSArray *labelList;

///商品内容
@property (nonatomic, copy) NSString *goodsContent;
///成功案例
@property (nonatomic, copy) NSString *successCase;

///服务费（单位分 ps:展示单位万）
@property (nonatomic, assign) double serviceFee;

@end

NS_ASSUME_NONNULL_END
