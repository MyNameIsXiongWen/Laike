//
//  QHWActivityTableViewCell.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/29.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWActivityTableViewCell.h"

@implementation QHWActivityTableViewCell

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
        [self.coverImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(200);
        }];
        [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(45);
            make.left.right.bottom.equalTo(self.coverImgView);
        }];
        [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.centerY.equalTo(self.shadowView);
        }];
        [self.dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(0);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(70);
        }];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.coverImgView.mas_bottom).offset(10);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.equalTo(self.timeLabel.mas_bottom).offset(15);
            make.right.mas_equalTo(-80);
        }];
        [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.mas_right).offset(5);
            make.right.mas_equalTo(-15);
            make.top.equalTo(self.timeLabel.mas_bottom).offset(17);
            make.height.mas_equalTo(25);
        }];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(0.5);
            make.bottom.mas_equalTo(0);
        }];
    }
    return self;
}

- (void)setActivityModel:(QHWActivityModel *)activityModel {
    _activityModel = activityModel;
    [self.coverImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(activityModel.coverPath)] placeholderImage:kPlaceHolderImage_Banner];
    self.nameLabel.text = activityModel.name;
    self.addressLabel.text = activityModel.addres;
    self.timeLabel.text = activityModel.startEnd;
    self.statusLabel.text = activityModel.activityStatusName;
    if (activityModel.activityStatus == 3) {
        self.statusLabel.textColor = kColorThemea4abb3;
        self.statusLabel.labelBorderColor(kColorThemefff);
    } else {
        self.statusLabel.textColor = kColorThemef2a12f;
        self.statusLabel.labelBorderColor(kColorThemef2a12f);
    }
    if (activityModel.startEnd.length > 11) {
        self.dayLabel.text = [activityModel.startEnd substringWithRange:NSMakeRange(5, 6)];
    }
}

#pragma mark ------------UI-------------
- (UIImageView *)coverImgView {
    if (!_coverImgView) {
        _coverImgView = UIImageView.ivInit();
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, kScreenW-30, 200) byRoundingCorners:UIRectCornerTopRight|UIRectCornerTopLeft cornerRadii:CGSizeMake(8, 8)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
        maskLayer.frame = CGRectMake(0, 0, kScreenW-30, 200);
        maskLayer.path = maskPath.CGPath;
        _coverImgView.layer.mask = maskLayer;
        [self.contentView addSubview:_coverImgView];
    }
    return _coverImgView;
}

- (UILabel *)dayLabel {
    if (!_dayLabel) {
        _dayLabel = UILabel.labelInit().labelFont(kFontTheme14).labelTitleColor(kColorThemefff).labelBkgColor(kColorThemefb4d56).labelTextAlignment(NSTextAlignmentCenter);
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 70, 30) byRoundingCorners:UIRectCornerTopLeft cornerRadii:CGSizeMake(8, 8)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
        maskLayer.frame = CGRectMake(0, 0, 70, 30);
        maskLayer.path = maskPath.CGPath;
        _dayLabel.layer.mask = maskLayer;
        [self.coverImgView addSubview:_dayLabel];
    }
    return _dayLabel;
}

- (UIView *)shadowView {
    if (!_shadowView) {
        _shadowView = UIView.viewInit().bkgColor([UIColor colorWithWhite:0.0 alpha:0.3]);
        [self.coverImgView addSubview:self.shadowView];
    }
    return _shadowView;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = UILabel.labelInit().labelFont(kFontTheme14).labelTitleColor(kColorThemefff);
        [self.shadowView addSubview:_addressLabel];
    }
    return _addressLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = UILabel.labelInit().labelFont(kFontTheme13).labelTitleColor(kColorThemefb4d56);
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = UILabel.labelInit().labelFont(kMediumFontTheme16).labelTitleColor(kColorTheme2a303c).labelNumberOfLines(0);
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = UILabel.labelInit().labelFont(kFontTheme12).labelTitleColor(kColorThemea4abb3).labelTextAlignment(NSTextAlignmentCenter).labelCornerRadius(12.5);
        [self.contentView addSubview:_statusLabel];
    }
    return _statusLabel;
}

- (UIView *)line {
    if (!_line) {
        _line = UIView.viewInit().bkgColor(kColorThemeeee);
        [self.contentView addSubview:_line];
    }
    return _line;
}

@end
