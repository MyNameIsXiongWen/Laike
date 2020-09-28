//
//  AllCommentViewController.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/6/12.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "AllCommentViewController.h"
#import "CommentListCell.h"
#import "QHWCommentService.h"
#import "QHWSystemService.h"

@interface AllCommentViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) QHWCommentService *commentService;
@property (nonatomic, strong) AllCommentBottomView *bottomView;

@end

@implementation AllCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.kNavigationView.title = @"全部评论";
    [self.view addSubview:self.bottomView];
    [self getCommentListRequest];
}

- (void)getCommentListRequest {
    [self.commentService getCommentListRequestComplete:^{
        [self.tableView.mj_footer endRefreshing];
        [QHWRefreshManager.sharedInstance endRefreshWithScrollView:self.tableView PageModel:self.commentService.itemPageModel];
        for (QHWCommentModel *model in self.commentService.dataArray) {
            if (self.communityType == 1) {
                model.businessType = 6;
            } else {
                if (self.fileType == 1) {
                    model.businessType = 19;
                } else {
                    model.businessType = 22;
                }
            }
        }
        [self.tableView reloadData];
    }];
}

#pragma mark ------------UITableView-------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.commentService.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    QHWCommentModel *model = self.commentService.dataArray[indexPath.row];
    return model.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.commentService.dataArray.count > 0) {
        return 40;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = UIView.viewInit();
    if (self.commentService.dataArray.count > 0) {
        NSString *str = kFormat(@"评论（%ld）", self.commentService.dataArray.count);
        UILabel *label = UILabel.labelFrame(CGRectMake(15, 0, kScreenW-30, 40)).labelText(str).labelFont(kFontTheme15).labelTitleColor(kColorTheme2a303c);
        UIView *line = UIView.viewFrame(CGRectMake(0, 0, kScreenW, 0.5)).bkgColor(kColorThemeeee);
        [headerView addSubview:label];
        [headerView addSubview:line];
    }
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QHWCommentModel *model = self.commentService.dataArray[indexPath.row];
    CommentListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(CommentListCell.class)];
    cell.commentModel = model;
    cell.commentService = self.commentService;
    if (self.communityType == 1) {
        cell.commentService.commentType = CommentTypeArticleReply;
    } else {
        cell.commentService.commentType = CommentTypeContentReply;
    }
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
#pragma mark ------------UI-------------
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UICreateView initWithFrame:CGRectMake(0, kTopBarHeight, kScreenW, kScreenH-kTopBarHeight-50-kBottomDangerHeight) Style:UITableViewStylePlain Object:self];
        [_tableView registerClass:CommentListCell.class forCellReuseIdentifier:NSStringFromClass(CommentListCell.class)];
        [QHWRefreshManager.sharedInstance normalHeaderWithScrollView:_tableView RefreshBlock:^{
            self.commentService.itemPageModel.pagination.currentPage = 1;
            [self getCommentListRequest];
        }];
        [QHWRefreshManager.sharedInstance normalFooterWithScrollView:_tableView RefreshBlock:^{
            self.commentService.itemPageModel.pagination.currentPage++;
            [self getCommentListRequest];
        }];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (AllCommentBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[AllCommentBottomView alloc] initWithFrame:CGRectMake(0, kScreenH-kBottomDangerHeight-50, kScreenW, 50)];
        WEAKSELF
        _bottomView.clickCommentBlock = ^{
            if (weakSelf.communityType == 1) {
                weakSelf.commentService.commentType = CommentTypeArticleAdd;
            } else {
                weakSelf.commentService.commentType = CommentTypeContentAdd;
            }
            [weakSelf.commentService showCommentKeyBoardWithCommentName:@""];
        };
        [self.view addSubview:_bottomView];
    }
    return _bottomView;
}

- (QHWCommentService *)commentService {
    if (!_commentService) {
        _commentService = QHWCommentService.new;
        _commentService.communityId = self.communityId;
        _commentService.communityType = self.communityType;
    }
    return _commentService;
}

@end

@implementation AllCommentBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.whiteColor;
        [self addSubview:self.commentView];
        [self addSubview:[UICreateView initWithFrame:CGRectMake(0, 0, kScreenW, 0.5) BackgroundColor:kColorThemeeee CornerRadius:0]];
    }
    return self;
}

#pragma mark ------------Action------------
- (void)clickCommentView {
    if (self.clickCommentBlock) {
        self.clickCommentBlock();
    }
}

#pragma mark ------------UI-------------
- (UIView *)commentView {
    if (!_commentView) {
        _commentView = [UICreateView initWithFrame:CGRectMake(15, 5, kScreenW-30, 40) BackgroundColor:kColorThemef5f5f5 CornerRadius:20];
        _commentView.viewAction(self, @selector(clickCommentView));
        UILabel *label = [UICreateView initWithFrame:CGRectMake(15, 0, 100, 40) Text:@"写评论" Font:kFontTheme14 TextColor:kColorThemea4abb3 BackgroundColor:UIColor.clearColor];
        [_commentView addSubview:label];
    }
    return _commentView;
}

@end
