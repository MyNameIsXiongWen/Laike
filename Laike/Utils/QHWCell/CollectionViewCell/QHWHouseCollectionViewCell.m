//
//  QHWHouseCollectionViewCell.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/14.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWHouseCollectionViewCell.h"

@implementation QHWHouseCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self.houseImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.contentView);
            make.height.mas_equalTo(160);
        }];
        [self.houseTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(self.houseImgView.mas_bottom).offset(10);
        }];
        [self.houseSubTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(self.houseTitleLabel.mas_bottom).offset(7);
        }];
        [self.houseMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(self.houseSubTitleLabel.mas_bottom).offset(10);
        }];
    }
    return self;
}

- (void)setHouseModel:(QHWHouseModel *)houseModel {
    _houseModel = houseModel;
    [self.houseImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(houseModel.coverPath)] placeholderImage:kPlaceHolderImage_Banner];
    self.houseTitleLabel.text = houseModel.name;
    self.houseSubTitleLabel.text = kFormat(@"%@-%@㎡ | 首付 %@%%", [NSString formatterWithValue:houseModel.areaMin], [NSString formatterWithValue:houseModel.areaMax], [NSString formatterWithValue:houseModel.firstPaymentRate]);
    self.houseMoneyLabel.text = kFormat(@"¥ %@万起", [NSString formatterWithMoneyValue:houseModel.totalPrice]);
}

- (UIImageView *)houseImgView {
    if (!_houseImgView) {
        _houseImgView = UIImageView.ivInit().ivCornerRadius(2);
        [self.contentView addSubview:_houseImgView];
    }
    return _houseImgView;
}

- (UILabel *)houseTitleLabel {
    if (!_houseTitleLabel) {
        _houseTitleLabel = UILabel.labelInit().labelTitleColor(kColorTheme2a303c).labelFont(kFontTheme14);
        [self.contentView addSubview:_houseTitleLabel];
    }
    return _houseTitleLabel;
}

- (UILabel *)houseSubTitleLabel {
    if (!_houseSubTitleLabel) {
        _houseSubTitleLabel = UILabel.labelInit().labelTitleColor(kColorThemea4abb3).labelFont(kFontTheme12);
        [self.contentView addSubview:_houseSubTitleLabel];
    }
    return _houseSubTitleLabel;
}

- (UILabel *)houseMoneyLabel {
    if (!_houseMoneyLabel) {
        _houseMoneyLabel = UILabel.labelInit().labelTitleColor(kColorThemefb4d56).labelFont(kFontTheme12);
        [self.contentView addSubview:_houseMoneyLabel];
    }
    return _houseMoneyLabel;
}

@end
