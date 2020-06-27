//
//  MyCommentModel.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/23.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "MyCommentModel.h"

@implementation MyCommentModel

- (CGFloat)cellHeight {
    _cellHeight = 10+40+10;
    _cellHeight += MAX(17, [self.displayTitleString getHeightWithFont:kFontTheme14 constrainedToSize:CGSizeMake(kScreenW-30, CGFLOAT_MAX)])+5;
    if (self.deleteStatus == 2) {
        self.title = @"已删除";
    }
    _cellHeight += MAX(17, [self.title getHeightWithFont:kFontTheme14 constrainedToSize:CGSizeMake(kScreenW-30-26, CGFLOAT_MAX)])+14;
    _cellHeight += 15;
    return _cellHeight;
}

//- (CGFloat)contentHeight {
//    if (!_contentHeight) {
//        _contentHeight = MAX(17, [self.title getHeightWithFont:kFontTheme14 constrainedToSize:CGSizeMake(kScreenW-30-26, CGFLOAT_MAX)])+14;
//    }
//    return _contentHeight;
//}

- (NSString *)displayTitleString {
    if (self.commentStatus == 1) {
        _displayTitleString = kFormat(@"评论：%@", self.content);
    } else {
        _displayTitleString = kFormat(@"回复@%@：%@", self.subjectName, self.content);
    }
    return _displayTitleString;
}

- (NSMutableAttributedString *)titleAttrString {
    if (!_titleAttrString) {
        NSString *nameString = kFormat(@"@%@：", self.subjectName);
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:self.displayTitleString];
        [attr addAttributes:@{NSForegroundColorAttributeName: kColorTheme5c98f8} range:[self.displayTitleString rangeOfString:nameString]];
        _titleAttrString = attr;
    }
    return _titleAttrString;
}

@end
