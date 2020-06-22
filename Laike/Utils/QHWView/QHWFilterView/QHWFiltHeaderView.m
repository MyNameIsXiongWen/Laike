
//
//  QHWFiltHeaderView.m
//  GoOverSeas
//
//  Created by xiaobu on 2019/1/19.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import "QHWFiltHeaderView.h"

@implementation QHWFiltHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.labelFrame(CGRectMake(15, 20, kScreenW-30, 25)).labelTitleColor(kColorTheme000).labelFont(kFontTheme18);
    }
    return _titleLabel;
}
@end
