//
//  CommentListCell.m
//  GoOverSeas
//
//  Created by manku on 2019/8/8.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "CommentListCell.h"
#import "CommentReplyListViewController.h"
#import "QHWSystemService.h"
#import "CTMediator+ViewController.h"

@implementation CommentListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.avtarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(10);
            make.width.height.mas_equalTo(30);
        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avtarImgView.mas_right).offset(5);
            make.centerY.equalTo(self.avtarImgView);
        }];
        [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(30);
            make.centerY.equalTo(self.avtarImgView);
        }];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.mas_left);
            make.right.mas_equalTo(-15);
            make.top.equalTo(self.avtarImgView.mas_bottom).offset(10);
        }];
        [self.allReplyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.mas_left);
            make.bottom.mas_equalTo(-10);
            make.height.mas_equalTo(20);
        }];
    }
    return self;
}

- (void)setCommentModel:(QHWCommentModel *)commentModel {
    _commentModel = commentModel;
    [self.avtarImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(commentModel.headPath)]];
    self.nameLabel.text = commentModel.releaseName;
    self.contentLabel.text = commentModel.content;
    if (commentModel.isReply) {
        self.allReplyButton.hidden = YES;
        self.contentLabel.userInteractionEnabled = NO;
    } else {
        self.contentLabel.userInteractionEnabled = YES;
        self.allReplyButton.hidden = commentModel.answerCount == 0;
        [self.allReplyButton setTitle:kFormat(@"%ld条回复 >", commentModel.answerCount) forState:0];
    }
    self.likeButton.btnImage(kImageMake(commentModel.likeStatus == 2 ? @"big_like_white_orange" : @"big_like_white"));
    self.likeButton.btnBadgeLabel.text = kFormat(@"%ld", commentModel.likeCount);
}

#pragma mark ------------Action-------------
- (void)clickAvatar {
//    [CTMediator.sharedInstance CTMediator_viewControllerForUserDetailWithUserId:self.commentModel.releaseId UserType:1 BusinessType:0];
}

- (void)replyComment {
//    self.commentService.commentId = self.commentModel.commentId;
//    [self.commentService showCommentKeyBoardWithCommentName:self.commentModel.releaseName];
}

- (void)likeButtonClick:(UIButton *)btn {
//    NSInteger likeStatus = self.commentModel.likeStatus == 1 ? 2 : 1;
//    [QHWSystemService.new clickLikeRequestWithBusinessType:self.commentModel.businessType BusinessId:self.commentModel.commentId LikeStatus:likeStatus  Complete:^(BOOL status) {
//        if (status) {
//            self.commentModel.likeStatus = likeStatus;
//            if (likeStatus == 2) {
//                self.commentModel.likeCount++;
//            } else {
//                self.commentModel.likeCount--;
//            }
//            self.likeButton.selected = (likeStatus == 2);
//            self.likeButton.btnBadgeLabel.text = kFormat(@"%ld", self.commentModel.likeCount);
//        }
//    }];
}

- (void)allReplyButtonClick:(UIButton *)btn {
    CommentReplyListViewController *vc = CommentReplyListViewController.new;
    vc.communityType = self.commentService.communityType;
    vc.commentId = self.commentModel.commentId;
    vc.fileType = self.commentService.fileType;
    [self.getCurrentMethodCallerVC.navigationController pushViewController:vc animated:YES];
}

#pragma mark -----------UI-----------
- (UIImageView *)avtarImgView {
    if (!_avtarImgView) {
        _avtarImgView = UIImageView.ivInit().ivCornerRadius(15);
        _avtarImgView.userInteractionEnabled = YES;
        [_avtarImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAvatar)]];
        [self.contentView addSubview:_avtarImgView];
    }
    return _avtarImgView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = UILabel.labelInit().labelFont(kFontTheme13).labelTitleColor(kColorTheme2a303c);
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
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
        _contentLabel = UILabel.labelInit().labelFont(kFontTheme14).labelTitleColor(kColorTheme6d7278).labelTextAlignment(0);
        _contentLabel.userInteractionEnabled = YES;
        [_contentLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(replyComment)]];
        [self.contentView addSubview:_contentLabel];
    }
    return _contentLabel;
}

- (UIButton *)allReplyButton {
    if (!_allReplyButton) {
        _allReplyButton = UIButton.btnInit().btnTitleColor(kColorTheme5c98f8).btnFont(kFontTheme14).btnAction(self, @selector(allReplyButtonClick:));
        _allReplyButton.tag = self.tag;
        [self.contentView addSubview:_allReplyButton];
    }
    return _allReplyButton;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
