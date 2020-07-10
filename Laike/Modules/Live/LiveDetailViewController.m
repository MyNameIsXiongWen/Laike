//
//  LiveDetailViewController.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/6/11.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "LiveDetailViewController.h"
#import "QHWBaseSubContentTableViewCell.h"
#import "LiveOrganizerViewController.h"
#import "LiveCommentViewController.h"
#import "LiveService.h"
#import "QHWShareView.h"
#import "QHWVideoPlayerView.h"
#import "QHWTabScrollView.h"
#import "QHWPageContentView.h"

@interface LiveDetailViewController () <QHWPageContentViewDelegate>

@property (nonatomic, strong) QHWVideoPlayerView *playerView;
@property (nonatomic, strong) QHWTabScrollView *tabScrollView;
@property (nonatomic, strong) QHWPageContentView *pageContentView;
@property (nonatomic, strong) LiveService *service;

@end

@implementation LiveDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.kNavigationView.rightBtn setImage:kImageMake(@"global_share") forState:0];
    [self.view addSubview:self.playerView];
    [self.view addSubview:self.tabScrollView];
    [self.view addSubview:self.pageContentView];
    [self.view addSubview:UIView.viewFrame(CGRectMake(0, self.playerView.bottom+47.5, kScreenW, 0.5)).bkgColor(kColorThemeeee)];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ( self.playerView.playerVC.player) {
        [self.playerView.playerVC.player pause];
    }
}

- (void)rightNavBtnAction:(UIButton *)sender {
    QHWShareView *shareView = [[QHWShareView alloc] initWithFrame:CGRectMake(0, kScreenH, kScreenW, 220) dict:@{@"detailModel":self.service.liveDetailModel, @"shareType": @(ShareTypeLive)}];
    [shareView show];
}

- (void)getMainData {
    [self.service getLiveDetailInfoRequestWithLiveId:self.liveId Complete:^(BOOL status) {
        self.kNavigationView.title = self.service.liveDetailModel.name;
        self.playerView.videoPath = self.service.liveDetailModel.videoPath;
        LiveOrganizerViewController *vc = self.pageContentView.childsVCs.firstObject;
        vc.service = self.service;
    }];
}

#pragma mark ------------QHWPageContentViewDelegate-------------
- (void)QHWContentViewWillBeginDragging:(QHWPageContentView *)contentView {
    
}

- (void)QHWContentViewDidEndDecelerating:(QHWPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    [self.tabScrollView scrollToIndex:endIndex];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (QHWVideoPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[QHWVideoPlayerView alloc] initWithFrame:CGRectMake(0, kTopBarHeight, kScreenW, 200)];
    }
    return _playerView;
}

- (QHWTabScrollView *)tabScrollView {
    if (!_tabScrollView) {
        _tabScrollView = [[QHWTabScrollView alloc] initWithFrame:CGRectMake(0, self.playerView.bottom, kScreenW, 48)];
        _tabScrollView.itemWidthType = ItemWidthTypeFixed;
        _tabScrollView.hideIndicatorView = NO;
        _tabScrollView.tagIndicatorColor = kColorThemea4abb3;
        _tabScrollView.itemSelectedColor = kColorThemea4abb3;
        _tabScrollView.itemUnselectedColor = kColorTheme2a303c;
        _tabScrollView.itemSelectedBackgroundColor = kColorThemefff;
        _tabScrollView.itemUnselectedBackgroundColor = kColorThemefff;
        _tabScrollView.dataArray = @[@"直播嘉宾"];
        WEAKSELF
        _tabScrollView.clickTagBlock = ^(NSInteger index) {
            weakSelf.pageContentView.contentViewCurrentIndex = index;
        };
    }
    return _tabScrollView;
}

- (QHWPageContentView *)pageContentView {
    if (!_pageContentView) {
        NSMutableArray *contentVCs = [NSMutableArray array];
        LiveOrganizerViewController *organizerVC = LiveOrganizerViewController.new;
        organizerVC.service = self.service;
        WEAKSELF
        organizerVC.bottomView.rightOperationBlock = ^{
            [weakSelf rightNavBtnAction:nil];
        };
        [contentVCs addObject:organizerVC];
//        LiveCommentViewController *commentVC = LiveCommentViewController.new;
//        commentVC.liveModel = self.service.liveDetailModel;
//        [contentVCs addObject:commentVC];
        _pageContentView = [[QHWPageContentView alloc] initWithFrame:CGRectMake(0, self.tabScrollView.bottom, kScreenW, kScreenH-self.tabScrollView.bottom) childVCs:contentVCs parentVC:self delegate:self];
    }
    return _pageContentView;
}

- (LiveService *)service {
    if (!_service) {
        _service = LiveService.new;
    }
    return _service;
}

@end
