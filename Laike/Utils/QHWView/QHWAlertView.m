//
//  QHWAlertView.m
//  GoOverSeas
//
//  Created by xiaobu on 2019/7/10.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "QHWAlertView.h"

@interface QHWAlertView ()

@property (nonatomic, strong, readwrite) UILabel *titleLabel;
@property (nonatomic, strong, readwrite) UIView *lineView;
@property (nonatomic, strong, readwrite) UIButton *cancelBtn;
@property (nonatomic, strong, readwrite) UIButton *confirmBtn;
@property (nonatomic, strong, readwrite) UIButton *closeBtn;
@property (nonatomic, strong) UIView *midLine;
@property (nonatomic, assign, readwrite) CGFloat selfHeight;

@end

static const float selfWidth = 280;
@implementation QHWAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.popType = PopTypeCenter;
        self.selfHeight = 0;
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(25);
            make.width.mas_equalTo(selfWidth - 30);
            make.height.mas_equalTo(25);
        }];
        
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.mas_equalTo(0);
            make.width.height.mas_equalTo(40);
        }];
        
        [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(50);
        }];
        
        [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.cancelBtn.mas_right);
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(0);
            make.height.mas_equalTo(50);
        }];
        
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(self.selfHeight - 50.5);
            make.width.mas_equalTo(selfWidth);
            make.height.mas_equalTo(0);
        }];
        
        [self.midLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(selfWidth/2.0);
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(0);
            make.height.mas_equalTo(50);
        }];
    }
    return self;
}

- (void)configWithTitle:(NSString *)title cancleText:(NSString *)cancleText confirmText:(NSString *)confirmText{
    CGFloat titleH = MAX([title getHeightWithFont:kFontTheme18 constrainedToSize:CGSizeMake(selfWidth - 30, CGFLOAT_MAX)], 25);
    self.titleLabel.text = title;
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(titleH);
    }];
    self.selfHeight = 25 + titleH + 10 + 15;
    
    if (cancleText || confirmText) {
        self.selfHeight += 50;
        [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.5);
        }];
    }
    self.frame = CGRectMake((kScreenW - selfWidth)/2, (kScreenH - self.selfHeight)/2, selfWidth, self.selfHeight);
    CGFloat cancleWidth = 0;
    if (cancleText) {
        cancleWidth = selfWidth/2.0;
        [self.cancelBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(cancleWidth);
        }];
        [self.cancelBtn setTitle:cancleText forState:0];
    } else {
        [self.cancelBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(cancleWidth);
        }];
    }
    [self.confirmBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(selfWidth - cancleWidth);
    }];
    [self.confirmBtn setTitle:confirmText forState:0];
    
    if (cancleText && confirmText) {
        [self.midLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0.5);
        }];
    }
}

- (void)closeBtnAction {
    [self dismiss];
    if (self.closeBlock) {
        self.closeBlock();
    }
}

- (void)cancelBtnAction {
    [self dismiss];
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

- (void)confirmBtnAction {
    if (self.confirmBlock) {
        self.confirmBlock();
    }
}

- (void)popView_cancel {
    if (self.dismissAlert) {
        [self dismiss];
    }
}

- (void)setCancelTextColor:(UIColor *)cancelTextColor {
    [self.cancelBtn setTitleColor:cancelTextColor forState:0];
}

- (void)setConfirmTextColor:(UIColor *)confirmTextColor {
    [self.confirmBtn setTitleColor:confirmTextColor forState:0];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UICreateView initWithFrame:CGRectZero Text:@"" Font:kFontTheme18 TextColor:UIColor.blackColor BackgroundColor:UIColor.whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UICreateView initWithFrame:CGRectZero BackgroundColor:kColorThemeeee CornerRadius:0];
        [self addSubview:_lineView];
    }
    return _lineView;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = UIButton.btnInit().btnImage(kImageMake(@"publish_close")).btnAction(self, @selector(closeBtnAction));
        _closeBtn.hidden = YES;
        [self addSubview:_closeBtn];
    }
    return _closeBtn;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = UIButton.btnInit().btnFont(kFontTheme18).btnTitleColor(kColorTheme2a303c).btnAction(self, @selector(cancelBtnAction));
        [self addSubview:_cancelBtn];
    }
    return _cancelBtn;
}

- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = UIButton.btnInit().btnFont(kFontTheme18).btnTitleColor(kColorTheme21a8ff).btnAction(self, @selector(confirmBtnAction));
        [self addSubview:_confirmBtn];
    }
    return _confirmBtn;
}

- (UIView *)midLine {
    if (!_midLine) {
        _midLine = [UICreateView initWithFrame:CGRectZero BackgroundColor:kColorThemeeee CornerRadius:0];
        [self addSubview:_midLine];
    }
    return _midLine;
}

@end
