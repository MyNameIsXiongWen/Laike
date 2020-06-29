//
//  QSchoolCommentViewController.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/6/11.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QSchoolCommentViewController.h"
#import <IQKeyboardManager.h>
#import "QHWCommentService.h"
#import "CommentBottomView.h"
#import "QHWSystemService.h"
#import "LiveCommentViewController.h"

@interface QSchoolCommentViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) CommentBottomView *bottomView;
@property (nonatomic, strong) QHWCommentService *service;

@end

@implementation QSchoolCommentViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    IQKeyboardManager.sharedManager.enable = NO;
    IQKeyboardManager.sharedManager.shouldResignOnTouchOutside = NO;
    IQKeyboardManager.sharedManager.enableAutoToolbar = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    IQKeyboardManager.sharedManager.enable = YES;
    IQKeyboardManager.sharedManager.shouldResignOnTouchOutside = YES;
    IQKeyboardManager.sharedManager.enableAutoToolbar = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(getCommentListRequest) name:kNotificationAddCommentSuccess object:nil];
}

- (void)addTableView {
    self.tableView = [UICreateView initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-kTopBarHeight-48-200) Style:UITableViewStylePlain Object:self];
    [self.tableView registerClass:LiveCommentListCell.class forCellReuseIdentifier:NSStringFromClass(LiveCommentListCell.class)];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    [QHWRefreshManager.sharedInstance normalFooterWithScrollView:self.tableView RefreshBlock:^{
        self.service.itemPageModel.pagination.currentPage++;
        [self getCommentListRequest];
    }];
    [self getCommentListRequest];
}

- (void)getCommentListRequest {
    [self.service getQSchoolCommentListRequestComplete:^{
        [self.tableView.mj_footer endRefreshing];
        [QHWRefreshManager.sharedInstance endRefreshWithScrollView:self.tableView PageModel:self.service.itemPageModel];
        [self.tableView showNodataView:self.service.dataArray.count == 0 offsetY:0 button:nil];
        for (QHWCommentModel *model in self.service.dataArray) {
            model.businessType = 103001;
        }
        [self.tableView reloadData];
    }];
}

#pragma mark --------------UITableViewDataSource-----------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.service.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    QHWCommentModel *model = self.service.dataArray[indexPath.row];
    return model.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LiveCommentListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(LiveCommentListCell.class)];
    cell.commentModel = self.service.dataArray[indexPath.row];
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

- (CommentBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[CommentBottomView alloc] initWithFrame:CGRectMake(0, kScreenH-kTopBarHeight-248-(50+kBottomDangerHeight), kScreenW, 50)];
        WEAKSELF
        [_bottomView.commentButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
        }];
        _bottomView.bottomViewCommentBlock = ^{
            weakSelf.service.commentType = CommentTypeQSchoolAdd;
            [weakSelf.service showCommentKeyBoardWithCommentName:@""];
        };
        _bottomView.praiseButton.hidden = YES;
    }
    return _bottomView;
}

- (QHWCommentService *)service {
    if (!_service) {
        _service = QHWCommentService.new;
        _service.communityId = self.schoolModel.id;
    }
    return _service;
}

@end
