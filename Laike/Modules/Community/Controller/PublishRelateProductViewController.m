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

@interface PublishRelateProductViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) QHWItemPageModel *itemPageModel;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation PublishRelateProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.kNavigationView.title = @"关联产品";
    self.kNavigationView.rightBtn.btnTitle(@"确定").btnTitleColor(kColorTheme21a8ff);
}

- (void)getMainData {
    [QHWHttpManager.sharedInstance QHW_POST:kCommunityRelateProdect parameters:@{@"currentPage": @(self.itemPageModel.pagination.currentPage),
                                                                                 @"pageSize": @(self.itemPageModel.pagination.pageSize)} success:^(id responseObject) {
        if (self.itemPageModel.pagination.currentPage == 1) {
            [self.dataArray removeAllObjects];
        }
        [self.dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:QHWMainBusinessDetailBaseModel.class json:self.itemPageModel.list]];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class)];
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
        _tableView = [UICreateView initWithFrame:CGRectMake(0, kTopBarHeight, kScreenW, kScreenH-kTopBarHeight) Style:UITableViewStylePlain Object:self];
        _tableView.rowHeight = 60;
        [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (QHWItemPageModel *)itemPageModel {
    if (!_itemPageModel) {
        _itemPageModel = QHWItemPageModel.new;
    }
    return _itemPageModel;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = NSMutableArray.array;
    }
    return _dataArray;
}

@end
