//
//  CRMDetailHeaderView.m
//  Laike
//
//  Created by xiaobu on 2020/7/2.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "CRMDetailHeaderView.h"
#import "QHWTagView.h"

@interface CRMDetailHeaderView ()

@property (nonatomic, strong) UIImageView *avatarImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) QHWTagView *tagView;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UILabel *remarkKeyLabel;
@property (nonatomic, strong) UILabel *remarkValueLabel;
@property (nonatomic, strong) UILabel *intentionKeyLabel;
@property (nonatomic, strong) UILabel *intentionBusinessValueLabel;
@property (nonatomic, strong) UILabel *intentionCountryValueLabel;

@end

@implementation CRMDetailHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self.avatarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(35);
            make.size.mas_equalTo(CGSizeMake(64, 64));
        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatarImgView.mas_right).offset(20);
            make.top.equalTo(self.avatarImgView.mas_top);
            make.right.mas_equalTo(-15);
        }];
        [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.mas_left);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(18);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(7);
        }];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
            make.top.equalTo(self.avatarImgView.mas_bottom).offset(40);
        }];
        [self.remarkKeyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(22);
            make.top.equalTo(self.line.mas_bottom).offset(13);
        }];
        [self.remarkValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.top.equalTo(self.remarkKeyLabel.mas_bottom).offset(5);
        }];
        [self.intentionKeyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.top.equalTo(self.remarkValueLabel.mas_bottom).offset(15);
        }];
        [self.intentionBusinessValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.top.equalTo(self.intentionKeyLabel.mas_bottom).offset(5);
        }];
        [self.intentionCountryValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.top.equalTo(self.intentionBusinessValueLabel.mas_bottom).offset(5);
        }];
    }
    return self;
}

- (void)setCrmModel:(CRMModel *)crmModel {
    _crmModel = crmModel;
    if (crmModel.headPath.length > 0) {
        [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(crmModel.headPath)]];
    } else {
        self.avatarImgView.image = [UIImage imageWithColor:kColorThemefff size:CGSizeMake(50, 50) text:crmModel.realName textAttributes:@{NSForegroundColorAttributeName: kColorTheme21a8ff, NSFontAttributeName: kMediumFontTheme18} circular:YES];
    }
    self.nameLabel.text = crmModel.realName;
    [self.tagView setTagWithTagArray:crmModel.industryNameArray];
    self.remarkValueLabel.text = crmModel.note ?: @"暂无";
    self.intentionBusinessValueLabel.text = crmModel.industryStr;
    self.intentionCountryValueLabel.text = crmModel.countryStr;
}

#pragma mark ------------UI-------------
- (UIImageView *)avatarImgView {
    if (!_avatarImgView) {
        _avatarImgView = UIImageView.ivInit().ivCornerRadius(32).ivBorderColor(kColorTheme21a8ff);
        [self addSubview:_avatarImgView];
    }
    return _avatarImgView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = UILabel.labelInit().labelFont(kFontTheme24).labelTitleColor(kColorTheme000);
        [self addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (QHWTagView *)tagView {
    if (!_tagView) {
        _tagView = [[QHWTagView alloc] initWithFrame:CGRectZero];
        [self addSubview:_tagView];
    }
    return _tagView;
}

- (UIView *)line {
    if (!_line) {
        _line = UIView.viewInit().bkgColor(kColorThemeeee);
        [self addSubview:_line];
    }
    return _line;
}

- (UILabel *)remarkKeyLabel {
    if (!_remarkKeyLabel) {
        _remarkKeyLabel = UILabel.labelInit().labelText(@"客户备注").labelFont(kFontTheme16).labelTitleColor(kColorTheme000);
        [self addSubview:_remarkKeyLabel];
    }
    return _remarkKeyLabel;
}

- (UILabel *)remarkValueLabel {
    if (!_remarkValueLabel) {
        _remarkValueLabel = UILabel.labelInit().labelText(@"暂无").labelFont(kFontTheme14).labelTitleColor(kColorThemea4abb3).labelNumberOfLines(0);
        [self addSubview:_remarkValueLabel];
    }
    return _remarkValueLabel;
}

- (UILabel *)intentionKeyLabel {
    if (!_intentionKeyLabel) {
        _intentionKeyLabel = UILabel.labelInit().labelText(@"客户意向").labelFont(kFontTheme16).labelTitleColor(kColorTheme000);
        [self addSubview:_intentionKeyLabel];
    }
    return _intentionKeyLabel;
}

- (UILabel *)intentionBusinessValueLabel {
    if (!_intentionBusinessValueLabel) {
        _intentionBusinessValueLabel = UILabel.labelInit().labelText(@"业务：暂无").labelFont(kFontTheme14).labelTitleColor(kColorThemea4abb3).labelNumberOfLines(0);
        [self addSubview:_intentionBusinessValueLabel];
    }
    return _intentionBusinessValueLabel;
}

- (UILabel *)intentionCountryValueLabel {
    if (!_intentionCountryValueLabel) {
        _intentionCountryValueLabel = UILabel.labelInit().labelText(@"国家：暂无").labelFont(kFontTheme14).labelTitleColor(kColorThemea4abb3).labelNumberOfLines(0);
        [self addSubview:_intentionCountryValueLabel];
    }
    return _intentionCountryValueLabel;
}

@end
