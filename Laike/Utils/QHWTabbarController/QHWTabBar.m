//
//  QHWTabBar.m
//  GoOverSeas
//
//  Created by xiaobu on 2019/7/9.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "QHWTabBar.h"

@implementation QHWTabBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    if (self == [super init]) {
        [self addSubview:self.centerBtn];
//        [self addSubview:self.msgView];
    }
    return self;
}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    UIView *tempView = [super hitTest:point withEvent:event];
//    if (tempView == nil) {
//        CGPoint tempPoint = [self.centerBtn convertPoint:point fromView:self];
//        if (CGRectContainsPoint(self.centerBtn.bounds, tempPoint)) {
//            return self.centerBtn;
//        }
//    }
//    return tempView;
//}

- (UIButton *)centerBtn {
    if (!_centerBtn) {
        _centerBtn = UIButton.btnFrame(CGRectMake((kScreenW-50)/2.0, -50/3.0, 50, 50)).btnCornerRadius(25).btnBkgColor(kColorThemefff);
        _centerBtn.adjustsImageWhenHighlighted = NO;
        UIImageView *imgView = UIImageView.ivFrame(CGRectMake(5, 5, 40, 40)).ivCornerRadius(20).ivImage(kImageMake(@"tabbar_crm"));
        [_centerBtn addSubview:imgView];
    }
    return _centerBtn;
}

- (UIView *)msgView {
    if (!_msgView) {
        CGFloat perWidth = kScreenW/5;
        _msgView = [UICreateView initWithFrame:CGRectMake(perWidth*1+(perWidth-25)/2+25-4, 3, 8, 8) BackgroundColor:UIColor.redColor CornerRadius:4];
        _msgView.hidden = YES;
    }
    return _msgView;
}

- (UILabel *)msgCountLabel {
    if (!_msgCountLabel) {
        CGFloat perWidth = kScreenW/5;
        _msgCountLabel = UILabel.labelFrame(CGRectMake(perWidth*1+(perWidth-25)/2+25-9, 2, 15, 15)).labelFont(kFontTheme12).labelTitleColor(kColorThemefff).labelBkgColor(kColorThemefb4d56).labelTextAlignment(NSTextAlignmentCenter).labelCornerRadius(7.5);
        _msgCountLabel.layer.zPosition = 999;
        [self addSubview:_msgCountLabel];
    }
    return _msgCountLabel;
}

@end
