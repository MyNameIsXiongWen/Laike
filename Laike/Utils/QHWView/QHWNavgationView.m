//
//  QHWNavgationView.m
//  GoOverSeas
//
//  Created by xiaobu on 2019/7/27.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "QHWNavgationView.h"

@implementation QHWNavgationView

- (id)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.whiteColor;
        self.userInteractionEnabled = YES;
        [self addSubview:self.titleView];
        [self addSubview:self.leftBtn];
        [self addSubview:self.rightBtn];
        [self addSubview:self.rightAnotherBtn];
        [self addSubview:self.redPointView];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

#pragma mark ------------UI-------------
- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [UICreateView initWithFrame:CGRectMake(85, kStatusBarHeight, kScreenW - 170, 44) BackgroundColor:UIColor.clearColor CornerRadius:0];
        [_titleView addSubview:self.titleLabel];
    }
    return _titleView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UICreateView initWithFrame:CGRectMake(0, 0, self.titleView.width, 44) Text:@"" Font:kMediumFontTheme18 TextColor:UIColor.blackColor BackgroundColor:UIColor.clearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIButton *)leftBtn {
    if (!_leftBtn) {
        _leftBtn = UIButton.btnFrame(CGRectMake(0, kStatusBarHeight, 80, 44)).btnTitleColor(kColorTheme2a303c).btnImage(kImageMake(@"global_back"));
        _leftBtn.showsTouchWhenHighlighted = NO;
        _leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 15);
    }
    return _leftBtn;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = UIButton.btnFrame(CGRectMake(kScreenW-60, kStatusBarHeight, 40, 44)).btnTitleColor(kColorTheme2a303c);
        _rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _rightBtn.showsTouchWhenHighlighted = NO;
    }
    return _rightBtn;
}

- (UIButton *)rightAnotherBtn {
    if (!_rightAnotherBtn) {
        _rightAnotherBtn = UIButton.btnFrame(CGRectMake(kScreenW-40-60, kStatusBarHeight, 40, 44)).btnTitleColor(kColorTheme2a303c);
        _rightAnotherBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _rightAnotherBtn.showsTouchWhenHighlighted = NO;
    }
    return _rightAnotherBtn;
}

- (UIView *)redPointView {
    if (!_redPointView) {
        _redPointView = [UICreateView initWithFrame:CGRectMake(kScreenW-25, kStatusBarHeight+10, 6, 6) BackgroundColor:UIColor.redColor CornerRadius:3];
        _redPointView.hidden = YES;
    }
    return _redPointView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
