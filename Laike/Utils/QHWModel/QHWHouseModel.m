//
//  QHWHouseModel.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/18.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWHouseModel.h"
#import "QHWActivityModel.h"

@implementation QHWHouseModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"consultantList": QHWConsultantModel.class,
             @"activityList": QHWActivityModel.class,
             @"alikeList": QHWHouseModel.class,
             @"bottomData": QHWBottomUserModel.class
             };
}

@end
