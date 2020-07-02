//
//  CRMTextFieldView.m
//  Laike
//
//  Created by xiaobu on 2020/7/2.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "CRMTextFieldView.h"

@implementation CRMTextFieldView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.leftLabel = UILabel.labelFrame(CGRectMake(20, 0, 80, 60)).labelTitleColor(kColorTheme000).labelFont(kFontTheme16);
        [self addSubview:self.leftLabel];
        
        self.textField = UITextField.tfFrame(CGRectMake(self.leftLabel.right+10, 0, self.width-130, 60)).tfTextColor(kColorTheme000).tfFont(kFontTheme16);
        [self addSubview:self.textField];
        
        self.rightLabel = UILabel.labelFrame(CGRectMake(self.leftLabel.right+10, 0, self.width-130, 60)).labelTitleColor(kColorTheme000).labelFont(kFontTheme16);
        self.rightLabel.hidden = YES;
        [self addSubview:self.rightLabel];
        
        self.arrowImgView = UIImageView.ivFrame(CGRectMake(self.width-30, 21, 10, 18)).ivImage(kImageMake(@"arrow_right_gray"));
        self.arrowImgView.hidden = YES;
        [self addSubview:self.arrowImgView];
        
        [self addSubview:UIView.viewFrame(CGRectMake(0, 59.0, self.width, 0.5)).bkgColor(kColorThemeeee)];
        
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelfView)]];
    }
    return self;
}

- (void)tapSelfView {
    if (self.clickTFViewBlock) {
        self.clickTFViewBlock();
    }
}

- (void)setTitle:(NSString *)title {
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:title];
    [attr addAttributes:@{NSForegroundColorAttributeName: UIColor.redColor} range:[title rangeOfString:@"*"]];
    self.leftLabel.attributedText = attr;
}

@end
