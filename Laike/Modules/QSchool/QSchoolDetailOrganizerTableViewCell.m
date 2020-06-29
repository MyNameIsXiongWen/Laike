//
//  QSchoolDetailOrganizerTableViewCell.m
//  Laike
//
//  Created by xiaobu on 2020/6/29.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QSchoolDetailOrganizerTableViewCell.h"
#import "QHWSchoolModel.h"

@interface QSchoolDetailOrganizerTableViewCell () <QHWBaseCellProtocol>

@property (nonatomic, strong) UIImageView *avatarImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *sloganLabel;
@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation QSchoolDetailOrganizerTableViewCell

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
        [self.avatarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.width.height.mas_equalTo(40);
            make.centerY.equalTo(self.contentView);
        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatarImgView.mas_top).offset(3);
            make.left.equalTo(self.avatarImgView.mas_right).offset(10);
        }];
        [self.sloganLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.mas_left);
            make.right.mas_equalTo(-10);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(2);
        }];
        [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.centerY.equalTo(self.nameLabel.mas_centerY);
        }];
        UIView *line = UIView.viewInit().bkgColor(kColorThemeeee);
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}

- (void)configCellData:(id)data {
    QHWSchoolModel *model = (QHWSchoolModel *)data;
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(model.headPath)]];
    self.nameLabel.text = model.name;
    self.sloganLabel.text = model.slogan;
    self.countLabel.text = kFormat(@"%ld人观看", model.browseCount);
}

- (UIImageView *)avatarImgView {
    if (!_avatarImgView) {
        _avatarImgView = UIImageView.ivInit().ivCornerRadius(20);
        [self.contentView addSubview:_avatarImgView];
    }
    return _avatarImgView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = UILabel.labelInit().labelFont(kMediumFontTheme14).labelTitleColor(kColorTheme2a303c);
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (UILabel *)sloganLabel {
    if (!_sloganLabel) {
        _sloganLabel = UILabel.labelInit().labelFont(kFontTheme11).labelTitleColor(kColorThemea4abb3).labelNumberOfLines(2);
        [self.contentView addSubview:_sloganLabel];
    }
    return _sloganLabel;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = UILabel.labelInit().labelFont(kFontTheme11).labelTitleColor(kColorThemea4abb3);
        [self.contentView addSubview:_countLabel];
    }
    return _countLabel;
}

@end
