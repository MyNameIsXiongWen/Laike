//
//  ActivityScrollContentViewController.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/6/2.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "ActivityScrollContentViewController.h"
#import "QHWSystemService.h"
#import "QHWBaseCellProtocol.h"
#import "CTMediator+ViewController.h"

@interface ActivityScrollContentViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) QHWSystemService *service;

@end

@implementation ActivityScrollContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)addTableView {
    self.tableView = [UICreateView initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-kTopBarHeight-44) Style:UITableViewStylePlain Object:self];
    [self.tableView registerClass:NSClassFromString(@"QHWActivityTableViewCell") forCellReuseIdentifier:@"QHWActivityTableViewCell"];
    [QHWRefreshManager.sharedInstance normalHeaderWithScrollView:self.tableView RefreshBlock:^{
        self.service.itemPageModel.pagination.currentPage = 1;
        [self getMainData];
    }];
    [QHWRefreshManager.sharedInstance normalFooterWithScrollView:self.tableView RefreshBlock:^{
        self.service.itemPageModel.pagination.currentPage++;
        [self getMainData];
    }];
    [self.view addSubview:self.tableView];
}

- (void)getMainData {
    [self.service getActivityListRequestWithIndustryId:0 RegisterStatus:self.registerStatus Complete:^{
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

- (QHWSystemService *)service {
    if (!_service) {
        _service = QHWSystemService.new;
    }
    return _service;
}

@end
