//
//  QHWTabScrollView.m
//  GoOverSeas
//
//  Created by xiaobu on 2019/7/13.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "QHWTabScrollView.h"

@interface QHWTabScrollView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIView *tagIndicatorView;
@property (nonatomic, strong, readwrite) NSMutableArray *tagBtnArray;

@end

@implementation QHWTabScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.showsHorizontalScrollIndicator = NO;
        self.labelSpace = 15;
        self.itemSpace = 10;
        self.hideIndicatorView = YES;
        self.scrollAnimate = YES;
        self.itemSelectedColor = kColorThemefff;
        self.itemUnselectedColor = kColorTheme000;
        self.itemSelectedBackgroundColor = kColorThemefb4d56;
        self.itemUnselectedBackgroundColor = kColorThemef5f5f5;
        self.textFont = kFontTheme16;
        self.currentIndex = 0;
        self.btnCornerRadius = 2;
    }
    return self;
}

- (void)setTagIndicatorColor:(UIColor *)tagIndicatorColor {
    _tagIndicatorColor = tagIndicatorColor;
    self.tagIndicatorView.backgroundColor = tagIndicatorColor;
}

- (void)setDataArray:(NSArray *)dataArray {
    if (dataArray.count > 0) {
        [self addSubview:self.tagIndicatorView];
    }
    [self.tagBtnArray removeAllObjects];
    CGFloat itemWidth = 0;
    CGFloat originX = 0;
    for (UIView *vvv in self.subviews) {
        if ([vvv isKindOfClass:UIButton.class]) {
            [vvv removeFromSuperview];
        }
    }
    __block CGFloat totalTitleWidth = 0;
    [dataArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        totalTitleWidth += [obj getWidthWithFont:self.textFont constrainedToSize:CGSizeMake(CGFLOAT_MAX, 25)] + self.labelSpace;
    }];
    CGFloat tempItemSpace = (self.width - totalTitleWidth)/(dataArray.count-1);
    for (int i=0; i<dataArray.count; i++) {
        if (self.itemWidthType == ItemWidthTypeFixedAdaptive) {
            itemWidth = [dataArray[i] getWidthWithFont:self.textFont constrainedToSize:CGSizeMake(CGFLOAT_MAX, 25)] + self.labelSpace;
            self.itemSpace = tempItemSpace;
        } else if (self.itemWidthType == ItemWidthTypeFixed) {
            itemWidth = (self.width-(dataArray.count-1)*self.itemSpace)/dataArray.count;
        } else if (self.itemWidthType == ItemWidthTypeAdaptive) {
            itemWidth = [dataArray[i] getWidthWithFont:self.textFont constrainedToSize:CGSizeMake(CGFLOAT_MAX, 25)] + self.labelSpace;
        }
        UIButton *btn = UIButton.btnFrame(CGRectMake(originX, 0, itemWidth, self.height)).btnTitle(dataArray[i]).btnFont(self.textFont).btnTitleColor(i==0 ? self.itemSelectedColor : self.itemUnselectedColor).btnBkgColor(i==0 ? self.itemSelectedBackgroundColor : self.itemUnselectedBackgroundColor).btnCornerRadius(self.btnCornerRadius);
        btn.tag = i;
        [btn addTarget:self action:@selector(clickTagBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self insertSubview:btn belowSubview:self.tagIndicatorView];
        [self.tagBtnArray addObject:btn];
        if (i == 0) {
            btn.backgroundColor = self.itemSelectedBackgroundColor;
        } else {
            btn.backgroundColor = self.itemUnselectedBackgroundColor;
        }
        originX += itemWidth + self.itemSpace;
    }
    self.tagIndicatorView.hidden = self.hideIndicatorView;
    if (!self.hideIndicatorView) {
        if (self.currentIndex < self.tagBtnArray.count) {
            UIButton *btn = self.tagBtnArray[self.currentIndex];
            self.tagIndicatorView.width = [btn.titleLabel.text getWidthWithFont:self.textFont constrainedToSize:CGSizeMake(kScreenW, 20)];
            self.tagIndicatorView.centerX = btn.centerX;
        }
    }
    self.contentSize = CGSizeMake(originX-self.itemSpace, self.height);
}

- (void)clickTagBtn:(UIButton *)btn {
    self.currentIndex = [self.tagBtnArray indexOfObject:btn];
    [self handleScrollViewContentOffset:btn];
    if (self.clickTagBlock) {
        self.clickTagBlock(btn.tag);
    }
}

- (void)scrollToIndex:(NSInteger)index {
    self.currentIndex = index;
    if (index < self.tagBtnArray.count) {
        UIButton *btn = self.tagBtnArray[index];
        [self handleScrollViewContentOffset:btn];
    }
}

- (void)handleScrollViewContentOffset:(UIButton *)btn {
    if (!self.hideIndicatorView) {
        [UIView animateWithDuration:0.25 animations:^{
            self.tagIndicatorView.width = [btn.titleLabel.text getWidthWithFont:self.textFont constrainedToSize:CGSizeMake(kScreenW, 20)];
            self.tagIndicatorView.centerX = btn.centerX;
        }];
    }
    CGRect centerRect = CGRectMake(btn.x+btn.width/2-self.width/2, 0, self.width, self.height);
    [self scrollRectToVisible:centerRect animated:self.scrollAnimate];
    for (UIButton *tempBtn in self.tagBtnArray) {
        [tempBtn setTitleColor:self.itemUnselectedColor forState:0];
        tempBtn.backgroundColor = self.itemUnselectedBackgroundColor;
    }
    [btn setTitleColor:self.itemSelectedColor forState:0];
    btn.backgroundColor = self.itemSelectedBackgroundColor;
}

- (UIView *)tagIndicatorView {
    if (!_tagIndicatorView) {
        _tagIndicatorView = [UICreateView initWithFrame:CGRectMake(0, self.height-3, 0, 3) BackgroundColor:kColorThemefb4d56 CornerRadius:1.5];
    }
    return _tagIndicatorView;
}

- (NSMutableArray *)tagBtnArray {
    if (!_tagBtnArray) {
        _tagBtnArray = [NSMutableArray array];
    }
    return _tagBtnArray;
}

@end
