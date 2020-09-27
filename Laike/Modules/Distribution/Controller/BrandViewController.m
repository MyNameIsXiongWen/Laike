//
//  BrandViewController.m
//  Laike
//
//  Created by xiaobu on 2020/9/24.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "BrandViewController.h"
#import "CTMediator+ViewController.h"
#import "BrandTableViewCell.h"
#import "BrandService.h"

@interface BrandViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) BrandService *service;

@end

@implementation BrandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.kNavigationView.title = @"品牌馆";
    [self getBrandListRequest];
}

- (void)getBrandListRequest {
    [self.service getBrandListRequestComplete:^{
        [self.tableView reloadData];
        [self.tableView showNodataView:self.service.tableViewDataArray.count == 0 offsetY:0 button:nil];
        [QHWRefreshManager.sharedInstance endRefreshWithScrollView:self.tableView PageModel:self.service.itemPageModel];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.service.tableViewDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BrandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(BrandTableViewCell.class)];
    cell.model = (BrandModel *)self.service.tableViewDataArray[indexPath.row];
    cell.detailCell = NO;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BrandModel *model = self.dataArray[indexPath.row];
    [CTMediator.sharedInstance CTMediator_viewControllerForBrandDetailWithBrandId:model.id];
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
        _tableView.rowHeight = 95;
        [_tableView registerClass:BrandTableViewCell.class forCellReuseIdentifier:NSStringFromClass(BrandTableViewCell.class)];
        [QHWRefreshManager.sharedInstance normalHeaderWithScrollView:_tableView RefreshBlock:^{
            self.service.itemPageModel.pagination.currentPage = 1;
            [self getBrandListRequest];
        }];
        [QHWRefreshManager.sharedInstance normalFooterWithScrollView:_tableView RefreshBlock:^{
            self.service.itemPageModel.pagination.currentPage++;
            [self getBrandListRequest];
        }];
    }
    return _tableView;
}

- (BrandService *)service {
    if (!_service) {
        _service = BrandService.new;
    }
    return _service;
}

@end
