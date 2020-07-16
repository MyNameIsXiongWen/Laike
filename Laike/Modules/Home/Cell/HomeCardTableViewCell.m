//
//  HomeCardTableViewCell.m
//  Laike
//
//  Created by xiaobu on 2020/6/22.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "HomeCardTableViewCell.h"
#import "QHWTableSectionHeaderView.h"
#import "QHWTabScrollView.h"

@interface HomeCardTableViewCell () <QHWBaseCellProtocol>

@property (nonatomic, strong) QHWTableSectionHeaderView *headerView;
@property (nonatomic, strong) QHWTabScrollView *tabScrollView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation HomeCardTableViewCell

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
    NSDictionary *cellDic = (NSDictionary *)data;
    self.dataArray = cellDic[@"data"];
    NSMutableArray *tempArray = NSMutableArray.array;
    for (NSDictionary *dic in self.dataArray) {
        [tempArray addObject:dic[@"groupName"]];
    }
    self.tabScrollView.dataArray = tempArray;
    [self.tabScrollView scrollToIndex:1];
    self.headerView.titleLabel.text = cellDic[@"title"];
    self.userDataView.dataArray = self.dataArray[self.tabScrollView.currentIndex][@"groupList"];
    if ([cellDic[@"tip"] length] > 0) {
        [self.headerView.moreBtn setTitle:cellDic[@"tip"] forState:0];
    }
}

#pragma mark ------------UI-------------
- (QHWTableSectionHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[QHWTableSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW-30, 55)];
        _headerView.tagImgView.image = kImageMake(@"home_card_data");
        _headerView.tagImgWidth = 20;
        _headerView.titleLabel.text = @"名片数据";
        _headerView.moreBtn.hidden = NO;
        _headerView.moreBtn.userInteractionEnabled = NO;
    }
    return _headerView;
}

- (UserDataView *)userDataView {
    if (!_userDataView) {
        _userDataView = [[UserDataView alloc] initWithFrame:CGRectMake(0, self.headerView.bottom, kScreenW-30, 45)];
        _userDataView.countColor = kColorTheme21a8ff;
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
