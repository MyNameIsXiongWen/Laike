//
//  QHWGeneralTableViewCell.m
//  GoOverSeas
//
//  Created by xiaobu on 2019/7/13.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "QHWGeneralTableViewCell.h"
#import "CardService.h"

@interface QHWGeneralTableViewCell ()

@end

@implementation QHWGeneralTableViewCell

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
        [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.size.mas_equalTo(CGSizeMake(26, 26));
            make.centerY.equalTo(self);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(kScreenW - 40);
        }];
        [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.arrowImageView.mas_left).offset(-20);
            make.size.mas_equalTo(CGSizeMake(36, 36));
            make.centerY.equalTo(self);
        }];
        [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(5, 10));
        }];
        [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.arrowImageView.mas_left).offset(-10);
            make.centerY.equalTo(self);
        }];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.height.mas_equalTo(0.5);
            make.right.bottom.mas_equalTo(0);
        }];
    }
    return self;
}

- (void)updateLeftImageViewConstraint:(CGFloat)width {
    self.leftImageView.hidden = NO;
    [self.leftImageView.ivCornerRadius(width/2.0) mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(width);
    }];
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(width+40);
    }];
}

- (void)configCellData:(id)data {
    if ([data isKindOfClass:CardModel.class]) {
        [self updateLeftImageViewConstraint:50];
        CardModel *model = (CardModel *)data;
        [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:kFilePath(model.headPath)]];
        self.titleLabel.text = model.realName;
    }
}

#pragma mark ------------UI-------------
- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = UIImageView.ivInit().ivImage(kImageMake(@"arrow_right_gray"));
        [self.contentView addSubview:_arrowImageView];
    }
    return _arrowImageView;
}

- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = UIImageView.ivInit();
        _leftImageView.hidden = YES;
        [self.contentView addSubview:_leftImageView];
    }
    return _leftImageView;
}

- (UIImageView *)rightImageView {
    if (!_rightImageView) {
        _rightImageView = UIImageView.ivInit().ivCornerRadius(18);
        _rightImageView.hidden = YES;
        [self.contentView addSubview:_rightImageView];
    }
    return _rightImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.labelInit().labelTitleColor(kColorTheme2a303c).labelFont(kFontTheme14);
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = UILabel.labelInit().labelTitleColor(kColorThemea4abb3).labelFont(kFontTheme13);
        [self.contentView addSubview:_subTitleLabel];
    }
    return _subTitleLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = UILabel.labelInit().labelTitleColor(kColorTheme2a303c).labelFont(kFontTheme12).labelNumberOfLines(0);
        [self.contentView addSubview:_detailLabel];
    }
    return _detailLabel;
}

- (UIView *)line {
    if (!_line) {
        _line = UIView.viewInit().bkgColor(kColorThemeeee);
        [self.contentView addSubview:_line];
    }
    return _line;
}

@end
