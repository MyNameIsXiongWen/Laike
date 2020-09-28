//
//  CRMTrackCell.m
//  Laike
//
//  Created by xiaobu on 2020/7/4.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "CRMTrackCell.h"

@implementation CRMTrackCell

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
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(40);
            make.top.mas_equalTo(10);
            make.height.mas_equalTo(20);
        }];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20);
            make.top.mas_equalTo(10);
        }];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_left);
            make.right.mas_equalTo(-20);
//            make.width.mas_lessThanOrEqualTo(kScreenW-40-20);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        }];
        [self.contentLabelView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_left);
            make.right.mas_equalTo(-20);
            make.top.equalTo(self.contentLabel.mas_top);
            make.bottom.equalTo(self.contentLabel.mas_bottom);
            make.height.mas_greaterThanOrEqualTo(15);
        }];
        [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(19);
            make.top.mas_equalTo(0);
            make.width.mas_equalTo(2);
            make.height.mas_equalTo(14);
        }];
        [self.circle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.topLine.mas_centerX);
            make.top.equalTo(self.topLine.mas_bottom);
            make.width.height.mas_equalTo(8);
        }];
        [self.btmLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.topLine.mas_centerX);
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(2);
            make.top.equalTo(self.circle.mas_bottom);
        }];
    }
    return self;
}

- (void)setShowArrowImgView:(BOOL)showArrowImgView {
    [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_lessThanOrEqualTo(kScreenW-40-37);
    }];
    [self.arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentLabel.mas_right).offset(10);
        make.width.mas_equalTo(7);
        make.height.mas_equalTo(15);
        make.top.equalTo(self.contentLabel.mas_top);
    }];
}

- (void)clickContentLabel {
//    if (self.clickContentBlock) {
//        self.clickContentBlock();
//    }
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.labelInit().labelFont(kFontTheme13).labelTitleColor(kColorTheme2a303c);
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = UILabel.labelInit().labelFont(kFontTheme13).labelTitleColor(kColorThemea4abb3).labelTextAlignment(NSTextAlignmentRight);
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = UILabel.labelInit().labelFont(kFontTheme14).labelTitleColor(kColorTheme2a303c).labelNumberOfLines(0);
//        [_contentLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.contentView addSubview:_contentLabel];
    }
    return _contentLabel;
}

- (UIView *)contentLabelView {
    if (!_contentLabelView) {
        _contentLabelView = UIView.viewInit().viewAction(self, @selector(clickContentLabel));
        [self.contentView addSubview:_contentLabelView];
    }
    return _contentLabelView;
}

- (UIView *)circle {
    if (!_circle) {
        _circle = UIView.viewInit().bkgColor(kColorThemeeee).cornerRadius(4);
        [self.contentView addSubview:_circle];
    }
    return _circle;
}

- (UIView *)topLine {
    if (!_topLine) {
        _topLine = UIView.viewInit().bkgColor(kColorThemeeee);
        [self.contentView addSubview:_topLine];
    }
    return _topLine;
}

- (UIView *)btmLine {
    if (!_btmLine) {
        _btmLine = UIView.viewInit().bkgColor(kColorThemeeee);
        [self.contentView addSubview:_btmLine];
    }
    return _btmLine;
}

- (UIImageView *)arrowImgView {
    if (!_arrowImgView) {
        _arrowImgView = UIImageView.ivInit().ivImage(kImageMake(@"arrow_right_gray"));
        [self.contentView addSubview:_arrowImgView];
    }
    return _arrowImgView;
}

@end
