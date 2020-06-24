//
//  MineCardTableViewCell.m
//  Laike
//
//  Created by xiaobu on 2020/6/22.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "MineCardTableViewCell.h"
#import "QHWTableSectionHeaderView.h"
#import "QHWTabScrollView.h"

@interface MineCardTableViewCell () <QHWBaseCellProtocol>

@property (nonatomic, strong) QHWTableSectionHeaderView *headerView;
@property (nonatomic, strong) QHWTabScrollView *tabScrollView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation MineCardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = self.backgroundColor = UIColor.clearColor;
        [self.shadowView addSubview:self.headerView];
        [self.shadowView addSubview:self.userDataView];
        [self.shadowView addSubview:self.tabScrollView];
    }
    return self;
}

- (void)configCellData:(id)data {
    self.dataArray = (NSArray *)data;
    self.userDataView.dataArray = self.dataArray[self.tabScrollView.currentIndex];
    if ([self.dataArray.lastObject length] > 0) {
        [self.headerView.moreBtn setTitle:self.dataArray.lastObject forState:0];
    }
}

#pragma mark ------------UI-------------
- (QHWTableSectionHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[QHWTableSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW-30, 55)];
        _headerView.titleLabel.text = @"名片数据";
        _headerView.moreBtn.hidden = NO;
    }
    return _headerView;
}

- (UserDataView *)userDataView {
    if (!_userDataView) {
        _userDataView = [[UserDataView alloc] initWithFrame:CGRectMake(0, self.headerView.bottom, kScreenW-30, 45)];
        WEAKSELF
        _userDataView.didSelectedItemBlock = ^(NSInteger index) {
            
        };
    }
    return _userDataView;
}

- (QHWTabScrollView *)tabScrollView {
    if (!_tabScrollView) {
        _tabScrollView = [[QHWTabScrollView alloc] initWithFrame:CGRectMake((kScreenW-30-180)/2, self.userDataView.bottom+15, 180, 25)];
        _tabScrollView.itemWidthType = ItemWidthTypeFixed;
        _tabScrollView.itemSelectedColor = kColorThemefff;
        _tabScrollView.itemUnselectedColor = kColorTheme2a303c;
        _tabScrollView.itemSelectedBackgroundColor = kColorTheme707070;
        _tabScrollView.itemUnselectedBackgroundColor = kColorThemeeee;
        _tabScrollView.textFont = kFontTheme12;
        _tabScrollView.dataArray = @[@"7日", @"30日", @"累计"];
        WEAKSELF
        _tabScrollView.clickTagBlock = ^(NSInteger index) {
            weakSelf.userDataView.dataArray = weakSelf.dataArray[index];
        };
    }
    return _tabScrollView;
}

@end
