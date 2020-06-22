//
//  QHWSchoolCollectionViewCell.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/14.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWSchoolCollectionViewCell.h"

@implementation QHWSchoolCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self.schoolImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.contentView);
            make.height.mas_equalTo(90);
        }];
        [self.schoolTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            make.top.equalTo(self.schoolImgView.mas_bottom);
        }];
    }
    return self;
}

- (UIImageView *)schoolImgView {
    if (!_schoolImgView) {
        _schoolImgView = UIImageView.ivInit().ivCornerRadius(2).ivBorderColor(kColorThemee4e4e4);
        [self.contentView addSubview:_schoolImgView];
    }
    return _schoolImgView;
}

- (UILabel *)schoolTitleLabel {
    if (!_schoolTitleLabel) {
        _schoolTitleLabel = UILabel.labelInit().labelTitleColor(kColorTheme000).labelFont(kFontTheme16).labelTextAlignment(NSTextAlignmentCenter);
        [self.contentView addSubview:_schoolTitleLabel];
    }
    return _schoolTitleLabel;
}

@end
