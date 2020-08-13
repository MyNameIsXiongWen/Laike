//
//  CRMTableViewCell.m
//  Laike
//
//  Created by xiaobu on 2020/6/23.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "CRMTableViewCell.h"

@implementation CRMTableViewCell

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
            make.left.top.mas_equalTo(15);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatarImgView.mas_right).offset(15);
            make.top.equalTo(self.avatarImgView.mas_top).offset(5);
            make.right.mas_equalTo(-15);
        }];
        [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.mas_left);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(18);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(2);
        }];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.mas_left);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(18);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(2);
        }];
        [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(20);
            make.top.mas_equalTo(30);
        }];
        [self.contactBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(100, 40));
        }];
        [self.convertBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contactBtn.mas_centerY);
            make.right.equalTo(self.contactBtn.mas_left);
            make.size.equalTo(self.contactBtn);
        }];
        UIView *line1 = UIView.viewInit().bkgColor(kColorThemeeee);
        [self.contentView addSubview:line1];
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.mas_left);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
            make.bottom.mas_equalTo(-40);
        }];
        UIView *line2 = UIView.viewInit().bkgColor(kColorThemeeee);
        [self.contentView addSubview:line2];
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        
    }
    return self;
}

- (void)clickConvertBtn {
    if (self.clickConvertBlock) {
        self.clickConvertBlock();
    }
}

- (void)clickContactBtn {
    if (self.clickContactBlock) {
        self.clickContactBlock();
    }
}

#pragma mark ------------UI-------------
- (UIImageView *)avatarImgView {
    if (!_avatarImgView) {
        _avatarImgView = UIImageView.ivInit().ivCornerRadius(25).ivBorderColor(kColorTheme21a8ff);
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

- (QHWTagView *)tagView {
    if (!_tagView) {
        _tagView = [[QHWTagView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_tagView];
    }
    return _tagView;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = UILabel.labelInit().labelFont(kFontTheme14).labelTitleColor(kColorTheme2a303c);
        _countLabel.hidden = YES;
        [self.contentView addSubview:_countLabel];
    }
    return _countLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = UILabel.labelInit().labelFont(kFontTheme12).labelTitleColor(kColorTheme666);
        _timeLabel.hidden = YES;
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}

- (UIButton *)convertBtn {
    if (!_convertBtn) {
        _convertBtn = UIButton.btnInit().btnTitleColor(kColorTheme21a8ff).btnSelectedTitle(@"已转客户").btnSelectedTitleColor(kColorThemea4abb3).btnFont(kMediumFontTheme14).btnAction(self, @selector(clickConvertBtn));
        [self.contentView addSubview:_convertBtn];
    }
    return _convertBtn;
}

- (UIButton *)contactBtn {
    if (!_contactBtn) {
        _contactBtn = UIButton.btnInit().btnTitleColor(kColorTheme21a8ff).btnFont(kMediumFontTheme14).btnTitle(@"联系客户").btnAction(self, @selector(clickContactBtn));
        [self.contentView addSubview:_contactBtn];
    }
    return _contactBtn;
}

@end
