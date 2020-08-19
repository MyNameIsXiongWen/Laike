//
//  AdvisoryDetailHeaderView.m
//  Laike
//
//  Created by xiaobu on 2020/7/4.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "AdvisoryDetailHeaderView.h"
#import "QHWTagView.h"

@interface AdvisoryDetailHeaderView ()

@property (nonatomic, strong) UIImageView *avatarImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) QHWTagView *tagView;
@property (nonatomic, strong) UIView *firstLine;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *secondLine;

@end

@implementation AdvisoryDetailHeaderView

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
//            make.top.equalTo(self.avatarImgView.mas_top);
            make.centerY.equalTo(self.avatarImgView.mas_centerY);
            make.right.mas_equalTo(-15);
        }];
//        [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.nameLabel.mas_left);
//            make.right.mas_equalTo(-15);
//            make.height.mas_equalTo(18);
//            make.top.equalTo(self.nameLabel.mas_bottom).offset(7);
//        }];
        [self.firstLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
            make.top.equalTo(self.avatarImgView.mas_bottom).offset(40);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(40);
            make.top.equalTo(self.firstLine.mas_bottom);
        }];
        [self.secondLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
            make.top.equalTo(self.titleLabel.mas_bottom);
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
//    [self.tagView setTagWithTagArray:crmModel.industryNameArray];
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

- (UIView *)firstLine {
    if (!_firstLine) {
        _firstLine = UIView.viewInit().bkgColor(kColorThemeeee);
        [self addSubview:_firstLine];
    }
    return _firstLine;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.labelInit().labelFont(kFontTheme16).labelTitleColor(kColorTheme000).labelText(@"咨询记录");
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIView *)secondLine {
    if (!_secondLine) {
        _secondLine = UIView.viewInit().bkgColor(kColorThemeeee);
        [self addSubview:_secondLine];
    }
    return _secondLine;
}

@end
