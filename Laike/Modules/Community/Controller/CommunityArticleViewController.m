//
//  CommunityArticleViewController.m
//  Laike
//
//  Created by xiaobu on 2020/7/8.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "CommunityArticleViewController.h"
#import "CommunityArticleScrollContentViewController.h"
#import "QHWTabScrollView.h"
#import "QHWPageContentView.h"

@interface CommunityArticleViewController () <QHWPageContentViewDelegate>

@property (nonatomic, strong) QHWTabScrollView *tabScrollView;
@property (nonatomic, strong) QHWPageContentView *pageContentView;

@end

@implementation CommunityArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.kNavigationView.title = @"获客资讯";
    [self.view addSubview:self.tabScrollView];
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

- (QHWTabScrollView *)tabScrollView {
    if (!_tabScrollView) {
        _tabScrollView = [[QHWTabScrollView alloc] initWithFrame:CGRectMake(0, kTopBarHeight, kScreenW, 48)];
        _tabScrollView.itemWidthType = ItemWidthTypeFixedAdaptive;
        _tabScrollView.hideIndicatorView = NO;
        _tabScrollView.tagIndicatorColor = kColorTheme21a8ff;
        _tabScrollView.itemSelectedColor = kColorTheme21a8ff;
        _tabScrollView.itemUnselectedColor = kColorTheme2a303c;
        _tabScrollView.itemSelectedBackgroundColor = kColorThemefff;
        _tabScrollView.itemUnselectedBackgroundColor = kColorThemefff;
        _tabScrollView.dataArray = @[@"全部", @"海外房产", @"移民", @"留学", @"游学", @"海外医疗"];
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
        NSArray *statusArray = @[@(0), @(1), @(3), @(4), @(2), @(102001)];
        for (int i=0; i<statusArray.count; i++) {
            CommunityArticleScrollContentViewController *vc = [[CommunityArticleScrollContentViewController alloc] init];
            vc.businessType = [statusArray[i] integerValue];
            [contentVCs addObject:vc];
        }
        _pageContentView = [[QHWPageContentView alloc] initWithFrame:CGRectMake(0, self.tabScrollView.bottom, kScreenW, kScreenH-self.tabScrollView.bottom) childVCs:contentVCs parentVC:self delegate:self];
    }
    return _pageContentView;
}

@end
