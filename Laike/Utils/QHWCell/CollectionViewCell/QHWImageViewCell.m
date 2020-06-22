//
//  QHWImageViewCell.m
//  GoOverSeas
//
//  Created by xiaobu on 2019/7/11.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "QHWImageViewCell.h"

@implementation QHWImageViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self.centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.imgView);
        }];
        [self.playImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50, 50));
            make.center.mas_equalTo(self.contentView);
        }];
    }
    return self;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = UIImageView.ivInit().ivBkgColor(kColorThemef5f5f5);
        _imgView.layer.masksToBounds = YES;
        [self.contentView addSubview:_imgView];
    }
    return _imgView;
}

- (UIView *)centerView {
    if (!_centerView) {
        _centerView = UIView.viewInit().bkgColor([UIColor colorWithWhite:0.0 alpha:0.5]);
        [self.imgView addSubview:_centerView];
        _centerView.hidden = YES;
    }
    return _centerView;
}

- (UIImageView *)playImageView {
    if (!_playImageView) {
        _playImageView = UIImageView.ivInit().ivImage(kImageMake(@"video_play"));
        _playImageView.hidden = YES;
        [self.contentView addSubview:_playImageView];
    }
    return _playImageView;
}

- (UILabel *)centerLabel {
    if (!_centerLabel) {
        _centerLabel = UILabel.labelInit().labelBkgColor([UIColor colorWithWhite:0.0 alpha:0.5]).labelFont([UIFont systemFontOfSize:30 weight:UIFontWeightMedium]).labelTitleColor(kColorThemefff).labelTextAlignment(NSTextAlignmentCenter);
        _centerLabel.hidden = YES;
        [self.imgView addSubview:_centerLabel];
    }
    return _centerLabel;
}

@end
