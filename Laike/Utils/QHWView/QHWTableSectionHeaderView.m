//
//  QHWTableSectionHeaderView.m
//  Laike
//
//  Created by xiaobu on 2020/6/22.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWTableSectionHeaderView.h"

@implementation QHWTableSectionHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.tagImgView = UIImageView.ivFrame(CGRectMake(15, 15, 0, 0));
        [self.contentView addSubview:self.tagImgView];
        
        self.titleLabel = UILabel.labelFrame(CGRectMake(15, 0, 200, self.height)).labelFont(kMediumFontTheme18).labelTitleColor(kColorTheme2a303c);
        [self.contentView addSubview:self.titleLabel];
        
        self.moreBtn = UIButton.btnFrame(CGRectMake(self.width-200, 10, 180, 35)).btnTitle(@"全部数据").btnFont(kFontTheme11).btnTitleColor(kColorTheme9399a5).btnAction(self, @selector(clickMoreBtn));
        self.moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        self.moreBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
        self.moreBtn.hidden = YES;
        [self.contentView addSubview:self.moreBtn];
        
        UIImageView *arrow = UIImageView.ivFrame(CGRectMake(200-22, 11, 7, 13)).ivImage(kImageMake(@"arrow_right_gray"));
        [self.moreBtn addSubview:arrow];
    }
    return self;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.tagImgView = UIImageView.ivFrame(CGRectMake(15, 15, 0, 0));
        [self.contentView addSubview:self.tagImgView];
        
        self.titleLabel = UILabel.labelFrame(CGRectMake(15, 0, 200, self.height)).labelFont(kMediumFontTheme18).labelTitleColor(kColorTheme2a303c);
        [self.contentView addSubview:self.titleLabel];
        
        self.moreBtn = UIButton.btnFrame(CGRectMake(self.width-100, 10, 100, 35)).btnTitle(@"全部数据").btnFont(kFontTheme12).btnTitleColor(kColorTheme9399a5).btnAction(self, @selector(clickMoreBtn));
        self.moreBtn.hidden = YES;
        [self.contentView addSubview:self.moreBtn];
        
        UIImageView *arrow = UIImageView.ivFrame(CGRectMake(100-22, 16, 7, 12)).ivImage(kImageMake(@"arrow_right_gray"));
        [self.moreBtn addSubview:arrow];
    }
    return self;
}

- (void)setTagImgWidth:(CGFloat)tagImgWidth {
    self.tagImgView.frame = CGRectMake(15, (self.height-tagImgWidth)/2, tagImgWidth, tagImgWidth);
    self.titleLabel.x = self.tagImgView.right+5;
}

- (void)clickMoreBtn {
    if (self.clickMoreBtnBlock) {
        self.clickMoreBtnBlock();
    }
}

@end
