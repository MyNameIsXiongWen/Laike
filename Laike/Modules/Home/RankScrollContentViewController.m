//
//  RankScrollContentViewController.m
//  Laike
//
//  Created by xiaobu on 2020/6/23.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "RankScrollContentViewController.h"

@interface RankScrollContentViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation RankScrollContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)addTableView {
    self.tableView = [UICreateView initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-kTopBarHeight-180-48) Style:UITableViewStylePlain Object:self];
    self.tableView.rowHeight = 70;
    [self.tableView registerClass:RankTableViewCell.class forCellReuseIdentifier:NSStringFromClass(RankTableViewCell.class)];
    [QHWRefreshManager.sharedInstance normalHeaderWithScrollView:self.tableView RefreshBlock:^{
        
    }];
    [QHWRefreshManager.sharedInstance normalFooterWithScrollView:self.tableView RefreshBlock:^{
        
    }];
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(RankTableViewCell.class)];
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

@implementation RankTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.rankImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(20, 30));
        }];
        [self.avatarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.rankImgView.mas_right).offset(15);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        [self.rankNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.equalTo(self.contentView);
        }];
        [self.rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.rankNameLabel.mas_left);
            make.centerY.equalTo(self.contentView);
        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatarImgView.mas_right).offset(15);
            make.top.equalTo(self.avatarImgView.mas_top).offset(5);
            make.right.equalTo(self.rankLabel.mas_left).offset(5);
        }];
        [self.sloganLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.mas_left);
            make.top.equalTo(self.nameLabel.mas_top).offset(2);
            make.right.equalTo(self.rankLabel.mas_left).offset(5);
        }];
    }
    return self;
}

#pragma mark ------------UI-------------
- (UIImageView *)rankImgView {
    if (!_rankImgView) {
        _rankImgView = UIImageView.ivInit();
        [self.contentView addSubview:_rankImgView];
    }
    return _rankImgView;
}

- (UIImageView *)avatarImgView {
    if (!_avatarImgView) {
        _avatarImgView = UIImageView.ivInit().ivCornerRadius(25);
        [self.contentView addSubview:_avatarImgView];
    }
    return _avatarImgView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = UILabel.labelInit().labelFont(kFontTheme14).labelTitleColor(kColorTheme21a8ff);
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (UILabel *)sloganLabel {
    if (!_sloganLabel) {
        _sloganLabel = UILabel.labelInit().labelFont(kFontTheme12).labelTitleColor(kColorThemea4abb3).labelNumberOfLines(2);
        [self.contentView addSubview:_sloganLabel];
    }
    return _sloganLabel;
}

- (UILabel *)rankNameLabel {
    if (!_rankNameLabel) {
        _rankNameLabel = UILabel.labelInit().labelFont(kFontTheme12).labelText(@"人气").labelTitleColor(kColorThemea4abb3);
        [self.contentView addSubview:_rankNameLabel];
    }
    return _rankNameLabel;
}

- (UILabel *)rankLabel {
    if (!_rankLabel) {
        _rankLabel = UILabel.labelInit().labelFont(kMediumFontTheme18).labelTitleColor(kColorThemeff7919).labelTextAlignment(NSTextAlignmentRight);
        [self.contentView addSubview:_rankLabel];
    }
    return _rankLabel;
}

@end
