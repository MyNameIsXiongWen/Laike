//
//  QHWStudentModel.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/20.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWStudentModel.h"
#import "QHWActivityModel.h"

@implementation QHWStudentModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"consultantList": QHWConsultantModel.class,
             @"activityList": QHWActivityModel.class,
             @"likeList": QHWSchoolModel.class,
             @"bottomData": QHWBottomUserModel.class,
             @"brandData": BrandModel.class
             };
}

- (NSString *)educationString {
    NSMutableArray *tempArray = NSMutableArray.array;
    for (NSDictionary *dic in self.educationList) {
        [tempArray addObject:dic[@"name"]];
    }
    return [tempArray componentsJoinedByString:@"/"];
}

@end
