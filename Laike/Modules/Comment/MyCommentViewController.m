//
//  MyCommentViewController.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/23.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "MyCommentViewController.h"
#import "MyCommentTableViewCell.h"
#import "QHWCommentService.h"
#import "QHWAlertView.h"

@interface MyCommentViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) QHWCommentService *service;

@end

@implementation MyCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.kNavigationView.title = @"我的评论";
    [self getCommentListRequest];
}

- (void)getCommentListRequest{
    [self.service getMyCommentListRequestComplete:^{
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView showNodataView:self.service.dataArray.count == 0 offsetY:0 button:nil];
        [QHWRefreshManager.sharedInstance endRefreshWithScrollView:self.tableView PageModel:self.service.itemPageModel];
    }];
}

#pragma mark --------------UITableViewDataSource-----------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.service.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MyCommentTableViewCell.class)];
    MyCommentModel *model = self.service.dataArray[indexPath.section];
    cell.model = model;
    WEAKSELF
    cell.longPressBlock = ^(NSString * _Nonnull commentId) {
        [weakSelf longPressCell:commentId];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.service.dataArray.count) {
        MyCommentModel *model = self.service.dataArray[indexPath.section];
        return model.cellHeight;
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section > 0) {
        UIView *headView = UIView.viewFrame(CGRectMake(0, 0, kScreenW, 5)).bkgColor(kColorThemef5f5f5);
        return headView;
    }
    return UIView.new;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section > 0) {
        return 5;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (void)longPressCell:(NSString *)commentId {
    __block QHWAlertView *alert = [[QHWAlertView alloc] initWithFrame:CGRectZero];
    [alert configWithTitle:@"确定删除？" cancleText:@"取消" confirmText:@"删除"];
    WEAKSELF
    alert.confirmBlock = ^{
        [alert dismiss];
        [weakSelf.service deleteCommentRequestWithCommentId:commentId Complete:^{
            weakSelf.service.itemPageModel.pagination.currentPage = 1;
            [weakSelf getCommentListRequest];
        }];
    };
    [alert show];
}

#pragma mark -----------UI-----------
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UICreateView initWithFrame:CGRectMake(0, kTopBarHeight, kScreenW, kScreenH-kTopBarHeight) Style:UITableViewStyleGrouped Object:self];
        [_tableView registerClass:MyCommentTableViewCell.class forCellReuseIdentifier:NSStringFromClass(MyCommentTableViewCell.class)];
        [self.view addSubview:_tableView];
        WEAKSELF
        [QHWRefreshManager.sharedInstance normalHeaderWithScrollView:_tableView RefreshBlock:^{
            weakSelf.service.itemPageModel.pagination.currentPage = 1;
            [weakSelf getCommentListRequest];
        }];
        [QHWRefreshManager.sharedInstance normalFooterWithScrollView:_tableView RefreshBlock:^{
            weakSelf.service.itemPageModel.pagination.currentPage ++;
            [weakSelf getCommentListRequest];
        }];
    }
    return _tableView;
}

- (QHWCommentService *)service {
    if (!_service) {
        _service = QHWCommentService.new;
    }
    return _service;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
