//
//  CommunityDetailBottomView.m
//  GoOverSeas
//
//  Created by xiaobu on 2019/9/24.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "CommunityDetailBottomView.h"

@implementation CommunityDetailBottomView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.whiteColor;
        [self addSubview:self.commentView];
        [self addSubview:self.collectBtn];
        [self addSubview:self.praiseBtn];
        [self addSubview:self.commentBtn];
        [self addSubview:[UICreateView initWithFrame:CGRectMake(0, 0, kScreenW, 0.5) BackgroundColor:kColorThemeeee CornerRadius:0]];
    }
    return self;
}

#pragma mark ------------Action------------
- (void)clickCommentView {
    if (self.clickCommentBlock) {
        self.clickCommentBlock();
    }
}
- (void)clickCommentBtn {
    if (self.clickAllCommentBlock) {
        self.clickAllCommentBlock();
    }
}

- (void)clickCollectBtn {
    if (self.clickCollectBlock) {
        self.clickCollectBlock();
    }
}

- (void)clickPraiseBtn {
    if (self.clickLikeBlock) {
        self.clickLikeBlock();
    }
}

#pragma mark ------------UI-------------
- (UIView *)commentView {
    if (!_commentView) {
        _commentView = [UICreateView initWithFrame:CGRectMake(15, 10, kScreenW-150, 30) BackgroundColor:kColorThemef5f5f5 CornerRadius:15];
        _commentView.userInteractionEnabled = YES;
        [_commentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCommentView)]];
        UILabel *label = [UICreateView initWithFrame:CGRectMake(15, 5, 100, 20) Text:@"写评论" Font:kFontTheme14 TextColor:kColorThemea4abb3 BackgroundColor:UIColor.clearColor];
        [_commentView addSubview:label];
    }
    return _commentView;
}

- (UIButton *)collectBtn {
    if (!_collectBtn) {
        _collectBtn = UIButton.btnFrame(CGRectMake(kScreenW-15-30, 10, 30, 30)).btnImage(kImageMake(@"big_collect_white")).btnSelectedImage(kImageMake(@"big_collect_white_orange")).btnAction(self, @selector(clickCollectBtn));
        _collectBtn.btnBadgeLabel = UILabel.labelFrame(CGRectMake(15, 5, 15, 10)).labelBkgColor(kColorThemefb4d56).labelFont(kFontTheme10).labelTitleColor(kColorThemefff).labelCornerRadius(5).labelTextAlignment(NSTextAlignmentCenter);
    }
    return _collectBtn;
}

- (UIButton *)praiseBtn {
    if (!_praiseBtn) {
        _praiseBtn = UIButton.btnFrame(CGRectMake(self.collectBtn.left-40, 10, 30, 30)).btnImage(kImageMake(@"big_like_white")).btnSelectedImage(kImageMake(@"big_like_white_orange")).btnAction(self, @selector(clickPraiseBtn));
        _praiseBtn.btnBadgeLabel = UILabel.labelFrame(CGRectMake(15, 5, 15, 10)).labelBkgColor(kColorThemefb4d56).labelFont(kFontTheme10).labelTitleColor(kColorThemefff).labelCornerRadius(5).labelTextAlignment(NSTextAlignmentCenter);
    }
    return _praiseBtn;
}

- (UIButton *)commentBtn {
    if (!_commentBtn) {
        _commentBtn = UIButton.btnFrame(CGRectMake(self.praiseBtn.left-40, 10, 30, 30)).btnImage(kImageMake(@"big_comment_white")).btnAction(self, @selector(clickCommentBtn));
        _commentBtn.btnBadgeLabel = UILabel.labelFrame(CGRectMake(15, 5, 15, 10)).labelBkgColor(kColorThemefb4d56).labelFont(kFontTheme10).labelTitleColor(kColorThemefff).labelCornerRadius(5).labelTextAlignment(NSTextAlignmentCenter);
    }
    return _commentBtn;
}

@end
