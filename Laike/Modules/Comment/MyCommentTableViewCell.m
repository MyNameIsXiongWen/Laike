//
//  MyCommentTableViewCell.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/23.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "MyCommentTableViewCell.h"
#import "UserModel.h"
#import "CTMediator+ViewController.h"
#import "QHWSystemService.h"

@implementation MyCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.avtarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(10);
            make.width.height.mas_equalTo(40);
        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avtarImgView.mas_right).offset(5);
            make.top.equalTo(self.avtarImgView.mas_top).offset(3);
        }];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.mas_left);
            make.bottom.equalTo(self.avtarImgView.mas_bottom).offset(-3);
        }];
        [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(30);
            make.centerY.equalTo(self.avtarImgView);
        }];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.equalTo(self.avtarImgView.mas_bottom).offset(10);
        }];
        [self.originalContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.equalTo(self.contentLabel.mas_bottom).offset(5);
            make.bottom.mas_equalTo(-15);
        }];
        [self.originalContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(13);
            make.right.mas_equalTo(-13);
            make.top.mas_equalTo(7);
            make.bottom.mas_equalTo(-7);
        }];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGes:)]];
    }
    return self;
}

- (void)longPressGes:(UIGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        if (self.longPressBlock) {
            self.longPressBlock(self.model.id);
        }
    }
}

- (void)setModel:(MyCommentModel *)model {
    _model = model;
    [self.avtarImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(UserModel.shareUser.headPath)]];
    self.nameLabel.text = UserModel.shareUser.realName;
    self.timeLabel.text = model.createTime;
    self.likeButton.selected = (model.likeStatus == 2);
    self.likeButton.btnBadgeLabel.text = kFormat(@"%ld", model.likesCount);
    self.contentLabel.attributedText = model.titleAttrString;
    self.originalContentLabel.text = model.title ?: @" ";
}

#pragma mark - 点击事件
- (void)tapOriginalContentLabel {
    if (self.model.deleteStatus == 2) {
        return;
    }
    if (self.model.commentStatus == 1) {
        [CTMediator.sharedInstance CTMediator_viewControllerForCommunityDetailWithCommunityId:self.model.businessId CommunityType:self.model.businessType];
    } else {
        [CTMediator.sharedInstance CTMediator_viewControllerForCommentReplyWithCommentId:self.model.businessId CommunityType:self.model.businessType];
    }
}

- (void)likeButtonClick:(UIButton *)btn {
//    NSInteger likeStatus = self.model.likeStatus == 1 ? 2 : 1;
//    [QHWSystemService.new clickLikeRequestWithBusinessType:self.model.businessType BusinessId:self.model.id LikeStatus:likeStatus  Complete:^(BOOL status) {
//        if (status) {
//            self.model.likeStatus = likeStatus;
//            if (likeStatus == 2) {
//                self.model.likesCount++;
//            } else {
//                self.model.likesCount--;
//            }
//            self.likeButton.selected = (likeStatus == 2);
//            self.likeButton.btnBadgeLabel.text = kFormat(@"%ld", self.model.likesCount);
//        }
//    }];
}

#pragma mark -----------UI-----------
- (UIImageView *)avtarImgView {
    if (!_avtarImgView) {
        _avtarImgView = UIImageView.ivInit().ivCornerRadius(20);
        [self.contentView addSubview:_avtarImgView];
    }
    return _avtarImgView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = UILabel.labelInit().labelFont(kFontTheme15).labelTitleColor(kColorTheme2a303c);
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = UILabel.labelInit().labelFont(kFontTheme12).labelTitleColor(kColorTheme9399a5);
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}

- (UIButton *)likeButton {
    if (!_likeButton) {
        _likeButton = UIButton.btnInit().btnImage(kImageMake(@"big_like_white")).btnSelectedImage(kImageMake(@"big_like_white_orange")).btnAction(self, @selector(likeButtonClick:));
        _likeButton.btnBadgeLabel = UILabel.labelFrame(CGRectMake(20, 0, 40, 30)).labelFont(kFontTheme14).labelTitleColor(kColorTheme2a303c).labelTextAlignment(NSTextAlignmentCenter);
        _likeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self.contentView addSubview:_likeButton];
    }
    return _likeButton;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = UILabel.labelInit().labelFont(kFontTheme14).labelTitleColor(kColorTheme444).labelNumberOfLines(0);
        [self.contentView addSubview:_contentLabel];
    }
    return _contentLabel;
}

- (UIView *)originalContentView {
    if (!_originalContentView) {
        _originalContentView = UIView.viewInit().bkgColor(kColorThemef5f5f5).cornerRadius(5);
        [self.contentView addSubview:_originalContentView];
    }
    return _originalContentView;
}

- (UILabel *)originalContentLabel {
    if (!_originalContentLabel) {
        _originalContentLabel = UILabel.labelInit().labelFont(kFontTheme14).labelTitleColor(kColorTheme666).labelNumberOfLines(0);
        _originalContentLabel.userInteractionEnabled = YES;
        [_originalContentLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOriginalContentLabel)]];
        [self.originalContentView addSubview:_originalContentLabel];
    }
    return _originalContentLabel;
}

@end
