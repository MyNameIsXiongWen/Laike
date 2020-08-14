//
//  CommunityDetailViewController.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/21.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "CommunityDetailViewController.h"
#import "MainBusinessDetailBottomView.h"
#import "CommentListCell.h"
#import "CommunityDetailRecommendTableViewCell.h"
#import "CommunityDetailService.h"
#import "QHWCommentService.h"
#import "QHWSystemService.h"
#import "CTMediator+ViewController.h"
#import "QHWShareView.h"
#import "QHWPhotoBrowser.h"
#import "AllCommentViewController.h"

@interface CommunityDetailViewController () <UITableViewDelegate, UITableViewDataSource, WKNavigationDelegate, QHWCycleScrollViewDelegate> {
    CGFloat webContentHeight;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CommunityArticleDetailHeaderView *articlelHeaderView;
@property (nonatomic, strong) CommunityContentDetailHeaderView *contentHeaderView;
@property (nonatomic, strong) MainBusinessDetailBottomView *bottomView;

@property (nonatomic, strong) dispatch_group_t group;
@property (nonatomic, strong) CommunityDetailService *service;
@property (nonatomic, strong) QHWCommentService *commentService;

@end

@implementation CommunityDetailViewController

- (void)dealloc {
    [self.articlelHeaderView.wkWebView.scrollView removeObserver:self forKeyPath:@"contentSize"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.kNavigationView.rightBtn setImage:kImageMake(@"global_share") forState:0];
    [self.view addSubview:self.bottomView];
    self.group = dispatch_group_create();
    [self getCommunityDetailRequest];
    [self getCommentListRequest];
    dispatch_group_notify(self.group, dispatch_get_main_queue(), ^{
        self.commentService.fileType = self.service.detailModel.fileType;
        for (QHWCommentModel *model in self.commentService.dataArray) {
            if (self.communityType == 1) {
                model.businessType = 6;
            } else {
                if (self.service.detailModel.fileType == 1) {
                    model.businessType = 19;
                } else {
                    model.businessType = 22;
                }
            }
        }
        [self.tableView reloadData];
    });
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(addCommentNotification) name:kNotificationAddCommentSuccess object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.communityType == 2 && self.contentHeaderView.playerView.playerVC.player) {
        [self.contentHeaderView.playerView.playerVC.player pause];
    }
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    if (!parent) {
        if (self.communityType == 2 && self.contentHeaderView.playerView.playerVC.player) {
            [self.contentHeaderView.playerView.playerVC.player pause];
            self.contentHeaderView.playerView.playerVC.player = nil;
            [self.contentHeaderView.playerView.playerVC.view removeFromSuperview];
            self.contentHeaderView.playerView.playerVC = nil;
        }
    }
}

- (void)rightNavBtnAction:(UIButton *)sender {
    ShareType type;
    if (self.communityType == 1) {
        type = ShareTypeArticle;
    } else {
        type = ShareTypeContent;
    }
    QHWShareView *shareView = [[QHWShareView alloc] initWithFrame:CGRectMake(0, kScreenH, kScreenW, 220) dict:@{@"detailModel":self.service.detailModel, @"shareType": @(type)}];
    [shareView show];
}

- (void)getCommunityDetailRequest {
    dispatch_group_enter(self.group);
    [self.service getCommunityDetailRequestWithComplete:^(BOOL status) {
        if (!status) {
            return;
        }
        if (self.communityType == 1) {
            self.kNavigationView.title = @"头条";
            self.articlelHeaderView.titleLabel.text = self.service.detailModel.name;
            self.articlelHeaderView.sourceLabel.text = kFormat(@"%@：%@", self.service.detailModel.sourceStr, self.service.detailModel.merchantName);
            self.articlelHeaderView.readLabel.text = kFormat(@"阅读:%ld", self.service.detailModel.browseCount);
            self.articlelHeaderView.autherView.tagImgView.hidden = NO;
            [self.articlelHeaderView.wkWebView loadHTMLString:self.service.detailModel.content baseURL:nil];
        } else {
            self.kNavigationView.title = self.service.detailModel.title ?: @"海外圈";
            self.contentHeaderView.autherView.tagImgView.hidden = self.service.detailModel.subjectData.subjectType != 1;
            if (self.service.detailModel.title.length > 0) {
                self.contentHeaderView.contentLabel.text = kFormat(@"%@\n%@", self.service.detailModel.title, self.service.detailModel.content);
            } else {
                self.contentHeaderView.contentLabel.text = self.service.detailModel.content;
            }
            self.contentHeaderView.height = self.service.detailModel.headerContentHeight;
            self.contentHeaderView.cycleScrollView.hidden = self.service.detailModel.fileType == 1;
            self.contentHeaderView.playerView.hidden = self.service.detailModel.fileType != 1;
            if (self.service.detailModel.fileType == 1) {
                NSDictionary *dic = (NSDictionary *)self.service.detailModel.filePathList.firstObject;
                self.contentHeaderView.playerView.videoPath = kFilePath(dic[@"path"]);
            } else {
                self.contentHeaderView.cycleScrollView.imgArray = self.service.detailModel.filePathList;
            }
        }
        dispatch_group_leave(self.group);
    }];
}

