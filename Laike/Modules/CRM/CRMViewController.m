//
//  CRMViewController.m
//  Laike
//
//  Created by xiaobu on 2020/6/23.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "CRMViewController.h"
#import "CRMScrollContentViewController.h"
#import "CRMTopOperationView.h"
#import "QHWTabScrollView.h"
#import "MainBusinessFilterBtnView.h"
#import "QHWPageContentView.h"

@interface CRMViewController () <QHWPageContentViewDelegate>

@property (nonatomic, strong) CRMTopOperationView *topOperationView;
@property (nonatomic, strong) QHWTabScrollView *tabScrollView;
@property (nonatomic, strong) MainBusinessFilterBtnView *filterBtnView;
@property (nonatomic, strong) QHWPageContentView *pageContentView;

@end

@implementation CRMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.topOperationView];
    [self.view addSubview:self.tabScrollView];
    [self.view addSubview:self.filterBtnView];
    [self.view addSubview:self.pageContentView];
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
- (CRMTopOperationView *)topOperationView {
    if (!_topOperationView) {
        _topOperationView = [[CRMTopOperationView alloc] initWithFrame:CGRectMake(10, kTopBarHeight+10, kScreenW-20, 70)];
        _topOperationView.dataArray = @[@{@"logo": @"",
                                          @"title": @"分享获客",
                                          @"subTitle": @"发布海外圈 免费获客",
                                          @"identifier": @"shareArticle"},
                                        @{@"logo": @"",
                                          @"title": @"公海抢客",
                                          @"subTitle": @"意向客户 抢单成交",
                                          @"identifier": @"grabGuest"}
        ];
    }
    return _topOperationView;
}

- (QHWTabScrollView *)tabScrollView {
    if (!_tabScrollView) {
        _tabScrollView = [[QHWTabScrollView alloc] initWithFrame:CGRectMake(0, self.topOperationView.bottom, kScreenW, 48)];
        _tabScrollView.itemWidthType = ItemWidthTypeFixed;
        _tabScrollView.hideIndicatorView = NO;
        _tabScrollView.tagIndicatorColor = kColorThemea4abb3;
        _tabScrollView.itemSelectedColor = kColorThemea4abb3;
        _tabScrollView.itemUnselectedColor = kColorTheme2a303c;
        _tabScrollView.itemSelectedBackgroundColor = kColorThemefff;
        _tabScrollView.itemUnselectedBackgroundColor = kColorThemefff;
        _tabScrollView.dataArray = @[@"CRM", @"获客", @"公海"];
        WEAKSELF
        _tabScrollView.clickTagBlock = ^(NSInteger index) {
            weakSelf.pageContentView.contentViewCurrentIndex = index;
        };
        [self.view addSubview:_tabScrollView];
        [self.view addSubview:UIView.viewFrame(CGRectMake(0, self.topOperationView.bottom+47.5, kScreenW, 0.5)).bkgColor(kColorThemeeee)];
    }
    return _tabScrollView;
}

- (MainBusinessFilterBtnView *)filterBtnView {
    if (!_filterBtnView) {
        _filterBtnView = [[MainBusinessFilterBtnView alloc] initWithFrame:CGRectMake(0, self.tabScrollView.bottom, kScreenW, 40)];
        [self.view addSubview:UIView.viewFrame(CGRectMake(0, self.tabScrollView.bottom+39.5, kScreenW, 0.5)).bkgColor(kColorThemeeee)];
    }
    return _filterBtnView;
}

- (QHWPageContentView *)pageContentView {
    if (!_pageContentView) {
        NSMutableArray *contentVCs = [NSMutableArray array];
        NSArray *statusArray = @[@(1), @(2), @(3)];
        for (int i=0; i<statusArray.count; i++) {
            CRMScrollContentViewController *vc = [[CRMScrollContentViewController alloc] init];
            vc.crmType = [statusArray[i] integerValue];
            [contentVCs addObject:vc];
        }
        _pageContentView = [[QHWPageContentView alloc] initWithFrame:CGRectMake(0, self.tabScrollView.bottom, kScreenW, kScreenH-self.tabScrollView.bottom) childVCs:contentVCs parentVC:self delegate:self];
        [self.view addSubview:_pageContentView];
    }
    return _pageContentView;
}

@end
