//
//  ActivityViewController.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/6/2.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "ActivityViewController.h"
#import "ActivityScrollContentViewController.h"
#import "QHWPageContentView.h"
#import "QHWTabScrollView.h"
#import "QHWCycleScrollView.h"
#import "QHWSystemService.h"

@interface ActivityViewController () <QHWPageContentViewDelegate>

@property (nonatomic, strong) QHWCycleScrollView *bannerView;
@property (nonatomic, strong) QHWTabScrollView *tabScrollView;
@property (nonatomic, strong) QHWPageContentView *pageContentView;
@property (nonatomic, strong) QHWSystemService *service;

@end

@implementation ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.kNavigationView.title = @"活动召集";
    [self.view addSubview:self.tabScrollView];
    [self.view addSubview:self.pageContentView];
//    [self getBannerRequest];
}

- (void)getBannerRequest {
    [self.service getBannerRequestWithAdvertPage:17 Complete:^(id  _Nullable response) {
        self.bannerView.hidden = self.service.bannerArray.count == 0;
        self.bannerView.imgArray = self.service.bannerArray;
        if (self.service.bannerArray.count > 0) {
            self.tabScrollView.y = kTopBarHeight+155;
            self.pageContentView.frame = CGRectMake(0, self.tabScrollView.bottom, kScreenW, kScreenH-self.tabScrollView.bottom);
            self.pageContentView.collectionView.frame = self.pageContentView.bounds;
            self.pageContentView.flowLayout.itemSize = self.pageContentView.bounds.size;
            for (ActivityScrollContentViewController *childVcs in self.pageContentView.childsVCs) {
                childVcs.tableView.frame = self.pageContentView.bounds;
            }
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

- (QHWPageContentView *)pageContentView {
    if (!_pageContentView) {
        NSMutableArray *contentVCs = [NSMutableArray array];
        NSArray *statusArray = @[@(2), @(1)];
        for (int i=0; i<2; i++) {
            ActivityScrollContentViewController *vc = [[ActivityScrollContentViewController alloc] init];
            vc.registerStatus = [statusArray[i] integerValue];
            [contentVCs addObject:vc];
        }
        _pageContentView = [[QHWPageContentView alloc] initWithFrame:CGRectMake(0, self.tabScrollView.bottom, kScreenW, kScreenH-self.tabScrollView.bottom) childVCs:contentVCs parentVC:self delegate:self];
        [self.view addSubview:_pageContentView];
    }
    return _pageContentView;
}


- (QHWTabScrollView *)tabScrollView {
    if (!_tabScrollView) {
        _tabScrollView = [[QHWTabScrollView alloc] initWithFrame:CGRectMake(0, kTopBarHeight, kScreenW, 44)];
        _tabScrollView.itemWidthType = ItemWidthTypeFixed;
        _tabScrollView.hideIndicatorView = NO;
        _tabScrollView.itemSelectedColor = kColorThemefb4d56;
        _tabScrollView.itemUnselectedColor = kColorThemea4abb3;
        _tabScrollView.itemSelectedBackgroundColor = kColorThemefff;
        _tabScrollView.itemUnselectedBackgroundColor = kColorThemefff;
        _tabScrollView.dataArray = @[@"未报名", @"已报名"];
        WEAKSELF
        _tabScrollView.clickTagBlock = ^(NSInteger index) {
            weakSelf.pageContentView.contentViewCurrentIndex = index;
        };
        [self.view addSubview:_tabScrollView];
    }
    return _tabScrollView;
}

- (QHWCycleScrollView *)bannerView {
    if (!_bannerView) {
        _bannerView = [[QHWCycleScrollView alloc] initWithFrame:CGRectMake(15, kTopBarHeight, kScreenW-30, 140)];
        _bannerView.imgCornerRadius = 10;
        [self.view addSubview:_bannerView];
    }
    return _bannerView;
}

- (QHWSystemService *)service {
    if (!_service) {
        _service = QHWSystemService.new;
    }
    return _service;
}

@end
