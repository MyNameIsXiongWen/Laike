//
//  QHWPopView.m
//  GoOverSeas
//
//  Created by xiaobu on 2019/7/9.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import "QHWPopView.h"

@interface QHWPopView ()

@property (nonatomic, strong, readwrite) UIView *backgroundView;

@end

@implementation QHWPopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.whiteColor;
        self.bkgViewAlpha = 0.3;
    }
    return self;
}

- (void)setPopType:(PopType)popType {
    _popType = popType;
    if (popType == PopTypeCenter) {
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
    }
}

- (void)popView_cancel {
    [self dismiss];
}

#pragma mark ------------ 点击事件 ----------

- (void)show {
    [[UIApplication sharedApplication].delegate.window addSubview:self.backgroundView];
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundView.alpha = self.bkgViewAlpha;
        switch (self.popType) {
            case PopTypeBottom:
                self.transform = CGAffineTransformMakeTranslation(0, -self.height);
                break;
                
            case PopTypeRight:
                self.transform = CGAffineTransformMakeTranslation(-self.width, 0);
                break;
                
            default:
                self.alpha = 1;
                break;
        }
    }];
}

- (void)dismiss {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundView.alpha = 0;
        if (self.popType == PopTypeCenter) {
            self.alpha = 0;
        } else {
            self.transform = CGAffineTransformIdentity;
        }
    } completion:^(BOOL finished) {
        [self.backgroundView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

#pragma mark ------------UI初始化-------------

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _backgroundView.backgroundColor = kColorTheme000;
        _backgroundView.alpha = 0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popView_cancel)];
        [_backgroundView addGestureRecognizer:tap];
    }
    return _backgroundView;
}

@end
