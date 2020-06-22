//
//  QHWBrokerCollectionViewCell.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/14.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWBrokerCollectionViewCell.h"

@implementation QHWBrokerCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self.brokerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.mas_equalTo(15);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        [self.brokerTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.equalTo(self.brokerImgView.mas_bottom).offset(10);
        }];
        [self.brokerSubTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.equalTo(self.brokerTitleLabel.mas_bottom).offset(10);
        }];
        [self.brokerTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.height.mas_equalTo(25);
            make.bottom.mas_equalTo(-15);
        }];
    }
    return self;
}

- (UIImageView *)brokerImgView {
    if (!_brokerImgView) {
        _brokerImgView = UIImageView.ivInit().ivCornerRadius(25);
        [self.contentView addSubview:_brokerImgView];
    }
    return _brokerImgView;
}

- (UILabel *)brokerTitleLabel {
    if (!_brokerTitleLabel) {
        _brokerTitleLabel = UILabel.labelInit().labelTitleColor(kColorTheme2a303c).labelFont(kFontTheme14).labelTextAlignment(NSTextAlignmentCenter);
        [self.contentView addSubview:_brokerTitleLabel];
    }
    return _brokerTitleLabel;
}

- (UILabel *)brokerSubTitleLabel {
    if (!_brokerSubTitleLabel) {
        _brokerSubTitleLabel = UILabel.labelInit().labelTitleColor(kColorThemea4abb3).labelFont(kFontTheme12).labelTextAlignment(NSTextAlignmentCenter);
        [self.contentView addSubview:_brokerSubTitleLabel];
    }
    return _brokerSubTitleLabel;
}

- (UILabel *)brokerTagLabel {
    if (!_brokerTagLabel) {
        _brokerTagLabel = UILabel.labelInit().labelTitleColor(kColorThemefff).labelBkgColor((kColorTheme5c98f8)).labelFont(kFontTheme15).labelTextAlignment(NSTextAlignmentCenter).labelCornerRadius(2);
        [self.contentView addSubview:_brokerTagLabel];
    }
    return _brokerTagLabel;
}

@end
