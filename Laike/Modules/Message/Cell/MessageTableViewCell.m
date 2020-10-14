//
//  MessageTableViewCell.m
//  GoOverSeas
//
//  Created by xiaobu on 2019/8/10.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "MessageTableViewCell.h"

@implementation MessageTableViewCell

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
        self.contentView.backgroundColor = kColorThemefff;
        [self.logoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.size.mas_equalTo(CGSizeMake(50, 50));
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.logoImgView.mas_right).offset(15);
            make.top.equalTo(self.logoImgView.mas_top);
        }];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.left.equalTo(self.nameLabel.mas_right).offset(15);
            make.top.equalTo(self.nameLabel.mas_top).offset(3);
        }];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.mas_left);
            make.right.mas_equalTo(-15);
            make.bottom.equalTo(self.logoImgView.mas_bottom);
        }];
        [self.ringImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.bottom.mas_equalTo(-15);
            make.size.mas_equalTo(CGSizeMake(15, 20));
        }];
        [self.msgCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(55);
            make.top.mas_equalTo(10);
            make.width.height.mas_equalTo(18);
        }];
        [self.redView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(6);
            make.center.equalTo(self.msgCountLabel);
        }];
        
        [self.contentView addSubview:UIView.viewFrame(CGRectMake(0, 79.5, kScreenW, 0.5)).bkgColor(kColorThemeeee)];
    }
    return self;
}

- (void)layoutSubviews {
    /**自定义设置iOS8-10系统下的左滑删除按钮大小*/
    for (UIView * subView in self.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")]) {
            UIButton * deleteButton = subView.subviews[0];
            [deleteButton setImage:kImageMake(@"message_delete") forState:0];
        }
    }
}

#pragma mark ------------UI-------------
- (UIImageView *)logoImgView {
    if (!_logoImgView) {
        _logoImgView = UIImageView.ivInit().ivCornerRadius(25);
        [self.contentView addSubview:_logoImgView];
    }
    return _logoImgView;
}

- (UIImageView *)ringImgView {
    if (!_ringImgView) {
        _ringImgView = UIImageView.ivInit();
        _ringImgView.hidden = YES;
        [self.contentView addSubview:_ringImgView];
    }
    return _ringImgView;
}

- (UILabel *)centerLabel {
    if (!_centerLabel) {
        _centerLabel = UILabel.labelInit().labelFont(kFontTheme14);
        _centerLabel.hidden = YES;
        [self.contentView addSubview:_centerLabel];
    }
    return _centerLabel;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = UILabel.labelInit().labelFont(kFontTheme16).labelTitleColor(kColorTheme000);
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = UILabel.labelInit().labelFont(kFontTheme14).labelTitleColor(kColorTheme999);
        [self.contentView addSubview:_contentLabel];
    }
    return _contentLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = UILabel.labelInit().labelFont(kFontTheme14).labelTitleColor(kColorTheme444).labelTextAlignment(NSTextAlignmentRight);
        [_timeLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}

- (UILabel *)msgCountLabel {
    if (!_msgCountLabel) {
        _msgCountLabel = UILabel.labelInit().labelFont(kFontTheme11).labelTitleColor(kColorThemefff).labelBkgColor(kColorThemefb4d56).labelCornerRadius(9).labelTextAlignment(NSTextAlignmentCenter);
        _msgCountLabel.hidden = YES;
        [self.contentView addSubview:_msgCountLabel];
    }
    return _msgCountLabel;
}

- (UIView *)redView {
    if (!_redView) {
        _redView = UIView.viewInit().bkgColor(kColorThemefb4d56).cornerRadius(3);
        _redView.hidden = YES;
        [self.contentView addSubview:_redView];
    }
    return _redView;
}

@end
