//
//  QHWTreatmentModel.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/6/9.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWTreatmentModel.h"
#import "QHWActivityModel.h"

@implementation QHWTreatmentModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"consultantList": QHWConsultantModel.class,
             @"activityList": QHWActivityModel.class,
             @"bottomData": QHWBottomUserModel.class,
             @"brandInfo": BrandModel.class
             };
}

@end
