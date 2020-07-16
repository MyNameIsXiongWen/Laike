//
//  MineDataTableViewCell.m
//  Laike
//
//  Created by xiaobu on 2020/6/22.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "MineDataTableViewCell.h"
#import "UserDataView.h"

@interface MineDataTableViewCell () <QHWBaseCellProtocol>

@property (nonatomic, strong) UserDataView *userDataView;

@end

@implementation MineDataTableViewCell

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
        [self.shadowView addSubview:self.userDataView];
    }
    return self;
}

- (void)configCellData:(id)data {
    self.userDataView.dataArray = (NSArray *)data;
}

- (UserDataView *)userDataView {
    if (!_userDataView) {
        _userDataView = [[UserDataView alloc] initWithFrame:CGRectMake(0, 15, kScreenW-30, 45)];
        _userDataView.countColor = kColorTheme21a8ff;
        _userDataView.userInteractionEnabled = NO;
    }
    return _userDataView;
}

@end
