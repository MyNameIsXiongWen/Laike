//
//  QHWImmigrationCollectionViewCell.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/14.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWImmigrationCollectionViewCell.h"

@implementation QHWImmigrationCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self.immigrationImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        [self.immigrationTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(36);
        }];
    }
    return self;
}

- (UIImageView *)immigrationImgView {
    if (!_immigrationImgView) {
        _immigrationImgView = UIImageView.ivInit().ivCornerRadius(2);
        [self.contentView addSubview:_immigrationImgView];
    }
    return _immigrationImgView;
}

- (UILabel *)immigrationTitleLabel {
    if (!_immigrationTitleLabel) {
        _immigrationTitleLabel = UILabel.labelInit().labelTitleColor(kColorThemefff).labelFont(kFontTheme16).labelBkgColor([UIColor colorWithWhite:0 alpha:0.3]).labelTextAlignment(NSTextAlignmentCenter);
        [self.contentView addSubview:_immigrationTitleLabel];
    }
    return _immigrationTitleLabel;
}

@end
