//
//  QHWMainBusinessDetailBaseModel.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/28.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWMainBusinessDetailBaseModel.h"

@implementation QHWMainBusinessDetailBaseModel

- (CGFloat)mainBusinessCellHeight {
    if (!_mainBusinessCellHeight) {
        if (self.businessType == 1) {
            return 110;
        }
        _mainBusinessCellHeight = 280;
        CGFloat width = kScreenW-60;
        _mainBusinessCellHeight += MAX(20, [self.name getHeightWithFont:kMediumFontTheme16 constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)]);
    }
    return _mainBusinessCellHeight;
}


@end
