//
//  QHWMoreView.m
//  XuanWoJia
//
//  Created by jason on 2019/7/26.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "QHWMoreView.h"

@interface QHWMoreView ()

@property (nonatomic, strong) NSArray *dataAry;

@end

@implementation QHWMoreView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame ViewArray:(NSArray *)viewArray {
    if (self == [super initWithFrame:frame]) {
        self.backgroundView.backgroundColor = UIColor.clearColor;
        
        self.layer.backgroundColor = UIColor.whiteColor.CGColor;
        self.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.2].CGColor;
        self.layer.shadowOffset = CGSizeMake(0,0);
        self.layer.shadowOpacity = 1;
        self.layer.shadowRadius = 2;
        self.layer.cornerRadius = 8;
        
        self.dataAry = viewArray;
        for (int i = 0 ; i < self.dataAry.count; i++) {
            NSDictionary *dic = self.dataAry[i];
            [self generateButton:i Title:dic[@"title"]];
        }
    }
    return self;
}

- (void)clickButton:(UIButton *)btn {
    NSDictionary *dic = self.dataAry[btn.tag];
    if (self.clickBtnBlock) {
        self.clickBtnBlock(dic[@"identifier"]);
    }
    [self dismiss];
}

- (void)generateButton:(NSInteger)index Title:(NSString *)title {
    UIButton *btn = UIButton.btnFrame(CGRectMake(0, 5+index*40, 105, 40)).btnTitle(title).btnTitleColor(kColorTheme000).btnFont(kFontTheme16).btnAction(self, @selector(clickButton:));
    btn.tag = index;
    [self addSubview:btn];
    [self addSubview:UIView.viewFrame(CGRectMake(15, btn.bottom, self.width-30, 0.5)).bkgColor(kColorThemeeee)];
}

#pragma mark ------------UI-------------
- (NSArray *)dataAry {
    if (!_dataAry) {
        _dataAry = NSArray.array;
    }
    return _dataAry;
}

@end
