//
//  CommentBottomView.m
//  GoOverSeas
//
//  Created by manku on 2019/8/8.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "CommentBottomView.h"

@interface CommentBottomView ()

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong, readwrite) UIButton *commentButton;
@property (nonatomic, strong, readwrite) UIButton *praiseButton;
@property (nonatomic, strong, readwrite) UILabel *commentLbl;

@end

@implementation CommentBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kColorThemefff;
        [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-60);
            make.height.mas_equalTo(40);
            make.centerY.equalTo(self);
        }];
        [self.commentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.commentButton.mas_left).offset(15);
            make.right.equalTo(self.commentButton.mas_right).offset(-15);
            make.height.mas_equalTo(40);
            make.centerY.equalTo(self);
        }];
        [self.praiseButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo (self);
            make.right.mas_equalTo(-10);
            make.height.width.mas_equalTo(40);
        }];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}

#pragma mark ------------点击事件------------
- (void)clickCommentBtn:(UIButton *)button {
    if (self.bottomViewCommentBlock) {
        self.bottomViewCommentBlock();
    }
}

- (void)clickPraiseBtn:(UIButton *)button {
    if (self.bottomViewPraiseBlock) {
        self.bottomViewPraiseBlock();
    }
}

#pragma mark ------------UI------------
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = UIView.viewInit().bkgColor(kColorThemeeee);
        [self addSubview:_lineView];
    }
    return _lineView;
}

- (UIButton *)commentButton {
    if (!_commentButton) {
        _commentButton = UIButton.btnInit().btnBkgColor(kColorThemef5f5f5).btnCornerRadius(20).btnAction(self, @selector(clickCommentBtn:));
        [self addSubview:_commentButton];
    }
    return _commentButton;
}

- (UILabel *)commentLbl {
    if (!_commentLbl) {
        _commentLbl = UILabel.labelInit().labelText(@"写评论").labelFont(kFontTheme14).labelTitleColor(kColorThemea4abb3);
        [self addSubview:_commentLbl];
    }
    return _commentLbl;
}

- (UIButton *)praiseButton {
    if (!_praiseButton) {
        _praiseButton = UIButton.btnInit().btnImage(kImageMake(@"big_like_white")).btnSelectedImage(kImageMake(@"big_like_white_orange")).btnAction(self, @selector(clickPraiseBtn:));
        _praiseButton.btnBadgeLabel = UILabel.labelFrame(CGRectMake(10, 0, 40, 40)).labelFont(kFontTheme14).labelTitleColor(kColorTheme2a303c).labelTextAlignment(NSTextAlignmentCenter);
        _praiseButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self addSubview:_praiseButton];
    }
    return _praiseButton;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
