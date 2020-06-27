//
//  HomeScrollContentViewController.m
//  GoOverSeas
//
//  Created by xiaobu on 2019/9/17.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "HomeScrollContentViewController.h"
#import "QHWBaseCellProtocol.h"
#import "HomeService.h"

@interface HomeScrollContentViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) HomeService *service;

@end

@implementation HomeScrollContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)addTableView {
    self.tableView = [UICreateView initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-kBottomBarHeight-kStatusBarHeight-32) Style:UITableViewStylePlain Object:self];
    [self.view addSubview:self.tableView];
    [QHWRefreshManager.sharedInstance normalFooterWithScrollView:self.tableView RefreshBlock:^{
        self.service.itemPageModel.pagination.currentPage++;
        [self getProductListRequest];
    }];
    [self getProductListRequest];
}

- (void)getProductListRequest {
    [self.service getHomePageProductListRequestWithIdentifier:self.identifier Complete:^{
        for (QHWBaseModel *baseModel in self.service.tableViewDataArray) {
            [self.tableView registerClass:NSClassFromString(baseModel.identifier) forCellReuseIdentifier:baseModel.identifier];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
        [self.tableView showNodataView:self.service.tableViewDataArray.count == 0 offsetY:0 button:nil];
        [QHWRefreshManager.sharedInstance endRefreshWithScrollView:self.tableView PageModel:self.service.itemPageModel];
    }];
}

#pragma mark ------------UIScrollView-------------
//判断屏幕触碰状态
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"接触屏幕");
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    NSLog(@"离开屏幕");
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.vcCanScroll) {
        scrollView.contentOffset = CGPointZero;
    }
    NSLog(@"subScroll======%f", scrollView.contentOffset.y);
    if (scrollView.contentOffset.y <= 0) {
        self.vcCanScroll = NO;
        scrollView.contentOffset = CGPointZero;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HomeSwipeLeaveTop" object:nil];//到顶通知父视图改变状态
    }
}

#pragma mark ------------UITableViewDelegate-------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.service.tableViewDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    QHWBaseModel *baseModel = self.service.tableViewDataArray[indexPath.row];
    return baseModel.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.service.tableViewDataArray.count) {
        QHWBaseModel *baseModel = self.service.tableViewDataArray[indexPath.row];
        UITableViewCell<QHWBaseCellProtocol> *cell = [tableView dequeueReusableCellWithIdentifier:baseModel.identifier];
        [cell configCellData:baseModel.data];
        return cell;
    }
    return UITableViewCell.new;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.service.tableViewDataArray.count) {
//        [self.service pushToTargetViewControllerWithIdentifier:self.identifier IndexPath:indexPath];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (HomeService *)service {
    if (!_service) {
        _service = HomeService.new;
        _service.pageType = self.pageType;
    }
    return _service;
}

@end
