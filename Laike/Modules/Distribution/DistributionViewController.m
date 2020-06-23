//
//  DistributionViewController.m
//  Laike
//
//  Created by xiaobu on 2020/6/22.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "DistributionViewController.h"
#import "HomeScrollContentViewController.h"
#import "CRMTopOperationView.h"
#import "QHWTabScrollView.h"
#import "QHWPageContentView.h"

@interface DistributionViewController () <QHWPageContentViewDelegate>

@property (nonatomic, strong) CRMTopOperationView *topOperationView;
@property (nonatomic, strong) QHWTabScrollView *tabScrollView;
@property (nonatomic, strong) QHWPageContentView *pageContentView;

@end

@implementation DistributionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.topOperationView];
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
- (CRMTopOperationView *)topOperationView {
    if (!_topOperationView) {
        _topOperationView = [[CRMTopOperationView alloc] initWithFrame:CGRectMake(10, kTopBarHeight+10, kScreenW-20, 70)];
        _topOperationView.dataArray = @[@{@"logo": @"",
                                          @"title": @"客户进度",
                                          @"subTitle": @"进度实时反馈",
                                          @"identifier": @"customerProcess"},
                                        @{@"logo": @"",
                                          @"title": @"预约签单",
                                          @"subTitle": @"客户盘活 高拥结算",
                                          @"identifier": @"bookAppointment"}
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

- (QHWPageContentView *)pageContentView {
    if (!_pageContentView) {
        NSMutableArray *contentVCs = [NSMutableArray array];
        NSArray *statusArray = @[@(1), @(2), @(3)];
        for (int i=0; i<statusArray.count; i++) {
            HomeScrollContentViewController *vc = [[HomeScrollContentViewController alloc] init];
//            vc.cardType = [statusArray[i] integerValue];
            [contentVCs addObject:vc];
        }
        _pageContentView = [[QHWPageContentView alloc] initWithFrame:CGRectMake(0, self.tabScrollView.bottom, kScreenW, kScreenH-self.tabScrollView.bottom) childVCs:contentVCs parentVC:self delegate:self];
        [self.view addSubview:_pageContentView];
    }
    return _pageContentView;
}

@end
