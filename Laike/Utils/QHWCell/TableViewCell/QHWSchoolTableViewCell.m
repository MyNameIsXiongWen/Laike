//
//  QHWSchoolTableViewCell.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/28.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWSchoolTableViewCell.h"

@implementation QHWSchoolTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.schoolImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(15);
            make.size.mas_equalTo(CGSizeMake(90, 90));
        }];
        [self.schoolCNTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.schoolImgView.mas_right).offset(10);
            make.right.mas_equalTo(-15);
            make.top.equalTo(self.schoolImgView.mas_top);
        }];
        [self.schoolENTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.schoolCNTitleLabel.mas_left);
            make.right.mas_equalTo(-15);
            make.top.equalTo(self.schoolCNTitleLabel.mas_bottom).offset(5);
        }];
        [self.countryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.schoolCNTitleLabel.mas_left);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(16);
            make.top.equalTo(self.schoolENTitleLabel.mas_bottom).offset(5);
        }];
        [self.rateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.schoolCNTitleLabel.mas_left);
            make.right.mas_equalTo(-15);
            make.bottom.equalTo(self.countryLabel.mas_bottom);
        }];
        [self.rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.equalTo(self.rateLabel.mas_centerY);
        }];
    }
    return self;
}

//- (void)setHouseModel:(QHWHouseModel *)houseModel {
//    _houseModel = houseModel;
//    [self.houseImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(houseModel.coverPath)] placeholderImage:kPlaceHolderImage_Banner];
//    self.houseTitleLabel.text = houseModel.name;
//    self.houseSubTitleLabel.text = kFormat(@"%.f-%.f㎡ | 首付 %.f%%", houseModel.areaMin, houseModel.areaMax, houseModel.firstPaymentRate);
//    self.houseMoneyLabel.text = kFormat(@"¥ %.f万起", houseModel.totalPrice/1000000);
//    self.addressLabel.text = kFormat(@"%@ • %@", houseModel.countryName, houseModel.cityName);
//    [self.tagView setTagWithTagArray:houseModel.labelList];
//}

- (UIImageView *)schoolImgView {
    if (!_schoolImgView) {
        _schoolImgView = UIImageView.ivInit().ivCornerRadius(5).ivBorderColor(kColorThemeeee);
        [self.contentView addSubview:_schoolImgView];
    }
    return _schoolImgView;
}

- (UILabel *)schoolCNTitleLabel {
    if (!_schoolCNTitleLabel) {
        _schoolCNTitleLabel = UILabel.labelInit().labelTitleColor(kColorTheme2a303c).labelFont([UIFont systemFontOfSize:14 weight:UIFontWeightMedium]);
        [self.contentView addSubview:_schoolCNTitleLabel];
    }
    return _schoolCNTitleLabel;
}

- (UILabel *)schoolENTitleLabel {
    if (!_schoolENTitleLabel) {
        _schoolENTitleLabel = UILabel.labelInit().labelTitleColor(kColorTheme2a303c).labelFont(kFontTheme12);
        [self.contentView addSubview:_schoolENTitleLabel];
    }
    return _schoolENTitleLabel;
}

- (UILabel *)countryLabel {
    if (!_countryLabel) {
        _countryLabel = UILabel.labelInit().labelTitleColor(kColorTheme2a303c).labelFont(kFontTheme12);
        [self.contentView addSubview:_countryLabel];
    }
    return _countryLabel;
}

- (UILabel *)rateLabel {
    if (!_rateLabel) {
        _rateLabel = UILabel.labelInit().labelTitleColor(kColorThemeed2530).labelFont(kFontTheme14);
        [self.contentView addSubview:_rateLabel];
    }
    return _rateLabel;
}

- (UILabel *)rankLabel {
    if (!_rankLabel) {
        _rankLabel = UILabel.labelInit().labelTitleColor(kColorTheme8a90a6).labelFont(kFontTheme14).labelTextAlignment(NSTextAlignmentRight);
        [self.contentView addSubview:_rankLabel];
    }
    return _rankLabel;
}

@end
