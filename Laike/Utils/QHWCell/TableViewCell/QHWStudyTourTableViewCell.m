//
//  QHWStudyTourTableViewCell.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/14.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWStudyTourTableViewCell.h"

@implementation QHWStudyTourTableViewCell

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
        [self.studytourImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(105, 105));
//            make.centerY.equalTo(self.contentView);
        }];
        [self.studytourTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.studytourImgView.mas_right).offset(10);
            make.right.mas_equalTo(-15);
            make.top.equalTo(self.studytourImgView.mas_top);
        }];
        [self.studytourTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.studytourImgView.mas_right).offset(10);
            make.bottom.equalTo(self.studytourImgView.mas_bottom);
        }];
        [self.studytourMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.studytourTagLabel.mas_right).offset(5);
            make.bottom.equalTo(self.studytourImgView.mas_bottom);
        }];
        [self.studytourTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.studytourMoneyLabel.mas_right).offset(5);
            make.height.mas_equalTo(20);
            make.bottom.equalTo(self.studytourImgView.mas_bottom);
        }];
    }
    return self;
}

- (UIImageView *)studytourImgView {
    if (!_studytourImgView) {
        _studytourImgView = UIImageView.ivInit().ivCornerRadius(2);
        [self.contentView addSubview:_studytourImgView];
    }
    return _studytourImgView;
}

- (UILabel *)studytourTitleLabel {
    if (!_studytourTitleLabel) {
        _studytourTitleLabel = UILabel.labelInit().labelTitleColor(kColorTheme2a303c).labelFont(kFontTheme15).labelNumberOfLines(0);
        [self.contentView addSubview:_studytourTitleLabel];
    }
    return _studytourTitleLabel;
}

- (UILabel *)studytourTagLabel {
    if (!_studytourTagLabel) {
        _studytourTagLabel = UILabel.labelInit().labelText(@"价格").labelTitleColor(kColorThemea4abb3).labelFont(kFontTheme14);
        [self.contentView addSubview:_studytourTagLabel];
    }
    return _studytourTagLabel;
}

- (UILabel *)studytourMoneyLabel {
    if (!_studytourMoneyLabel) {
        _studytourMoneyLabel = UILabel.labelInit().labelTitleColor(kColorThemefb4d56).labelFont(kFontTheme14);
        [self.contentView addSubview:_studytourMoneyLabel];
    }
    return _studytourMoneyLabel;
}

- (UILabel *)studytourTimeLabel {
    if (!_studytourTimeLabel) {
        _studytourTimeLabel = UILabel.labelInit().labelTitleColor(kColorTheme5c98f8).labelFont(kFontTheme11).labelTextAlignment(NSTextAlignmentCenter).labelBorderColor(kColorTheme5c98f8).labelCornerRadius(2);
        [self.contentView addSubview:_studytourTimeLabel];
    }
    return _studytourTimeLabel;
}


@end
