//
//  ActivityDetailOrganizerTableViewCell.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/30.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "ActivityDetailOrganizerTableViewCell.h"

@interface ActivityDetailOrganizerTableViewCell () <QHWBaseCellProtocol>

@property (nonatomic, strong) UIImageView *avatarImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *infoLabel;

@end

@implementation ActivityDetailOrganizerTableViewCell

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
            make.left.mas_equalTo(15);
            make.width.height.mas_equalTo(40);
            make.top.mas_equalTo(0);
        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(70);
            make.centerY.equalTo(self.avatarImgView.mas_centerY);
        }];
        [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.equalTo(self.avatarImgView.mas_bottom).offset(15);
        }];
    }
    return self;
}

- (void)configCellData:(id)data {
    _activityModel = (QHWActivityModel *)data;
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(_activityModel.mainHead)]];
    self.nameLabel.text = _activityModel.mainName;
    self.infoLabel.text = _activityModel.mainDescribe;
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
        _nameLabel = UILabel.labelInit().labelFont(kMediumFontTheme16).labelTitleColor(kColorTheme2a303c);
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = UILabel.labelInit().labelFont(kFontTheme14).labelTitleColor(kColorTheme6d7278).labelNumberOfLines(0);
        [self.contentView addSubview:_infoLabel];
    }
    return _infoLabel;
}

@end
