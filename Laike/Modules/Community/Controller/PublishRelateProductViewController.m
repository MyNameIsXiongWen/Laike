//
//  PublishRelateProductViewController.m
//  Laike
//
//  Created by xiaobu on 2020/6/28.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "PublishRelateProductViewController.h"
#import "QHWItemPageModel.h"
#import "QHWMainBusinessDetailBaseModel.h"
#import "HomeService.h"

@interface PublishRelateProductViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HomeService *homeService;

@end

@implementation PublishRelateProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.kNavigationView.title = @"关联产品";
    self.kNavigationView.rightBtn.btnTitle(@"确定").btnTitleColor(kColorTheme21a8ff);
}

- (void)rightNavBtnAction:(UIButton *)sender {
    if (self.selectedArray.count == 0) {
        [SVProgressHUD showInfoWithStatus:@"请选择关联产品"];
        return;
    }
    if (self.selectProductBlock) {
        self.selectProductBlock(self.selectedArray);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getMainData {
    [self.homeService getHomePageProductListRequestWithIdentifier:self.identifier Complete:^{
        for (QHWBaseModel *baseModel in self.homeService.tableViewDataArray) {
            [self.tableView registerClass:NSClassFromString(baseModel.identifier) forCellReuseIdentifier:baseModel.identifier];
            NSArray *array = (NSArray *)baseModel.data;
            QHWMainBusinessDetailBaseModel *model = (QHWMainBusinessDetailBaseModel *)array.firstObject;
            if ([[self getSelectedIdArray] containsObject:model.id]) {
                model.selected = YES;
            }
        }
        self.tableView.separatorStyle = self.homeService.tableViewDataArray.count > 0 ? UITableViewCellSeparatorStyleSingleLine : UITableViewCellSeparatorStyleNone;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
        [self.tableView showNodataView:self.homeService.tableViewDataArray.count == 0 offsetY:0 button:nil];
        [QHWRefreshManager.sharedInstance endRefreshWithScrollView:self.tableView PageModel:self.homeService.itemPageModel];
    }];
}

- (NSMutableArray *)getSelectedIdArray {
    NSMutableArray *tempArray = NSMutableArray.array;
    for (QHWMainBusinessDetailBaseModel *model in self.selectedArray) {
        [tempArray addObject:model.id];
    }
    return tempArray;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.homeService.tableViewDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class)];
    NSArray *array = (NSArray *)self.homeService.tableViewDataArray[indexPath.row].data;
    QHWMainBusinessDetailBaseModel *model = (QHWMainBusinessDetailBaseModel *)array.firstObject;
    cell.textLabel.text = model.name;
    cell.imageView.image = model.selected ? kImageMake(@"product_selected") : kImageMake(@"product_unselected");
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *array = (NSArray *)self.homeService.tableViewDataArray[indexPath.row].data;
    QHWMainBusinessDetailBaseModel *model = (QHWMainBusinessDetailBaseModel *)array.firstObject;
    if (model.selected) {
        model.selected = !model.selected;
        for (QHWMainBusinessDetailBaseModel *tempModel in self.selectedArray) {
            if ([model.id isEqualToString:tempModel.id]) {
                [self.selectedArray removeObject:tempModel];
                break;
            }
        }
    } else {
        if (self.selectedArray.count < 5) {
            model.selected = !model.selected;
            [self.selectedArray addObject:model];
        } else {
            [SVProgressHUD showInfoWithStatus:@"最多关联5个产品"];
            return;
        }
    }
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
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
        _tableView.tableFooterView = UIView.new;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (HomeService *)homeService {
    if (!_homeService) {
        _homeService = HomeService.new;
        _homeService.pageType = 1;
    }
    return _homeService;
}

@end
