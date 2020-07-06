//
//  DistributionClientScrollContentViewController.m
//  Laike
//
//  Created by xiaobu on 2020/7/4.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "DistributionClientScrollContentViewController.h"
#import "DistributionService.h"
#import "DistributionClientDetailViewController.h"

@interface DistributionClientScrollContentViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) DistributionService *disService;

@end

@implementation DistributionClientScrollContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)addTableView {
    self.tableView = [UICreateView initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-kTopBarHeight-48) Style:UITableViewStylePlain Object:self];
    self.tableView.rowHeight = 80;
    [self.tableView registerClass:DistributionClientCell.class forCellReuseIdentifier:NSStringFromClass(DistributionClientCell.class)];
    [QHWRefreshManager.sharedInstance normalHeaderWithScrollView:self.tableView RefreshBlock:^{
        self.disService.itemPageModel.pagination.currentPage = 1;
        [self getMainData];
    }];
    [QHWRefreshManager.sharedInstance normalFooterWithScrollView:self.tableView RefreshBlock:^{
        self.disService.itemPageModel.pagination.currentPage++;
        [self getMainData];
    }];
    [self.view addSubview:self.tableView];
}

- (void)getMainData {
    [self.disService getClientListRequestWithFollowStatusCode:self.followStatusCode Complete:^{
        if ([self.tableView.mj_header isRefreshing]) {
            [self.tableView.mj_header endRefreshing];
        }
        if ([self.tableView.mj_footer isRefreshing]) {
            [self.tableView.mj_footer endRefreshing];
        }
        [self.tableView reloadData];
        [self.tableView showNodataView:self.disService.tableViewDataArray.count == 0 offsetY:0 button:nil];
        [QHWRefreshManager.sharedInstance endRefreshWithScrollView:self.tableView PageModel:self.disService.itemPageModel];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.disService.tableViewDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DistributionClientCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(DistributionClientCell.class)];
    ClientModel *model = (ClientModel *)self.disService.tableViewDataArray[indexPath.row];
    if (model.headPath.length > 0) {
        [cell.avatarImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(model.headPath)]];
    } else {
        cell.avatarImgView.image = [UIImage imageWithColor:kColorThemefff size:CGSizeMake(50, 50) text:model.realName textAttributes:@{NSForegroundColorAttributeName: kColorTheme21a8ff} circular:YES];
    }
    cell.nameLabel.text = model.realName;
    cell.sloganLabel.text = model.name;
//    cell.statusLabel.text = model.name;
//    cell.timeLabel.text = model.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ClientModel *model = (ClientModel *)self.disService.tableViewDataArray[indexPath.row];
    DistributionClientDetailViewController *vc = DistributionClientDetailViewController.new;
    vc.customerId = model.id;
    [self.getCurrentMethodCallerVC.navigationController pushViewController:vc animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (DistributionService *)disService {
    if (!_disService) {
        _disService = DistributionService.new;
    }
    return _disService;
}

@end

@implementation DistributionClientCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.avatarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.top.equalTo(self.avatarImgView.mas_top).offset(5);
        }];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(2);
        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatarImgView.mas_right).offset(15);
            make.top.equalTo(self.statusLabel.mas_top);
            make.right.equalTo(self.statusLabel.mas_left).offset(-5);
        }];
        [self.sloganLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.mas_left);
            make.top.equalTo(self.timeLabel.mas_top);
            make.right.equalTo(self.timeLabel.mas_left).offset(-5);
        }];
    }
    return self;
}

#pragma mark ------------UI-------------
- (UIImageView *)avatarImgView {
    if (!_avatarImgView) {
        _avatarImgView = UIImageView.ivInit().ivCornerRadius(25).ivBorderColor(kColorThemeeee);
        [self.contentView addSubview:_avatarImgView];
    }
    return _avatarImgView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = UILabel.labelInit().labelFont(kMediumFontTheme14).labelTitleColor(kColorTheme000);
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

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = UILabel.labelInit().labelFont(kMediumFontTheme14).labelTitleColor(kColorTheme000).labelTextAlignment(NSTextAlignmentRight);
        [_statusLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.contentView addSubview:_statusLabel];
    }
    return _statusLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = UILabel.labelInit().labelFont(kFontTheme12).labelTitleColor(kColorThemea4abb3).labelTextAlignment(NSTextAlignmentRight);
        [_timeLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}

@end
