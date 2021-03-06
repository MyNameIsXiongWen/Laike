//
//  HomeCustomerTableViewCell.m
//  Laike
//
//  Created by xiaobu on 2020/6/22.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "HomeCustomerTableViewCell.h"
#import "QHWTableSectionHeaderView.h"

@interface HomeCustomerTableViewCell () <QHWBaseCellProtocol>

@property (nonatomic, strong) QHWTableSectionHeaderView *headerView;

@end

@implementation HomeCustomerTableViewCell

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
        [self.shadowView addSubview:self.headerView];
        [self.shadowView addSubview:self.userDataView];
    }
    return self;
}

- (void)configCellData:(id)data {
    self.userDataView.dataArray = (NSArray *)data;
}

- (QHWTableSectionHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[QHWTableSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW-30, 55)];
        _headerView.tagImgView.image = kImageMake(@"home_crm_data");
        _headerView.tagImgWidth = 20;
        _headerView.titleLabel.text = @"CRM";
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

@end
