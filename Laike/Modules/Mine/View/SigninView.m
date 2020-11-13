//
//  SigninView.m
//  Laike
//
//  Created by xiaobu on 2020/11/11.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "SigninView.h"

@implementation SigninView

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
        UIButton *closeBtn = UIButton.btnFrame(CGRectMake(self.width-20, 0, 20, 20)).btnImage(kImageMake(@"publish_close")).btnAction(self, @selector(closeBtnAction));
        [self addSubview:closeBtn];
        
        UILabel *label1 = UILabel.labelFrame(CGRectMake(0, 20, self.width, 25)).labelText(@"今天 签到 领红包").labelTextAlignment(NSTextAlignmentCenter).labelFont(kFontTheme22).labelTitleColor(kColorFromHexString(@"f85b5b"));
        [self addSubview:label1];
        
        UILabel *label2 = UILabel.labelFrame(CGRectMake(0, label1.bottom+20, self.width, 20)).labelText(@"每天签到不要错过").labelTextAlignment(NSTextAlignmentCenter).labelFont(kFontTheme14).labelTitleColor(kColorTheme999);
        [self addSubview:label2];
        
        UIImageView *imgView = UIImageView.ivFrame(CGRectMake((self.width-140)/2, label2.bottom+30, 140, 125)).ivImage(kImageMake(@"signin_coin")).ivMode(UIViewContentModeScaleAspectFit);
        [self addSubview:imgView];
        
        UILabel *label3 = UILabel.labelFrame(CGRectMake(0, imgView.bottom+20, self.width, 20)).labelText(@"0.2元").labelTextAlignment(NSTextAlignmentCenter).labelFont(kFontTheme20).labelTitleColor(kColorFromHexString(@"f8bd25"));
        [self addSubview:label3];
        
        UIButton *btn = UIButton.btnFrame(CGRectMake(40, self.height-44-20, self.width-80, 44)).btnTitle(@"立即签到").btnTitleColor(kColorThemefff).btnBkgColor(kColorFromHexString(@"f85b5b")).btnCornerRadius(22).btnAction(self, @selector(clickSigninBtn));
        [self addSubview:btn];
        
    }
    return self;
}

- (void)popView_cancel {
    
}

- (void)closeBtnAction {
    [self dismiss];
}

- (void)clickSigninBtn {
    if (self.clickSigninBlock) {
        self.clickSigninBlock();
    }
}

@end