- (void)getCommentListRequest {
    dispatch_group_enter(self.group);
    [self.commentService getCommentListRequestComplete:^{
        dispatch_group_leave(self.group);
        [self.tableView.mj_footer endRefreshing];
        [QHWRefreshManager.sharedInstance endRefreshWithScrollView:self.tableView PageModel:self.commentService.itemPageModel];
        for (QHWCommentModel *model in self.commentService.dataArray) {
            if (self.communityType == 1) {
                model.businessType = 6;
            } else {
                if (self.service.detailModel.fileType == 1) {
                    model.businessType = 19;
                } else {
                    model.businessType = 22;
                }
            }
        }
        [self.tableView reloadData];
    }];
}

#pragma mark ------------Notification-------------
- (void)addCommentNotification {
    [self.tableView setContentOffset:CGPointMake(0, [self getSectionHeaderYWith:0]) animated:YES];
    [self getCommentListRequest];
}

#pragma mark ------------UITableView-------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (self.communityType == 1 && self.service.detailModel.businessList.count > 0) {
            return 1;
        }
        return 0;
    }
    return self.commentService.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.communityType == 1 && self.service.detailModel.businessList.count > 0) {
            return 270;
        }
        return CGFLOAT_MIN;
    }
    QHWCommentModel *model = self.commentService.dataArray[indexPath.row];
    return model.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section > 0 && self.commentService.dataArray.count > 0) {
        return 40;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = UIView.viewInit();
    if (section > 0 && self.commentService.dataArray.count > 0) {
        NSString *str = kFormat(@"评论（%ld）", self.commentService.dataArray.count);
        UILabel *label = UILabel.labelFrame(CGRectMake(15, 0, kScreenW-30, 40)).labelText(str).labelFont(kFontTheme15).labelTitleColor(kColorTheme2a303c);
        UIView *line = UIView.viewFrame(CGRectMake(0, 0, kScreenW, 0.5)).bkgColor(kColorThemeeee);
        [headerView addSubview:label];
        [headerView addSubview:line];
    }
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.communityType == 1 && self.service.detailModel.businessList.count > 0) {
            CommunityDetailRecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(CommunityDetailRecommendTableViewCell.class)];
            cell.dataArray = self.service.detailModel.businessList;
            return cell;
        }
    } else {
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
    return UITableViewCell.new;
}

#pragma mark ------------KVO回调-------------
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    CGFloat newHeight = self.articlelHeaderView.wkWebView.scrollView.contentSize.height;
    [self resetWebViewFrameWithHeight:newHeight];
}

#pragma mark ------------WKNavigationDelegate-------------
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [webView evaluateJavaScript:@"document.body.scrollWidth"completionHandler:^(id _Nullable result,NSError * _Nullable error){
        CGFloat ratio =  kScreenW / [result floatValue];
        [webView evaluateJavaScript:@"document.body.scrollHeight"completionHandler:^(id _Nullable result,NSError * _Nullable error){
            CGFloat newHeight = [result floatValue]*ratio;
            [self resetWebViewFrameWithHeight:newHeight];
            [self.articlelHeaderView.wkWebView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        }];
    }];
}

- (void)resetWebViewFrameWithHeight:(CGFloat)height {
    //如果是新高度，那就重置
    if (height != webContentHeight) {
        [self.articlelHeaderView.wkWebView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height);
        }];
        self.articlelHeaderView.height = height + self.service.detailModel.headerTopHeight;
        [self.tableView reloadData];
        webContentHeight = height;
    }
}

