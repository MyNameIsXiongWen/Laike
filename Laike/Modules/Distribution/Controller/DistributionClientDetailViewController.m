//
//  DistributionClientDetailViewController.m
//  Laike
//
//  Created by xiaobu on 2020/7/6.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "DistributionClientDetailViewController.h"
#import "DistributionClientDetailHeaderView.h"
#import "AdvisoryDetailViewController.h"
#import "CRMTrackCell.h"
#import "DistributionService.h"
#import "CRMService.h"

@interface DistributionClientDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) AdvisoryDetailBottomView *btmView;
@property (nonatomic, strong) DistributionClientDetailHeaderView *tableHeaderView;
@property (nonatomic, strong) DistributionService *distributionService;

@end

@implementation DistributionClientDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.kNavigationView.title = @"报备详情";
    [self.view addSubview:self.btmView];
}

- (void)getMainData {
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    [self.distributionService getClientDetailInfoRequestComplete:^{
        dispatch_group_leave(group);
        self.kNavigationView.title = self.distributionService.clientDetailModel.name ?: @"报备详情";
    }];
    dispatch_group_enter(group);
    [self.distributionService getClientDetailTrackListRequestComplete:^{
        dispatch_group_leave(group);
    }];
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if ([self.tableView.mj_header isRefreshing]) {
            [self.tableView.mj_header endRefreshing];
        }
        if ([self.tableView.mj_footer isRefreshing]) {
            [self.tableView.mj_footer endRefreshing];
        }
        self.tableHeaderView.height = self.distributionService.tableHeaderViewHeight;
        self.tableHeaderView.clientDetailModel = self.distributionService.clientDetailModel;
        [QHWRefreshManager.sharedInstance endRefreshWithScrollView:self.tableView PageModel:self.distributionService.itemPageModel];
        [self.tableView showNodataView:self.distributionService.tableViewDataArray.count == 0 offsetY:self.distributionService.tableHeaderViewHeight button:nil];
        [self.tableView reloadData];
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.distributionService.tableViewDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CRMTrackModel *model = (CRMTrackModel *)self.distributionService.tableViewDataArray[indexPath.row];
    return model.trackHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CRMTrackModel *model = (CRMTrackModel *)self.distributionService.tableViewDataArray[indexPath.row];
    CRMTrackCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(CRMTrackCell.class)];
    cell.titleLabel.text = model.followName;
    cell.timeLabel.text = model.createTime;
    cell.contentLabel.text = model.content;
    cell.topLine.hidden = indexPath.row == 0;
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

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UICreateView initWithFrame:CGRectMake(0, kTopBarHeight, kScreenW, kScreenH-kTopBarHeight-kBottomDangerHeight-75) Style:UITableViewStylePlain Object:self];
        _tableView.tableHeaderView = self.tableHeaderView;
        [_tableView registerClass:CRMTrackCell.class forCellReuseIdentifier:NSStringFromClass(CRMTrackCell.class)];
        [QHWRefreshManager.sharedInstance normalHeaderWithScrollView:_tableView RefreshBlock:^{
            self.distributionService.itemPageModel.pagination.currentPage = 1;
            [self getMainData];
        }];
        [QHWRefreshManager.sharedInstance normalFooterWithScrollView:_tableView RefreshBlock:^{
            self.distributionService.itemPageModel.pagination.currentPage++;
            [self getMainData];
        }];
        [self.view addSubview:_tableView];
        [self.view sendSubviewToBack:_tableView];
    }
    return _tableView;
}

- (DistributionClientDetailHeaderView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[DistributionClientDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 140)];
    }
    return _tableHeaderView;
}

- (AdvisoryDetailBottomView *)btmView {
    if (!_btmView) {
        _btmView = [[AdvisoryDetailBottomView alloc] initWithFrame:CGRectMake(0, kScreenH-kBottomDangerHeight-75, kScreenW, 75)];
        _btmView.customerId = self.customerId;
        [_btmView.convertCRMBtn setTitle:@"客服" forState:0];
        WEAKSELF
        _btmView.clickLeftBtnBlock = ^{
            
        };
        _btmView.clickRightBtnBlock = ^{
            
        };
    }
    return _btmView;
}

- (DistributionService *)distributionService {
    if (!_distributionService) {
        _distributionService = DistributionService.new;
        _distributionService.customerId = self.customerId;
    }
    return _distributionService;
}

@end
