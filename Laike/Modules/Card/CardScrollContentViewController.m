//
//  CardScrollContentViewController.m
//  Laike
//
//  Created by xiaobu on 2020/6/23.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "CardScrollContentViewController.h"
#import "QHWGeneralTableViewCell.h"
#import "RelatedToMeTableViewCell.h"

@interface CardScrollContentViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation CardScrollContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)addTableView {
    self.tableView = [UICreateView initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-kTopBarHeight-180-48) Style:UITableViewStylePlain Object:self];
    self.tableView.rowHeight = 80;
    [self.tableView registerClass:QHWGeneralTableViewCell.class forCellReuseIdentifier:NSStringFromClass(QHWGeneralTableViewCell.class)];
    [self.tableView registerClass:VisitorTableViewCell.class forCellReuseIdentifier:NSStringFromClass(VisitorTableViewCell.class)];
    [self.tableView registerClass:RelatedToMeTableViewCell.class forCellReuseIdentifier:NSStringFromClass(RelatedToMeTableViewCell.class)];
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
    VisitorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(VisitorTableViewCell.class)];
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

@implementation VisitorTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.size.mas_equalTo(CGSizeMake(50, 50));
            make.centerY.equalTo(self);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftImageView.mas_right).offset(10);
            make.top.equalTo(self.leftImageView.mas_top).offset(5);
        }];
        [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_left);
            make.top.equalTo(self.titleLabel.mas_top).offset(5);
        }];
        [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20);
            make.top.equalTo(self.titleLabel.mas_top);
        }];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.5);
            make.left.right.bottom.mas_equalTo(0);
        }];
    }
    return self;
}

#pragma mark ------------UI-------------
- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = UIImageView.ivInit().ivImage(kImageMake(@"arrow_right_gray"));
        [self.contentView addSubview:_arrowImageView];
    }
    return _arrowImageView;
}

- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = UIImageView.ivInit();
        [self.contentView addSubview:_leftImageView];
    }
    return _leftImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.labelInit().labelTitleColor(kColorTheme2a303c).labelFont(kFontTheme14);
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = UILabel.labelInit().labelTitleColor(kColorThemea4abb3).labelFont(kFontTheme12);
        [self.contentView addSubview:_subTitleLabel];
    }
    return _subTitleLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = UILabel.labelInit().labelTitleColor(kColorThemea4abb3).labelFont(kFontTheme14);
        [self.contentView addSubview:_detailLabel];
    }
    return _detailLabel;
}

- (UIView *)line {
    if (!_line) {
        _line = UIView.viewInit().bkgColor(kColorThemeeee);
        [self.contentView addSubview:_line];
    }
    return _line;
}

@end