#pragma mark ------------QHWCycleScrollViewDelegate-------------
- (void)cycleScrollView:(QHWCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    QHWPhotoBrowser *browser = [[QHWPhotoBrowser alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) ImgArray:cycleScrollView.imgArray.mutableCopy CurrentIndex:index];
    [browser show];
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
        _tableView = [UICreateView initWithRecognizeSimultaneouslyFrame:CGRectMake(0, kTopBarHeight, kScreenW, kScreenH-kTopBarHeight-kBottomDangerHeight-self.bottomView.height) Style:UITableViewStyleGrouped Object:self];
        if (self.communityType == 1) {
            _tableView.tableHeaderView = self.articlelHeaderView;
        } else {
            _tableView.tableHeaderView = self.contentHeaderView;
        }
        [_tableView registerClass:CommentListCell.class forCellReuseIdentifier:NSStringFromClass(CommentListCell.class)];
        [_tableView registerClass:CommunityDetailRecommendTableViewCell.class forCellReuseIdentifier:NSStringFromClass(CommunityDetailRecommendTableViewCell.class)];
        [QHWRefreshManager.sharedInstance normalFooterWithScrollView:_tableView RefreshBlock:^{
            self.commentService.itemPageModel.pagination.currentPage++;
            [self getCommentListRequest];
        }];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (CommunityArticleDetailHeaderView *)articlelHeaderView {
    if (!_articlelHeaderView) {
        _articlelHeaderView = [[CommunityArticleDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 150)];
        _articlelHeaderView.wkWebView.navigationDelegate = self;
        WEAKSELF
        _articlelHeaderView.autherView.clickLogoBlock = ^{
//            [weakSelf clickAutherViewLogo];
        };
        _articlelHeaderView.autherView.clickShareBlock = ^{
            [weakSelf rightNavBtnAction:nil];
        };
    }
    return _articlelHeaderView;
}

- (void)clickAttentionWithButton:(UIButton *)btn {
    QHWBottomUserModel *tempModel;
    if (self.communityType == 1) {
        tempModel = self.service.detailModel.bottomData;
    } else {
        tempModel = self.service.detailModel.subjectData;
    }
    NSInteger concernStatus = self.service.detailModel.concernStatus == 1 ? 2 : 1;
    [QHWSystemService.new clickConcernRequestWithSubject:tempModel.subjectType == 1 ? 3 : 1 SubjectId:tempModel.subjectId ConcernStatus:concernStatus  Complete:^(BOOL status) {
        if (status) {
            self.service.detailModel.concernStatus = concernStatus;
            btn.selected = (concernStatus == 2);
            if (btn.selected) {
                btn.backgroundColor = kColorTheme999;
            } else {
                btn.backgroundColor = kColorThemefb4d56;
            }
        }
    }];
}

- (void)clickAutherViewLogo {
    if (self.communityType == 1) {
        [CTMediator.sharedInstance CTMediator_viewControllerForUserDetailWithUserId:self.service.detailModel.bottomData.subjectId UserType:3 BusinessType:5];
    } else {
        [CTMediator.sharedInstance CTMediator_viewControllerForUserDetailWithUserId:self.service.detailModel.subjectData.subjectId UserType:2 BusinessType:1821];
    }
}

- (CommunityContentDetailHeaderView *)contentHeaderView {
    if (!_contentHeaderView) {
        _contentHeaderView = [[CommunityContentDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 150)];
        _contentHeaderView.cycleScrollView.delegate = self;
        WEAKSELF
        _contentHeaderView.autherView.clickLogoBlock = ^{
//            [weakSelf clickAutherViewLogo];
        };
        _contentHeaderView.autherView.clickShareBlock = ^{
            [weakSelf rightNavBtnAction:nil];
        };
    }
    return _contentHeaderView;
}

- (MainBusinessDetailBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[MainBusinessDetailBottomView alloc] initWithFrame:CGRectMake(0, kScreenH-kBottomDangerHeight-75, kScreenW, 75)];
        WEAKSELF
        _bottomView.rightOperationBlock = ^{
            [weakSelf rightNavBtnAction:nil];
        };
    }
    return _bottomView;
}

- (CommunityDetailService *)service {
    if (!_service) {
        _service = CommunityDetailService.new;
        _service.communityId = self.communityId;
        _service.communityType = self.communityType;
    }
    return _service;
}

- (QHWCommentService *)commentService {
    if (!_commentService) {
        _commentService = QHWCommentService.new;
        _commentService.communityId = self.communityId;
        _commentService.communityType = self.communityType;
    }
    return _commentService;
}

- (CGFloat)getSectionHeaderYWith:(NSInteger)section {
    if (section < self.tableView.numberOfSections) {
        return [self.tableView rectForHeaderInSection:section].origin.y;
    }
    return self.tableView.contentSize.height-self.tableView.height;
}

@end


@implementation CommunityArticleDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(15);
            make.right.mas_equalTo(-15);
        }];
        [self.sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
        }];
        [self.readLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.sourceLabel);
            make.right.mas_equalTo(-15);
        }];
        [self.autherView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.equalTo(self.sourceLabel.mas_bottom).offset(15);
            make.height.mas_equalTo(50);
        }];
        [self.wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.equalTo(self.autherView.mas_bottom).offset(15);
        }];
    }
    return self;
}

