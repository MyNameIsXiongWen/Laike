//
//  CommentReplyListViewController.m
//  GoOverSeas
//
//  Created by manku on 2019/8/8.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "CommentReplyListViewController.h"
#import <IQKeyboardManager.h>
#import "CommentListCell.h"
#import "CommentBottomView.h"
#import "QHWCommentService.h"
#import "QHWSystemService.h"

@interface CommentReplyListViewController () <UITableViewDataSource, UITableViewDelegate, CommentListCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CommentBottomView *commentView;

@property (nonatomic, strong) QHWCommentService *service;

@end

@implementation CommentReplyListViewController

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCommentListRequest) name:kNotificationAddCommentSuccess object:nil];
    [self getCommentListRequest];
}

- (void)getCommentListRequest{
    [self.service getReplyListRequestComplete:^{
        for (QHWCommentModel *model in self.service.dataArray) {
            if (self.communityType == 1) {
                model.businessType = 7;
            } else {
                if (self.fileType == 1) {
                    model.businessType = 20;
                } else {
                    model.businessType = 23;
                }
            }
        }
        if (self.communityType == 1) {
            self.service.commentModel.businessType = 6;
        } else {
            if (self.fileType == 1) {
                self.service.commentModel.businessType = 19;
            } else {
                self.service.commentModel.businessType = 22;
            }
        }
        self.kNavigationView.title = kFormat(@"%ld条回复", (long)self.service.itemPageModel.pagination.total);
        self.commentView.commentLbl.text = kFormat(@"回复%@:", self.service.commentModel.releaseName);
        self.commentView.praiseButton.selected = self.service.commentModel.likeStatus == 2;
        self.commentView.praiseButton.btnBadgeLabel.text = kFormat(@"%ld", self.service.commentModel.likeCount);
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView showNodataView:self.service.dataArray.count == 0 offsetY:0 button:nil];
        [QHWRefreshManager.sharedInstance endRefreshWithScrollView:self.tableView PageModel:self.service.itemPageModel];
    }];
}

#pragma mark --------------UITableViewDataSource-----------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    } else {
        return self.service.dataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(CommentListCell.class)];
    cell.delegate = self;
    if (indexPath.section == 0) {
        cell.tag = indexPath.row + 100;
        cell.commentModel = self.service.commentModel;
    } else {
        cell.tag = indexPath.row + 200;
        if (indexPath.row < self.service.dataArray.count) {
            QHWCommentModel *model = self.service.dataArray[indexPath.row];
            cell.commentModel = model;
            cell.commentService = self.service;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return self.service.commentModel.cellHeight;
    } else {
        if (indexPath.row < self.service.dataArray.count) {
            QHWCommentModel *model = self.service.dataArray[indexPath.row];
            return model.cellHeight;
        }
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section > 0) {
        UIView *headView = UIView.viewFrame(CGRectMake(0, 0, kScreenW, 50));
        UIView *lineView = UIView.viewFrame(CGRectMake(0, 0, kScreenW, 10)).bkgColor(kColorThemeeee);
        UILabel *label = [UICreateView initWithFrame:CGRectMake(15, lineView.bottom, kScreenW-30, 50) Text:kFormat(@"全部回复%ld", self.service.itemPageModel.pagination.total) Font:kFontTheme14 TextColor:UIColor.blackColor BackgroundColor:UIColor.clearColor];
        [headView addSubview:lineView];
        [headView addSubview:label];
        return headView;
    }
    return UIView.new;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section > 0) {
        return 50;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

#pragma mark -----------UI-----------
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UICreateView initWithFrame:CGRectMake(0, kTopBarHeight, kScreenW, kScreenH-kBottomDangerHeight-50-kTopBarHeight) Style:UITableViewStyleGrouped Object:self];
        [_tableView registerClass:CommentListCell.class forCellReuseIdentifier:NSStringFromClass(CommentListCell.class)];
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

- (CommentBottomView *)commentView {
    if (!_commentView) {
        _commentView = [[CommentBottomView alloc] initWithFrame:CGRectMake(0, kScreenH-(50+kBottomDangerHeight), kScreenW, 50)];
        WEAKSELF
        _commentView.bottomViewCommentBlock = ^{
            if (self.communityType == 1) {
                weakSelf.service.commentType = CommentTypeArticleReply;
            } else {
                weakSelf.service.commentType = CommentTypeContentReply;
            }
            [weakSelf.service showCommentKeyBoardWithCommentName:weakSelf.service.commentModel.releaseName];
        };
        _commentView.bottomViewPraiseBlock = ^{
            NSInteger likeStatus = weakSelf.service.commentModel.likeStatus == 1 ? 2 : 1;
            [QHWSystemService.new clickLikeRequestWithBusinessType:weakSelf.service.commentModel.businessType BusinessId:weakSelf.commentId LikeStatus:likeStatus  Complete:^(BOOL status) {
                if (status) {
                    weakSelf.service.commentModel.likeStatus = likeStatus;
                    if (likeStatus == 2) {
                        weakSelf.service.commentModel.likeCount++;
                    } else {
                        weakSelf.service.commentModel.likeCount--;
                    }
                    weakSelf.commentView.praiseButton.selected = likeStatus == 2;
                    weakSelf.commentView.praiseButton.btnBadgeLabel.text = kFormat(@"%ld", weakSelf.service.commentModel.likeCount);
                }
            }];
        };
        [self.view addSubview:_commentView];
    }
    return _commentView;
}

- (QHWCommentService *)service {
    if (!_service) {
        _service = QHWCommentService.new;
        _service.communityType = self.communityType;
        _service.commentId = self.commentId;
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
