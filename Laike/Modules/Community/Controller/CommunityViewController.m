//
//  CommunityViewController.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/16.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "CommunityViewController.h"
#import "QHWContentTableViewCell.h"
#import "CommunityTableHeaderView.h"
#import "CommunityService.h"
#import "CTMediator+ViewController.h"
#import "HomeService.h"

@interface CommunityViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CommunityTableHeaderView *tableHeaderView;
@property (nonatomic, strong) CommunityService *communityService;
@property (nonatomic, strong) HomeService *homeService;

@end

@implementation CommunityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.kNavigationView.title = @"海外圈";
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(getMainData) name:kNotificationPublishSuccess object:nil];
    self.kNavigationView.rightBtn.frame = CGRectMake(kScreenW-80, kStatusBarHeight+7, 70, 30);
    self.kNavigationView.rightBtn.btnTitle(@"发布").btnFont(kFontTheme14).btnTitleColor(kColorThemefff).btnBkgColor(kColorTheme21a8ff).btnCornerRadius(10);
    self.kNavigationView.rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
}

- (void)rightNavBtnAction:(UIButton *)sender {
    [self.navigationController pushViewController:NSClassFromString(@"CommunityPublishViewController").new animated:YES];
}

- (void)getMainData {
    [self.communityService getCoummunityDataWithComplete:^{
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
        [QHWRefreshManager.sharedInstance endRefreshWithScrollView:self.tableView PageModel:self.communityService.itemPageModel];
        [self.tableView showNodataView:self.communityService.dataArray.count == 0 offsetY:175 button:nil];
    }];
    [self.homeService getHomeReportDataWithComplete:^{
        [self.tableHeaderView configCellData:self.homeService.reportArray];
    }];
}

#pragma mark ------------UITableViewDelegate-------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.communityService.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    QHWCommunityContentModel *model = self.communityService.dataArray[indexPath.row];
    return model.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = kFormat(@"QHWContentTableViewCell-%ld-%ld", (long)indexPath.section, (long)indexPath.row);
    QHWContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[QHWContentTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.contentModel = self.communityService.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QHWCommunityContentModel *model = self.communityService.dataArray[indexPath.row];
    [CTMediator.sharedInstance CTMediator_viewControllerForCommunityDetailWithCommunityId:model.id CommunityType:2];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark ------------UI-------------
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UICreateView initWithFrame:CGRectMake(0, kTopBarHeight, kScreenW, kScreenH-kTopBarHeight) Style:UITableViewStylePlain Object:self];
        [_tableView registerClass:QHWContentTableViewCell.class forCellReuseIdentifier:NSStringFromClass(QHWContentTableViewCell.class)];
        _tableView.tableHeaderView = self.tableHeaderView;
        [QHWRefreshManager.sharedInstance normalHeaderWithScrollView:_tableView RefreshBlock:^{
            self.communityService.itemPageModel.pagination.currentPage = 1;
            [self getMainData];
        }];
        [QHWRefreshManager.sharedInstance normalFooterWithScrollView:_tableView RefreshBlock:^{
            self.communityService.itemPageModel.pagination.currentPage++;
            [self getMainData];
        }];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (CommunityTableHeaderView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[CommunityTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 175)];
    }
    return _tableHeaderView;
}

- (CommunityService *)communityService {
    if (!_communityService) {
        _communityService = CommunityService.new;
        _communityService.communityType = 2;
    }
    return _communityService;
}

- (HomeService *)homeService {
    if (!_homeService) {
        _homeService = HomeService.new;
    }
    return _homeService;
}

@end
