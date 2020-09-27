//
//  SearchBkgView.m
//  Laike
//
//  Created by xiaobu on 2020/9/23.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "SearchBkgView.h"

@implementation SearchBkgView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSearchView)]];
        _searchBgView = UIView.viewFrame(CGRectMake(13, 0, self.width-26, 32)).borderColor(kColorThemeeee).cornerRadius(16);
        [self addSubview:_searchBgView];
        
        UIImageView *searchImg = UIImageView.ivFrame(CGRectMake(10, 8, 16, 16)).ivImage(kImageMake(@"global_search"));
        [_searchBgView addSubview:searchImg];
        
        self.placeholderLabel = UILabel.labelFrame(CGRectMake(searchImg.right+10, 0, 200, 32)).labelTitleColor(kColorTheme999).labelFont(kFontTheme14);
        [_searchBgView addSubview:self.placeholderLabel];

        _searchBtn = UIButton.btnFrame(CGRectMake(_searchBgView.width-62, 3, 54, 26)).btnTitle(@"搜索").btnBkgColor(kColorTheme21a8ff).btnTitleColor(kColorThemefff).btnCornerRadius(13).btnFont(kFontTheme14);
        _searchBtn.userInteractionEnabled = NO;
        _searchBtn.hidden = YES;
        [_searchBgView addSubview:_searchBtn];
    }
    return self;
}

- (void)tapSearchView {
    if (self.clickSearchBkgBlock) {
        self.clickSearchBkgBlock();
    }
}

@end
