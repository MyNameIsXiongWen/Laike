//
//  QHWConsultantModel.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/15.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWConsultantModel.h"

@implementation QHWConsultantModel

- (CGFloat)industryNameWidth {
    if (!_industryNameWidth) {
        NSString *nameString = kFormat(@" %@    ", self.industryName);
        _industryNameWidth = [nameString getWidthWithFont:kFontTheme14 constrainedToSize:CGSizeMake(200, 20)];
    }
    return _industryNameWidth;
}

@end
