//
//  CompanyProductScrollContentViewController.m
//  GoOverSeas
//
//  Created by xiaobu on 2019/9/17.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "CompanyProductScrollContentViewController.h"
#import "QHWBaseCellProtocol.h"
#import "HomeService.h"
#import "CTMediator+ViewController.h"

@interface CompanyProductScrollContentViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) HomeService *service;

@end

@implementation CompanyProductScrollContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)addTableView {
    CGFloat height = kScreenH-kTopBarHeight-48;
    self.tableView = [UICreateView initWithFrame:CGRectMake(0, 0, kScreenW, height) Style:UITableViewStylePlain Object:self];
    [self.view addSubview:self.tableView];
    [QHWRefreshManager.sharedInstance normalHeaderWithScrollView:self.tableView RefreshBlock:^{
        self.service.itemPageModel.pagination.currentPage = 1;
        [self getMainData];
    }];
    [QHWRefreshManager.sharedInstance normalFooterWithScrollView:self.tableView RefreshBlock:^{
        self.service.itemPageModel.pagination.currentPage++;
        [self getMainData];
    }];
}

- (void)getMainData {
    [self.service getHomePageProductListRequestWithIdentifier:self.identifier Complete:^{
        for (QHWBaseModel *baseModel in self.service.tableViewDataArray) {
            [self.tableView registerClass:NSClassFromString(baseModel.identifier) forCellReuseIdentifier:baseModel.identifier];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
        [self.tableView showNodataView:self.service.tableViewDataArray.count == 0 offsetY:0 Text:@"您所在公司未发布产品"];
        [QHWRefreshManager.sharedInstance endRefreshWithScrollView:self.tableView PageModel:self.service.itemPageModel];
    }];
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
        NSArray *array = (NSArray *)self.service.tableViewDataArray[indexPath.row].data;
        QHWMainBusinessDetailBaseModel *baseModel = (QHWMainBusinessDetailBaseModel *)array.firstObject;
        for (NSDictionary *dic in self.service.tableViewCellArray) {
            if ([self.identifier isEqualToString:dic[@"identifier"]]) {
                [CTMediator.sharedInstance CTMediator_viewControllerForMainBusinessDetailWithBusinessType:[dic[@"businessType"] integerValue] BusinessId:baseModel.id];
                break;
            }
        }
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
        _service.pageType = 1;
    }
    return _service;
}

@end
