//
//  QHWCellBottomShareView.m
//  Laike
//
//  Created by xiaobu on 2020/6/23.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWCellBottomShareView.h"

@implementation QHWCellBottomShareView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.titleLabel = UILabel.labelFrame(CGRectMake(15, 0, kScreenW-120, 22)).labelFont(kFontTheme12).labelTitleColor(kColorTheme707070).labelText(@"转发推广越多，获客机会越多");
        [self addSubview:self.titleLabel];
        
        self.shareBtn = UIButton.btnFrame(CGRectMake(kScreenW-95, 0, 80, 22)).btnCornerRadius(11).btnTitle(@"微信推广").btnFont(kFontTheme11).btnTitleColor(kColorTheme444).btnImage(kImageMake(@"")).btnBorderColor(kColorTheme444).btnAction(self, @selector(clickShareBtn));
        [self addSubview:self.shareBtn];
    }
    return self;
}

- (void)clickShareBtn {
    
}

@end
