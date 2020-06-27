//
//  LiveCommentViewController.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/6/11.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "LiveCommentViewController.h"
#import <IQKeyboardManager.h>
#import "QHWCommentService.h"
#import "CommentBottomView.h"
#import "QHWSystemService.h"

@interface LiveCommentViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) CommentBottomView *bottomView;
@property (nonatomic, strong) QHWCommentService *service;

@end

@implementation LiveCommentViewController

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
    self.tableView = [UICreateView initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-kTopBarHeight-40-200) Style:UITableViewStylePlain Object:self];
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
    [self.service getLiveCommentListRequestComplete:^{
        [self.tableView.mj_footer endRefreshing];
        [QHWRefreshManager.sharedInstance endRefreshWithScrollView:self.tableView PageModel:self.service.itemPageModel];
        [self.tableView showNodataView:self.service.dataArray.count == 0 offsetY:0 button:nil];
        for (QHWCommentModel *model in self.service.dataArray) {
            model.businessType = 103001;
        }
        [self.tableView reloadData];
        self.bottomView.praiseButton.selected = self.liveModel.likeStatus == 2;
        self.bottomView.praiseButton.btnBadgeLabel.text = kFormat(@"%ld", self.liveModel.likeCount);
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
        _bottomView = [[CommentBottomView alloc] initWithFrame:CGRectMake(0, kScreenH-kTopBarHeight-240-(50+kBottomDangerHeight), kScreenW, 50)];
        WEAKSELF
        _bottomView.bottomViewCommentBlock = ^{
            weakSelf.service.commentType = CommentTypeLiveAdd;
            [weakSelf.service showCommentKeyBoardWithCommentName:@""];
        };
        _bottomView.bottomViewPraiseBlock = ^{
            NSInteger likeStatus = weakSelf.liveModel.likeStatus == 1 ? 2 : 1;
            [QHWSystemService.new clickLikeRequestWithBusinessType:103001 BusinessId:weakSelf.liveModel.id LikeStatus:likeStatus  Complete:^(BOOL status) {
                if (status) {
                    weakSelf.liveModel.likeStatus = likeStatus;
                    if (likeStatus == 2) {
                        weakSelf.liveModel.likeCount++;
                    } else {
                        weakSelf.liveModel.likeCount--;
                    }
                    weakSelf.bottomView.praiseButton.selected = likeStatus == 2;
                    weakSelf.bottomView.praiseButton.btnBadgeLabel.text = kFormat(@"%ld", weakSelf.liveModel.likeCount);
                }
            }];
        };
    }
    return _bottomView;
}

- (QHWCommentService *)service {
    if (!_service) {
        _service = QHWCommentService.new;
        _service.communityId = self.liveModel.id;
    }
    return _service;
}

@end


#import "CTMediator+ViewController.h"
@implementation LiveCommentListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.avtarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(10);
            make.width.height.mas_equalTo(30);
        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avtarImgView.mas_right).offset(5);
            make.centerY.equalTo(self.avtarImgView);
        }];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.mas_left);
            make.right.mas_equalTo(-15);
            make.top.equalTo(self.avtarImgView.mas_bottom).offset(10);
        }];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.mas_left);
            make.right.mas_equalTo(-15);
            make.top.equalTo(self.contentLabel.mas_bottom).offset(10);
        }];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(15);
            make.right.mas_offset(-15);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}

- (void)setCommentModel:(QHWCommentModel *)commentModel {
    _commentModel = commentModel;
    [self.avtarImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(commentModel.subjectHead)]];
    self.nameLabel.text = commentModel.subjectName;
    self.contentLabel.text = commentModel.content;
    self.timeLabel.text = commentModel.createTime;
}

#pragma mark ------------Action-------------
- (void)clickAvatar {
    [CTMediator.sharedInstance CTMediator_viewControllerForUserDetailWithUserId:self.commentModel.subjectId UserType:1 BusinessType:103001];
}

#pragma mark -----------UI-----------
- (UIImageView *)avtarImgView {
    if (!_avtarImgView) {
        _avtarImgView = UIImageView.ivInit().ivCornerRadius(15);
        _avtarImgView.userInteractionEnabled = YES;
        [_avtarImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAvatar)]];
        [self.contentView addSubview:_avtarImgView];
    }
    return _avtarImgView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = UILabel.labelInit().labelFont(kFontTheme13).labelTitleColor(kColorTheme2a303c);
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = UILabel.labelInit().labelFont(kFontTheme14).labelTitleColor(kColorTheme6d7278).labelTextAlignment(0);
        [self.contentView addSubview:_contentLabel];
    }
    return _contentLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = UILabel.labelInit().labelFont(kFontTheme12).labelTitleColor(kColorThemea4abb3);
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}

- (UIView *)line {
    if (!_line) {
        _line = UIView.viewInit().bkgColor(kColorThemef5f5f5);
        [self.contentView addSubview:_line];
    }
    return _line;
}

@end
