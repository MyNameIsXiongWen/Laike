//
//  CommunityTableHeaderView.m
//  GoOverSeas
//
//  Created by 熊文 on 2020/5/17.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "CommunityTableHeaderView.h"
#import "UserDataView.h"
#import "QHWTableSectionHeaderView.h"
#import "QHWTabScrollView.h"

@interface CommunityTableHeaderView ()

@property (nonatomic, strong) UIView *contentBkgView;
@property (nonatomic, strong) UserDataView *userDataView;
@property (nonatomic, strong) QHWTableSectionHeaderView *headerView;
@property (nonatomic, strong) QHWTabScrollView *tabScrollView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation CommunityTableHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.whiteColor;
        [self addSubview:self.contentBkgView];
        [self.contentBkgView addSubview:self.headerView];
        [self.contentBkgView addSubview:self.userDataView];
        [self.contentBkgView addSubview:self.tabScrollView];
    }
    return self;
}

- (void)configCellData:(id)data {
    self.dataArray = (NSArray *)data;
    NSMutableArray *tempArray = NSMutableArray.array;
    for (NSDictionary *dic in self.dataArray) {
        [tempArray addObject:dic[@"groupName"]];
    }
    self.tabScrollView.dataArray = tempArray;
    [self.tabScrollView scrollToIndex:1];
    self.userDataView.dataArray = self.dataArray[self.tabScrollView.currentIndex][@"groupList"];
}

#pragma mark ------------UI-------------
- (UIView *)contentBkgView {
    if (!_contentBkgView) {
        _contentBkgView = UIView.viewFrame(CGRectMake(15, 10, kScreenW-30, self.height-20)).bkgColor(kColorThemefff).cornerRadius(10);
        _contentBkgView.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.2].CGColor;
        _contentBkgView.layer.shadowOffset = CGSizeMake(0, 0);
        _contentBkgView.layer.shadowOpacity = 0.5;
        _contentBkgView.layer.shadowRadius = 10;
        _contentBkgView.clipsToBounds = NO;
    }
    return _contentBkgView;
}

- (QHWTableSectionHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[QHWTableSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW-30, 55)];
        _headerView.titleLabel.text = @"我的数据";
        _headerView.moreBtn.hidden = YES;
        _headerView.moreBtn.userInteractionEnabled = NO;
    }
    return _headerView;
}

- (UserDataView *)userDataView {
    if (!_userDataView) {
        _userDataView = [[UserDataView alloc] initWithFrame:CGRectMake(0, self.headerView.bottom, kScreenW-30, 45)];
        _userDataView.userInteractionEnabled = NO;
    }
    return _userDataView;
}

- (QHWTabScrollView *)tabScrollView {
    if (!_tabScrollView) {
        _tabScrollView = [[QHWTabScrollView alloc] initWithFrame:CGRectMake((kScreenW-30-180)/2, self.userDataView.bottom+15, 180, 25)];
        _tabScrollView.backgroundColor = kColorThemeeee;
        _tabScrollView.layer.cornerRadius = 12.5;
        _tabScrollView.layer.masksToBounds = YES;
        _tabScrollView.btnCornerRadius = 12.5;
        _tabScrollView.itemSpace = 0;
        _tabScrollView.itemWidthType = ItemWidthTypeFixed;
        _tabScrollView.itemSelectedColor = kColorThemefff;
        _tabScrollView.itemUnselectedColor = kColorTheme2a303c;
        _tabScrollView.itemSelectedBackgroundColor = kColorTheme707070;
        _tabScrollView.itemUnselectedBackgroundColor = kColorThemeeee;
        _tabScrollView.textFont = kFontTheme12;
        WEAKSELF
        _tabScrollView.clickTagBlock = ^(NSInteger index) {
            weakSelf.userDataView.dataArray = weakSelf.dataArray[index][@"groupList"];
        };
    }
    return _tabScrollView;
}

@end
