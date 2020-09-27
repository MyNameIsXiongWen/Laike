//
//  QSchoolDetailViewController.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/6/11.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QSchoolDetailViewController.h"
#import "QHWBaseSubContentTableViewCell.h"
#import "QSchoolOrganizerViewController.h"
#import "QSchoolCommentViewController.h"
#import "QSchoolService.h"
#import "QHWShareView.h"
#import "QHWCycleScrollView.h"
#import "QHWVideoPlayerView.h"
#import "QHWTabScrollView.h"
#import "QHWPageContentView.h"
#import "CTMediator+ViewController.h"

@interface QSchoolDetailViewController () <QHWPageContentViewDelegate>

@property (nonatomic, strong) QHWVideoPlayerView *playerView;
@property (nonatomic, strong) QHWCycleScrollView *cycleScrollView;
@property (nonatomic, strong) QSchoolPDFView *pdfView;
@property (nonatomic, strong) QHWTabScrollView *tabScrollView;
@property (nonatomic, strong) QHWPageContentView *pageContentView;
@property (nonatomic, strong) QSchoolService *service;

@end

@implementation QSchoolDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.kNavigationView.rightBtn setImage:kImageMake(@"global_share") forState:0];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.service.schoolModel.fileType == 2) {
        if (self.playerView.playerVC.player) {
            [self.playerView.playerVC.player pause];
        }
    }
}

- (void)rightNavBtnAction:(UIButton *)sender {
    QHWShareView *shareView = [[QHWShareView alloc] initWithFrame:CGRectMake(0, kScreenH, kScreenW, 220) dict:@{@"detailModel":self.service.schoolModel, @"shareType": @(ShareTypeSchool)}];
    [shareView show];
}

- (void)getMainData {
    [self.service getSchoolDetailInfoRequestWithSchoolId:self.schoolId Complete:^(BOOL status) {
        if (status) {
            if (self.service.schoolModel.fileType == 1) {
                [self.view addSubview:self.pdfView];
                [self.pdfView.coverImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(self.service.schoolModel.coverPath)]];
            } else if (self.service.schoolModel.fileType == 2) {
                [self.view addSubview:self.playerView];
                self.playerView.videoPath = self.service.schoolModel.videoPath;
            } else if (self.service.schoolModel.fileType == 3) {
                [self.view addSubview:self.cycleScrollView];
                self.cycleScrollView.imgArray = self.service.schoolModel.filePathList;
            }
            [self.view addSubview:self.tabScrollView];
            [self.view addSubview:self.pageContentView];
            [self.view addSubview:UIView.viewFrame(CGRectMake(0, self.playerView.bottom+47.5, kScreenW, 0.5)).bkgColor(kColorThemeeee)];
            self.kNavigationView.title = self.service.schoolModel.title;
        }
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

- (QHWCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        _cycleScrollView = [[QHWCycleScrollView alloc] initWithFrame:CGRectMake(0, kTopBarHeight, kScreenW, 200)];
        _cycleScrollView.itemSpace = 0;
        _cycleScrollView.pageControlLabel = YES;
    }
    return _cycleScrollView;
}

- (QSchoolPDFView *)pdfView {
    if (!_pdfView) {
        _pdfView = [[QSchoolPDFView alloc] initWithFrame:CGRectMake(0, kTopBarHeight, kScreenW, 200)];
        WEAKSELF
        _pdfView.clickPDFBlock = ^{
            NSDictionary *dic = weakSelf.service.schoolModel.filePathList.firstObject;
            [CTMediator.sharedInstance CTMediator_viewControllerForH5WithUrl:kFilePath(dic[@"path"]) TitleName:weakSelf.service.schoolModel.title];
        };
    }
    return _pdfView;
}

- (QHWTabScrollView *)tabScrollView {
    if (!_tabScrollView) {
        _tabScrollView = [[QHWTabScrollView alloc] initWithFrame:CGRectMake(0, self.playerView.bottom, kScreenW, 48)];
        _tabScrollView.itemWidthType = ItemWidthTypeFixed;
        _tabScrollView.hideIndicatorView = NO;
        _tabScrollView.tagIndicatorColor = kColorTheme21a8ff;
        _tabScrollView.itemSelectedColor = kColorTheme21a8ff;
        _tabScrollView.itemUnselectedColor = kColorTheme2a303c;
        _tabScrollView.itemSelectedBackgroundColor = kColorThemefff;
        _tabScrollView.itemUnselectedBackgroundColor = kColorThemefff;
//        _tabScrollView.dataArray = @[@"介绍", @"评论"];
        _tabScrollView.dataArray = @[@"介绍"];
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
        QSchoolOrganizerViewController *organizerVC = QSchoolOrganizerViewController.new;
        organizerVC.service = self.service;
        WEAKSELF
        organizerVC.bottomView.rightOperationBlock = ^{
            [weakSelf rightNavBtnAction:nil];
        };
        [contentVCs addObject:organizerVC];
        
//        QSchoolCommentViewController *commentVC = QSchoolCommentViewController.new;
//        commentVC.schoolModel = self.service.schoolModel;
//        [contentVCs addObject:commentVC];
        _pageContentView = [[QHWPageContentView alloc] initWithFrame:CGRectMake(0, self.tabScrollView.bottom, kScreenW, kScreenH-self.tabScrollView.bottom) childVCs:contentVCs parentVC:self delegate:self];
    }
    return _pageContentView;
}

- (QSchoolService *)service {
    if (!_service) {
        _service = QSchoolService.new;
    }
    return _service;
}

@end

@implementation QSchoolPDFView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.coverImgView = UIImageView.ivFrame(self.bounds);
        [self addSubview:self.coverImgView];
        self.titleLabel = UILabel.labelFrame(CGRectMake((self.width-100)/2.0, (self.height-40)/2.0, 100, 40)).labelText(@"点击查看详情").labelTitleColor(kColorThemefff).labelBkgColor([UIColor colorWithWhite:0 alpha:0.3]).labelFont(kFontTheme14).labelTextAlignment(NSTextAlignmentCenter);
        self.titleLabel.userInteractionEnabled = YES;
        [self.titleLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPDFView)]];
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)clickPDFView {
    if (self.clickPDFBlock) {
        self.clickPDFBlock();
    }
}

@end