#pragma mark ------------UI-------------
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.labelInit().labelFont([UIFont boldSystemFontOfSize:16]).labelTitleColor(kColorTheme2a303c).labelNumberOfLines(0);
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (CommunityAutherView *)autherView {
    if (!_autherView) {
        _autherView = [[CommunityAutherView alloc] init];
        [self addSubview:_autherView];
    }
    return _autherView;
}

- (UILabel *)sourceLabel {
    if (!_sourceLabel) {
        _sourceLabel = UILabel.labelInit().labelFont(kFontTheme14).labelTitleColor(kColorThemea4abb3);
        [self addSubview:_sourceLabel];
    }
    return _sourceLabel;
}

- (UILabel *)readLabel {
    if (!_readLabel) {
        _readLabel = UILabel.labelInit().labelFont(kFontTheme14).labelTitleColor(kColorThemea4abb3);
        [self addSubview:_readLabel];
    }
    return _readLabel;
}

- (WKWebView *)wkWebView {
    if (!_wkWebView) {
        NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta); var imgs = document.getElementsByTagName('img');for (var i in imgs){imgs[i].style.maxWidth='100%';imgs[i].style.height='auto';}";
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        [wkUController addUserScript:wkUScript];
        WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
        wkWebConfig.userContentController = wkUController;
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 0) configuration:wkWebConfig];
        [self addSubview:_wkWebView];
    }
    return _wkWebView;
}

@end

@implementation CommunityContentDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self.autherView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(15);
            make.height.mas_equalTo(50);
        }];
        [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.equalTo(self.autherView.mas_bottom).offset(10);
            make.height.mas_equalTo(500);
        }];
        [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.equalTo(self.autherView.mas_bottom).offset(10);
            make.height.mas_equalTo(500);
        }];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.equalTo(self.cycleScrollView.mas_bottom).offset(15);
        }];
    }
    return self;
}

- (CommunityAutherView *)autherView {
    if (!_autherView) {
        _autherView = [[CommunityAutherView alloc] init];
        [self addSubview:_autherView];
    }
    return _autherView;
}

- (QHWCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        _cycleScrollView = [[QHWCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 500)];
        _cycleScrollView.itemSpace = 0;
        _cycleScrollView.autoScroll = NO;
        _cycleScrollView.pageControlLabel = YES;
        [self addSubview:_cycleScrollView];
    }
    return _cycleScrollView;
}

- (QHWVideoPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[QHWVideoPlayerView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 500)];
        _playerView.hidden = YES;
        [self addSubview:_playerView];
    }
    return _playerView;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = UILabel.labelInit().labelFont(kFontTheme14).labelTitleColor(kColorTheme2a303c).labelNumberOfLines(0);
        [self addSubview:_contentLabel];
    }
    return _contentLabel;
}

@end


@implementation CommunityAutherView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self.logoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(0);
            make.width.height.mas_equalTo(50);
        }];
        [self.tagImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.logoImgView.mas_right);
            make.bottom.equalTo(self.logoImgView.mas_bottom);
            make.width.height.mas_equalTo(14);
        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.logoImgView.mas_right).offset(10);
            make.centerY.equalTo(self.logoImgView);
            make.right.mas_equalTo(-75);
        }];
        [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.equalTo(self.logoImgView);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(22);
        }];
        UserModel *user = UserModel.shareUser;
        self.nameLabel.text = user.realName;
        [self.logoImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(user.headPath)]];
        self.tagImgView.image = kImageMake(@"v_expert");
    }
    return self;
}

- (void)clickStoreLogo {
    if (self.clickLogoBlock) {
        self.clickLogoBlock();
    }
}

- (void)clickShareBtn {
    if (self.clickShareBlock) {
        self.clickShareBlock();
    }
}

#pragma mark ------------UI------------
- (UIImageView *)logoImgView {
    if (!_logoImgView) {
        _logoImgView = UIImageView.ivInit().ivCornerRadius(25);
        _logoImgView.userInteractionEnabled = YES;
        [_logoImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickStoreLogo)]];
        [self addSubview:_logoImgView];
    }
    return _logoImgView;
}

- (UIImageView *)tagImgView {
    if (!_tagImgView) {
        _tagImgView = UIImageView.ivInit().ivBkgColor(kColorThemefff).ivCornerRadius(7);
        [self addSubview:_tagImgView];
    }
    return _tagImgView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = UILabel.labelInit().labelFont(kFontTheme14).labelTitleColor(kColorTheme2a303c);
        [self addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (UIButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = UIButton.btnInit().btnCornerRadius(11).btnTitle(@" 微信推广").btnFont(kFontTheme11).btnTitleColor(kColorTheme444).btnImage(kImageMake(@"wechat_share")).btnBorderColor(kColorTheme444).btnAction(self, @selector(clickShareBtn));
        [self addSubview:_shareBtn];
    }
    return _shareBtn;
}

@end
