//
//  QHWStudyModel.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/20.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWStudyModel.h"
#import "QHWActivityModel.h"

@implementation QHWStudyModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"consultantList": QHWConsultantModel.class,
             @"activityList": QHWActivityModel.class,
             @"bottomData": QHWBottomUserModel.class,
             @"brandInfo": BrandModel.class
             };
}

- (NSString *)studyThemeName {
    NSMutableArray *tempArray = NSMutableArray.array;
    for (NSDictionary *dic in self.studyThemeList) {
        [tempArray addObject:dic[@"name"]];
    }
    return [tempArray componentsJoinedByString:@"/"];
}

- (NSString *)departureCityName {
    NSMutableArray *tempArray = NSMutableArray.array;
    for (NSDictionary *dic in self.departureCityList) {
        [tempArray addObject:dic[@"name"]];
    }
    return [tempArray componentsJoinedByString:@"/"];
}

- (NSString *)studentObjectName {
    NSMutableArray *tempArray = NSMutableArray.array;
    for (NSDictionary *dic in self.departureCityList) {
        [tempArray addObject:dic[@"name"]];
    }
    return [tempArray componentsJoinedByString:@"/"];
}

@end
