//
//  CardViewController.m
//  Laike
//
//  Created by xiaobu on 2020/6/23.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "CardViewController.h"
#import "CardScrollContentViewController.h"
#import "CRMTopOperationView.h"
#import "QHWTabScrollView.h"
#import "QHWPageContentView.h"

@interface CardViewController () <QHWPageContentViewDelegate>

@property (nonatomic, strong) CRMTopOperationView *topOperationView;
@property (nonatomic, strong) QHWTabScrollView *tabScrollView;
@property (nonatomic, strong) QHWPageContentView *pageContentView;

@end

@implementation CardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.kNavigationView.title = @"名片数据";
    [self.view addSubview:self.topOperationView];
    [self.view addSubview:self.tabScrollView];
    [self.view addSubview:self.pageContentView];
    [self.view addSubview:UIView.viewFrame(CGRectMake(0, self.topOperationView.bottom+47.5, kScreenW, 0.5)).bkgColor(kColorThemeeee)];
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
        _topOperationView.dataArray = @[@{@"logo": @"home_live",
                                          @"title": @"分享获客",
                                          @"subTitle": @"发布海外圈 免费获客",
                                          @"identifier": @"shareArticle"},
                                        @{@"logo": @"home_live",
                                          @"title": @"递名片",
                                          @"subTitle": @"私域流量 精准获客",
                                          @"identifier": @"sendCard"}
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
        _tabScrollView.dataArray = @[@"访客", @"获赞", @"粉丝"];
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
        NSArray *statusArray = @[@(1), @(2), @(3)];
        for (int i=0; i<statusArray.count; i++) {
            CardScrollContentViewController *vc = [[CardScrollContentViewController alloc] init];
            vc.cardType = [statusArray[i] integerValue];
            [contentVCs addObject:vc];
        }
        _pageContentView = [[QHWPageContentView alloc] initWithFrame:CGRectMake(0, self.tabScrollView.bottom, kScreenW, kScreenH-self.tabScrollView.bottom) childVCs:contentVCs parentVC:self delegate:self];
    }
    return _pageContentView;
}

@end
