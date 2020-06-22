//
//  RelatedToMeTableViewCell.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/25.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "RelatedToMeTableViewCell.h"

@implementation RelatedToMeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.avtarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(10);
            make.width.height.mas_equalTo(40);
        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avtarImgView.mas_right).offset(10);
            make.top.equalTo(self.avtarImgView.mas_top);
        }];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.mas_right).offset(15);
            make.right.mas_equalTo(-15);
            make.centerY.equalTo(self.nameLabel);
        }];
        [self.originalContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.mas_left);
            make.right.mas_equalTo(-15);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(7);
            make.bottom.mas_equalTo(-40);
        }];
        [self.originalContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(13);
            make.right.mas_equalTo(-13);
            make.top.mas_equalTo(7);
            make.bottom.mas_equalTo(-7);
        }];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.mas_left);
            make.right.mas_equalTo(-15);
            make.top.equalTo(self.originalContentView.mas_bottom).offset(8);
        }];
        UIView *line = UIView.viewInit().bkgColor(kColorThemeeee);
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(5);
        }];
    }
    return self;
}

#pragma mark -----------UI-----------
- (UIImageView *)avtarImgView {
    if (!_avtarImgView) {
        _avtarImgView = UIImageView.ivInit().ivCornerRadius(20);
        [self.contentView addSubview:_avtarImgView];
    }
    return _avtarImgView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = UILabel.labelInit().labelFont(kFontTheme16).labelTitleColor(kColorTheme2a303c);
        [_nameLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = UILabel.labelInit().labelFont(kFontTheme16).labelTitleColor(kColorTheme2a303c);
        [self.contentView addSubview:_contentLabel];
    }
    return _contentLabel;
}

- (UIView *)originalContentView {
    if (!_originalContentView) {
        _originalContentView = UIView.viewInit().bkgColor(kColorThemef5f5f5).cornerRadius(5);
        [self.contentView addSubview:_originalContentView];
    }
    return _originalContentView;
}

- (UILabel *)originalContentLabel {
    if (!_originalContentLabel) {
        _originalContentLabel = UILabel.labelInit().labelFont(kFontTheme14).labelTitleColor(kColorTheme666);
        [self.originalContentView addSubview:_originalContentLabel];
    }
    return _originalContentLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = UILabel.labelInit().labelFont(kFontTheme12).labelTitleColor(kColorTheme9399a5);
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}

@end
