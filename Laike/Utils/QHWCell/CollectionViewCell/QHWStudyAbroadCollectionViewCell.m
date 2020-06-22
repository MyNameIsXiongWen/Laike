//
//  QHWStudyAbroadCollectionViewCell.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/14.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWStudyAbroadCollectionViewCell.h"

@implementation QHWStudyAbroadCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self.studyabroadBkgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        [self.studyabroadCenterImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.mas_equalTo(20);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        [self.studyabroadTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(self.studyabroadCenterImgView.mas_bottom).offset(7);
        }];
    }
    return self;
}

- (UIImageView *)studyabroadBkgImgView {
    if (!_studyabroadBkgImgView) {
        _studyabroadBkgImgView = UIImageView.ivInit().ivCornerRadius(2);
        [self.contentView addSubview:_studyabroadBkgImgView];
    }
    return _studyabroadBkgImgView;
}

- (UIImageView *)studyabroadCenterImgView {
    if (!_studyabroadCenterImgView) {
        _studyabroadCenterImgView = UIImageView.ivInit();
        [self.contentView addSubview:_studyabroadCenterImgView];
    }
    return _studyabroadCenterImgView;
}

- (UILabel *)studyabroadTitleLabel {
    if (!_studyabroadTitleLabel) {
        _studyabroadTitleLabel = UILabel.labelInit().labelTitleColor(kColorThemefff).labelFont(kFontTheme12).labelTextAlignment(NSTextAlignmentCenter);
        [self.contentView addSubview:_studyabroadTitleLabel];
    }
    return _studyabroadTitleLabel;
}

@end
