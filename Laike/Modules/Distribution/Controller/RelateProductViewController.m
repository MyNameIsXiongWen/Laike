//
//  RelateProductViewController.m
//  Laike
//
//  Created by xiaobu on 2020/7/4.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "RelateProductViewController.h"
#import "HomeService.h"

@interface RelateProductViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HomeService *homeService;
@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation RelateProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.kNavigationView.title = @"报备产品";
    self.kNavigationView.rightBtn.btnTitle(@"确定").btnTitleColor(kColorTheme21a8ff);
    self.selectedIndex = 9999;
}

- (void)rightNavBtnAction:(UIButton *)sender {
    if (self.selectedIndex == 9999) {
        [SVProgressHUD showInfoWithStatus:@"请选择报备产品"];
        return;
    }
    if (self.didSelectProductBlock) {
        QHWMainBusinessDetailBaseModel *model = (QHWMainBusinessDetailBaseModel *)self.homeService.tableViewDataArray[self.selectedIndex].data;
        self.didSelectProductBlock(model.id, model.name);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getMainData {
    [self.homeService getHomePageProductListRequestWithIdentifier:self.identifier Complete:^{
        for (QHWBaseModel *baseModel in self.homeService.tableViewDataArray) {
            [self.tableView registerClass:NSClassFromString(baseModel.identifier) forCellReuseIdentifier:baseModel.identifier];
        }
        self.tableView.separatorStyle = self.homeService.tableViewDataArray.count > 0 ? UITableViewCellSeparatorStyleSingleLine : UITableViewCellSeparatorStyleNone;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
        [self.tableView showNodataView:self.homeService.tableViewDataArray.count == 0 offsetY:0 button:nil];
        [QHWRefreshManager.sharedInstance endRefreshWithScrollView:self.tableView PageModel:self.homeService.itemPageModel];
    }];
}

#pragma mark ------------UITableViewDelegate-------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.homeService.tableViewDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class)];
    QHWMainBusinessDetailBaseModel *model = (QHWMainBusinessDetailBaseModel *)self.homeService.tableViewDataArray[indexPath.row].data;
    cell.textLabel.text = model.name;
    cell.imageView.image = indexPath.row == self.selectedIndex ? kImageMake(@"product_selected") : kImageMake(@"product_unselected");
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndex = indexPath.row;
    [tableView reloadData];
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
        _tableView.rowHeight = 60;
        [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
        [QHWRefreshManager.sharedInstance normalHeaderWithScrollView:_tableView RefreshBlock:^{
            self.homeService.itemPageModel.pagination.currentPage = 1;
            [self getMainData];
        }];
        [QHWRefreshManager.sharedInstance normalFooterWithScrollView:_tableView RefreshBlock:^{
            self.homeService.itemPageModel.pagination.currentPage++;
            [self getMainData];
        }];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (HomeService *)homeService {
    if (!_homeService) {
        _homeService = HomeService.new;
        _homeService.pageType = 2;
    }
    return _homeService;
}

@end
