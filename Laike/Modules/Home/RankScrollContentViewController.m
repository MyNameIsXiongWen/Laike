//
//  RankScrollContentViewController.m
//  Laike
//
//  Created by xiaobu on 2020/6/23.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "RankScrollContentViewController.h"
#import "QHWSystemService.h"
#import "UserModel.h"

@interface RankScrollContentViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) QHWSystemService *systemService;

@end

@implementation RankScrollContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)addTableView {
    self.tableView = [UICreateView initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-180-48) Style:UITableViewStylePlain Object:self];
    self.tableView.rowHeight = 70;
    [self.tableView registerClass:RankTableViewCell.class forCellReuseIdentifier:NSStringFromClass(RankTableViewCell.class)];
    [QHWRefreshManager.sharedInstance normalHeaderWithScrollView:self.tableView RefreshBlock:^{
        self.systemService.itemPageModel.pagination.currentPage = 1;
        [self getMainData];
    }];
    [QHWRefreshManager.sharedInstance normalFooterWithScrollView:self.tableView RefreshBlock:^{
        self.systemService.itemPageModel.pagination.currentPage++;
        [self getMainData];
    }];
    [self.view addSubview:self.tableView];
}

- (void)getMainData {
    [self.systemService getLikeRankRequestWithSubjectType:self.rankType Complete: ^{
        [self.tableView reloadData];
        if ([self.tableView.mj_header isRefreshing]) {
            [self.tableView.mj_header endRefreshing];
        }
        if ([self.tableView.mj_footer isRefreshing]) {
            [self.tableView.mj_footer endRefreshing];
        }
        [QHWRefreshManager.sharedInstance endRefreshWithScrollView:self.tableView PageModel:self.systemService.itemPageModel];
        [self.tableView showNodataView:self.systemService.consultantArray.count == 0 offsetY:228 button:nil];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.rankType == 1) {
        return self.systemService.consultantArray.count + 1;
    }
    return self.systemService.consultantArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(RankTableViewCell.class)];
    if (self.rankType == 1) {
        if (indexPath.row == 0) {
            UserModel *user = UserModel.shareUser;
            cell.rankImgView.image = [UIImage imageWithColor:kColorThemea4abb3 size:CGSizeMake(20, 30) text:kFormat(@"%ld", indexPath.row) textAttributes:@{NSForegroundColorAttributeName: kColorTheme21a8ff} circular:YES];
            [cell.avatarImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(user.headPath)]];
            cell.nameLabel.text = user.realName;
            cell.sloganLabel.text = user.slogan ?: @"暂无";
            cell.rankLabel.text = kFormat(@"%ld", user.likeCount);
            cell.contentView.backgroundColor = kColorThemef5f5f5;
        } else {
            QHWConsultantModel *model = self.systemService.consultantArray[indexPath.row-1];
            cell.rankImgView.image = [UIImage imageWithColor:kColorThemea4abb3 size:CGSizeMake(20, 30) text:kFormat(@"%ld", indexPath.row) textAttributes:@{NSForegroundColorAttributeName: kColorTheme21a8ff} circular:YES];
            [cell.avatarImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(model.headPath)]];
            cell.nameLabel.text = model.name;
            cell.sloganLabel.text = model.slogan ?: @"暂无";
            cell.rankLabel.text = kFormat(@"%ld", model.likeCount);
        }
    } else {
        QHWConsultantModel *model = self.systemService.consultantArray[indexPath.row];
        cell.rankImgView.image = [UIImage imageWithColor:kColorThemea4abb3 size:CGSizeMake(20, 30) text:kFormat(@"%ld", indexPath.row+1) textAttributes:@{NSForegroundColorAttributeName: kColorTheme21a8ff} circular:YES];
        [cell.avatarImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(model.headPath)]];
        cell.nameLabel.text = model.name;
        cell.sloganLabel.text = model.slogan ?: @"暂无";
        cell.rankLabel.text = kFormat(@"%ld", model.likeCount);
    }
    return cell;
}

- (QHWSystemService *)systemService {
    if (!_systemService) {
        _systemService = QHWSystemService.new;
    }
    return _systemService;
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
            make.top.equalTo(self.nameLabel.mas_bottom).offset(2);
            make.right.equalTo(self.rankLabel.mas_left).offset(-5);
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
        _avatarImgView = UIImageView.ivInit().ivCornerRadius(25).ivBorderColor(kColorThemeeee);
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
        [_rankNameLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
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
