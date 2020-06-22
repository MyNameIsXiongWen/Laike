//
//  QHWCommunityContentModel.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/16.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWCommunityContentModel.h"

@implementation QHWCommunityContentModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"subjectData": QHWBottomUserModel.class};
}

- (NSString *)commentStr {
    return [NSString dealWithNumberValue:self.commentCount];
}

- (NSString *)collectionStr {
    return [NSString dealWithNumberValue:self.collectionCount];
}

- (NSString *)likeStr {
    return [NSString dealWithNumberValue:self.likeCount];
}

- (NSString *)shareStr{
    return [NSString dealWithNumberValue:self.shareCount];
}

- (CGFloat)cellHeight {
    if (!_cellHeight) {
        _cellHeight = 60;
        _cellHeight += [self.title getHeightWithFont:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium] constrainedToSize:CGSizeMake(kScreenW-30, 35)]+10;
//        if (self.content.length > 0) {
            _cellHeight += [self.content getHeightWithFont:kFontTheme14 constrainedToSize:CGSizeMake(kScreenW-30, 35)]+10;
//        }
        if (self.filePathList.count > 0) {
            _cellHeight += (kScreenW-40)/3+10;
        }
        _cellHeight += 25;
    }
    return ceil(_cellHeight);
}

@end
