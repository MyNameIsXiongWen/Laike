//
//  QHWCommentModel.m
//  GoOverSeas
//
//  Created by manku on 2019/8/12.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "QHWCommentModel.h"

@implementation QHWCommentModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list": QHWCommentModel.class};
}

- (CGFloat)cellHeight {
    _cellHeight = 10+30+10;
    _cellHeight += MAX(17, [self.content getHeightWithFont:kFontTheme14 constrainedToSize:CGSizeMake(kScreenW-65, CGFLOAT_MAX)])+10;
    if (!self.isReply) {
        if (self.answerCount > 0) {
            _cellHeight += 30;
        }
    }
    if (self.businessType == 103001) {
        _cellHeight += 15+10;
    }
    return _cellHeight;
}

- (NSMutableArray<QHWCommentModel *> *)list {
    if (!_list) {
        _list = NSMutableArray.array;
    }
    return _list;
}

@end
