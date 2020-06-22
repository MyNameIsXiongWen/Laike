//
//  QHWFiltViewWordCell.m
//  GoOverSeas
//
//  Created by xiaobu on 2019/1/19.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import "QHWFiltViewWordCell.h"

@implementation QHWFiltViewWordCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self.contentView addSubview:self.wordLabel];
    }
    return self;
}

- (UILabel *)wordLabel {
    if (!_wordLabel) {
        _wordLabel = UILabel.labelFrame(self.bounds).labelTitleColor(kColorTheme2a303c).labelFont(kFontTheme12).labelBkgColor(kColorThemefff).labelTextAlignment(NSTextAlignmentCenter);
    }
    return _wordLabel;
}

@end
