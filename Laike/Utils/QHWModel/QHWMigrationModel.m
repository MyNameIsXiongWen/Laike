//
//  QHWMigrationModel.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/20.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWMigrationModel.h"
#import "QHWActivityModel.h"

@implementation QHWMigrationModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"consultantList": QHWConsultantModel.class,
             @"activityList": QHWActivityModel.class,
             @"bottomData": QHWBottomUserModel.class,
             @"brandData": BrandModel.class
             };
}

- (NSString *)dentityTypeName {
    NSMutableArray *tempArray = NSMutableArray.array;
    for (NSDictionary *dic in self.dentityTypeList) {
        [tempArray addObject:dic[@"name"]];
    }
    return [tempArray componentsJoinedByString:@"/"];
}

- (CGFloat)mainBusinessCellHeight {
    CGFloat height = 280;
    NSString *nameString = kFormat(@"%@+%@", self.migrationItem, self.name);
    height += MAX(20, [nameString getHeightWithFont:kMediumFontTheme16 constrainedToSize:CGSizeMake(kScreenW-60-80, CGFLOAT_MAX)]);
    return height;
}

@end
