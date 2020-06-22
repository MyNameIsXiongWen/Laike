//
//  QHWConsultantCollectionViewCell.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/14.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWConsultantCollectionViewCell.h"

@implementation QHWConsultantCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self.consultantImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(15);
            make.size.mas_offset(CGSizeMake(50, 50));
            make.centerX.equalTo(self.shadowView);
        }];
        [self.tagImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.consultantImgView.mas_right);
            make.bottom.equalTo(self.consultantImgView.mas_bottom);
            make.width.height.mas_equalTo(15);
        }];
        [self.consultantNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.consultantImgView.mas_bottom).offset(15);
            make.left.mas_offset(10);
            make.right.mas_offset(-10);
        }];
        [self.consultantTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.consultantNameLabel.mas_bottom).offset(5);
            make.left.mas_offset(10);
            make.right.mas_offset(-10);
        }];
        [self.consultantTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_offset(-15);
            make.centerX.equalTo(self.shadowView);
            make.height.mas_offset(20);
        }];
    }
    return self;
}

- (UIImageView *)consultantImgView {
    if (!_consultantImgView) {
        _consultantImgView = UIImageView.ivInit().ivCornerRadius(25).ivMode(UIViewContentModeScaleAspectFit).ivBorderColor(kColorTheme2a303c);
        [self.shadowView addSubview:_consultantImgView];
    }
    return _consultantImgView;
}

- (UIImageView *)tagImgView {
    if (!_tagImgView) {
        _tagImgView = UIImageView.ivInit().ivBkgColor(kColorThemefff).ivCornerRadius(7.5);
        [self.shadowView addSubview:_tagImgView];
    }
    return _tagImgView;
}

- (UILabel *)consultantNameLabel {
    if (!_consultantNameLabel) {
        _consultantNameLabel = UILabel.labelInit().labelTitleColor(kColorTheme000).labelFont(kFontTheme14).labelTextAlignment(NSTextAlignmentCenter);
        [self.shadowView addSubview:_consultantNameLabel];
    }
    return _consultantNameLabel;
}

- (UILabel *)consultantTitleLabel {
    if (!_consultantTitleLabel) {
        _consultantTitleLabel = UILabel.labelInit().labelTitleColor(kColorThemea4abb3).labelFont(kFontTheme12).labelTextAlignment(NSTextAlignmentCenter);
        [self.shadowView addSubview:_consultantTitleLabel];
    }
    return _consultantTitleLabel;
}

- (UILabel *)consultantTagLabel {
    if (!_consultantTagLabel) {
        _consultantTagLabel = UILabel.labelInit().labelTitleColor(kColorThemefff).labelBkgColor(kColorTheme5c98f8).labelFont(kFontTheme14).labelTextAlignment(NSTextAlignmentCenter).labelCornerRadius(2);
        [self.shadowView addSubview:_consultantTagLabel];
    }
    return _consultantTagLabel;
}

@end
