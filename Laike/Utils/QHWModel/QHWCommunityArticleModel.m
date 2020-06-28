//
//  QHWCommunityArticleModel.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/16.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWCommunityArticleModel.h"

@implementation QHWCommunityArticleModel

- (CGFloat)titleHeight {
    if (!_titleHeight) {
        _titleHeight = MAX(20, [self.name getHeightWithFont:[UIFont systemFontOfSize:15 weight:UIFontWeightMedium] constrainedToSize:CGSizeMake(kScreenW-30, CGFLOAT_MAX)]);
    }
    return _titleHeight;
}

- (CGFloat)cellHeight {
    if (!_cellHeight) {
        _cellHeight = 30+30;
        if (self.coverPathList.count == 0) {
            _cellHeight += self.titleHeight + 15 + 20;
        } else if (self.coverPathList.count < 3) {
            _cellHeight += 70;
        } else {
            _cellHeight += self.titleHeight + 15 + (kScreenW-40)/3 + 15 + 17;
        }
    }
    return ceil(_cellHeight);
}

@end
