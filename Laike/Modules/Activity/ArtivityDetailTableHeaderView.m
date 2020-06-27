//
//  ArtivityDetailTableHeaderView.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/30.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "ArtivityDetailTableHeaderView.h"

@interface ArtivityDetailTableHeaderView ()

@property (nonatomic, strong) UIImageView *activityImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *timeImgView;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UIImageView *addressImgView;

@end

@implementation ArtivityDetailTableHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self.activityImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(200);
        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.equalTo(self.activityImgView.mas_bottom).offset(20);
        }];
        [self.timeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.height.width.mas_equalTo(20);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(20);
        }];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.timeImgView.mas_right).offset(5);
            make.right.mas_equalTo(-15);
            make.centerY.equalTo(self.timeImgView.mas_centerY);
        }];
        [self.addressImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.height.width.mas_equalTo(20);
            make.top.equalTo(self.timeImgView.mas_bottom).offset(20);
        }];
        [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.addressImgView.mas_right).offset(5);
            make.right.mas_equalTo(-15);
            make.centerY.equalTo(self.addressImgView.mas_centerY);
        }];
    }
    return self;
}

- (void)setActivityModel:(QHWActivityModel *)activityModel {
    _activityModel = activityModel;
    [self.activityImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(activityModel.coverPath)]];
    self.nameLabel.text = activityModel.name;
    self.timeLabel.text = activityModel.startEnd;
    self.addressLabel.text = activityModel.addres;
}

#pragma mark ------------UI-------------
- (UIImageView *)activityImgView {
    if (!_activityImgView) {
        _activityImgView = UIImageView.ivInit();
        [self addSubview:_activityImgView];
    }
    return _activityImgView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = UILabel.labelInit().labelFont(kFontTheme18).labelTitleColor(kColorTheme2a303c).labelNumberOfLines(0);
        [self addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (UIImageView *)timeImgView {
    if (!_timeImgView) {
        _timeImgView = UIImageView.ivInit().ivImage(kImageMake(@"global_time"));
        [self addSubview:_timeImgView];
    }
    return _timeImgView;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = UILabel.labelInit().labelFont(kFontTheme16).labelTitleColor(kColorTheme2a303c).labelNumberOfLines(0);
        [self addSubview:_timeLabel];
    }
    return _timeLabel;
}

- (UIImageView *)addressImgView {
    if (!_addressImgView) {
        _addressImgView = UIImageView.ivInit().ivImage(kImageMake(@"global_location_gray"));
        [self addSubview:_addressImgView];
    }
    return _addressImgView;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = UILabel.labelInit().labelFont(kFontTheme16).labelTitleColor(kColorTheme2a303c).labelNumberOfLines(0);
        [self addSubview:_addressLabel];
    }
    return _addressLabel;
}

@end
