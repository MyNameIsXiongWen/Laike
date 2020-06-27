//
//  ActivityListViewController.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/6/12.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "ActivityListViewController.h"
#import "QHWSystemService.h"
#import "QHWBaseCellProtocol.h"
#import "CTMediator+ViewController.h"

@interface ActivityListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ActivityHeaderView *tableHeaderView;
@property (nonatomic, strong) QHWSystemService *service;

@end

@implementation ActivityListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.kNavigationView.title = @"活动列表";
    [self getActivityRequest];
    [self getBannerRequest];
}

- (void)getBannerRequest {
    [self.service getBannerRequestWithAdvertPage:17 Complete:^(id  _Nullable response) {
        self.tableHeaderView.height = self.service.bannerArray.count == 0 ? 0 : 155;
        self.tableHeaderView.bannerView.imgArray = self.service.bannerArray;
        [self.tableView reloadData];
    }];
}

- (void)getActivityRequest {
    [self.service getActivityListRequestWithIndustryId:0 RegisterStatus:0 Complete:^{
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
        [QHWRefreshManager.sharedInstance endRefreshWithScrollView:self.tableView PageModel:self.service.itemPageModel];
        [self.tableView showNodataView:self.service.activityArray.count == 0 offsetY:0 button:nil];
    }];
}

#pragma mark ------------UITableViewDelegate-------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.service.activityArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    QHWActivityModel *model = self.service.activityArray[indexPath.row];
    return model.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.service.activityArray.count) {
        QHWActivityModel *model = self.service.activityArray[indexPath.row];
        UITableViewCell <QHWBaseCellProtocol>*cell = [tableView dequeueReusableCellWithIdentifier:@"QHWActivityTableViewCell"];
        [cell configCellData:model];
        return cell;
    }
    return UITableViewCell.new;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QHWActivityModel *model = self.service.activityArray[indexPath.row];
    [CTMediator.sharedInstance CTMediator_viewControllerForActivityDetailWithActivityId:model.id];
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
        _tableView = [UICreateView initWithFrame:CGRectMake(0, kTopBarHeight, kScreenW, kScreenH-kTopBarHeight) Style:UITableViewStylePlain Object:self];
        _tableView.tableHeaderView = self.tableHeaderView;
        [_tableView registerClass:NSClassFromString(@"QHWActivityTableViewCell") forCellReuseIdentifier:@"QHWActivityTableViewCell"];
        [QHWRefreshManager.sharedInstance normalHeaderWithScrollView:_tableView RefreshBlock:^{
            self.service.itemPageModel.pagination.currentPage = 1;
            [self getActivityRequest];
        }];
        [QHWRefreshManager.sharedInstance normalFooterWithScrollView:_tableView RefreshBlock:^{
            self.service.itemPageModel.pagination.currentPage++;
            [self getActivityRequest];
        }];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (ActivityHeaderView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[ActivityHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 155)];
    }
    return _tableHeaderView;
}

- (QHWSystemService *)service {
    if (!_service) {
        _service = QHWSystemService.new;
    }
    return _service;
}

@end

@implementation ActivityHeaderView

- (QHWCycleScrollView *)bannerView {
    if (!_bannerView) {
        _bannerView = [[QHWCycleScrollView alloc] initWithFrame:CGRectMake(15, 0, kScreenW-30, 140)];
        _bannerView.imgCornerRadius = 10;
        [self addSubview:_bannerView];
    }
    return _bannerView;
}

@end
