//
//  QHWActivityModel.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/28.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWActivityModel.h"

@implementation QHWActivityModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"bottomData": QHWBottomUserModel.class};
}

- (CGFloat)cellHeight {
    if (!_cellHeight) {
        _cellHeight = 15 + 200 + 10 + 15 + 15 + 15;
        _cellHeight += MAX(25, [self.name getHeightWithFont:kMediumFontTheme16 constrainedToSize:CGSizeMake(kScreenW-30, CGFLOAT_MAX)]);
    }
    return _cellHeight;
}

@end
