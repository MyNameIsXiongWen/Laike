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
#import "QHWPageContentView.h"
#import "CRMService.h"
#import "CTMediator+ViewController.h"

@interface CRMViewController () <QHWPageContentViewDelegate>

@property (nonatomic, strong) CRMTopOperationView *topOperationView;
@property (nonatomic, strong) QHWTabScrollView *tabScrollView;
@property (nonatomic, strong) QHWPageContentView *pageContentView;
@property (nonatomic, strong) CRMService *crmService;

@end

@implementation CRMViewController

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationAddCustomerSuccess object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.kNavigationView.hidden = YES;
    QHWNavgationView *tempNavigationView = [[QHWNavgationView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kTopBarHeight)];
    tempNavigationView.leftBtn.hidden = !self.interval;
    tempNavigationView.title = @"客户管理";
    [tempNavigationView.rightBtn setTitle:@"+" forState:0];
//    [tempNavigationView.rightBtn setImage:kImageMake(@"customize_add") forState:0];
    [tempNavigationView.leftBtn setImage:kImageMake(@"global_back") forState:0];
    [tempNavigationView.rightAnotherBtn setImage:kImageMake(@"global_search") forState:0];
    [tempNavigationView.leftBtn addTarget:self action:@selector(leftNavBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [tempNavigationView.rightBtn addTarget:self action:@selector(rightNavBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [tempNavigationView.rightAnotherBtn addTarget:self action:@selector(rightAnthorNavBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tempNavigationView];
    
    [self.view addSubview:self.topOperationView];
    [self.view addSubview:self.tabScrollView];
    [self.view addSubview:self.pageContentView];
    [self.view addSubview:UIView.viewFrame(CGRectMake(0, self.topOperationView.bottom-0.5, kScreenW, 0.5)).bkgColor(kColorThemeeee)];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(getMainData) name:kNotificationAddCustomerSuccess object:nil];
    [self getFilterData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)leftNavBtnAction:(UIButton *)sender {
    [self.getCurrentMethodCallerVC.navigationController popViewControllerAnimated:YES];
}

- (void)rightNavBtnAction:(UIButton *)sender {
    [CTMediator.sharedInstance CTMediator_viewControllerForAddCustomerWithCustomerId:@"" RealName:@"" MobilePhone:@""];
}

- (void)rightAnthorNavBtnAction:(UIButton *)sender {
    [self.navigationController pushViewController:NSClassFromString(@"CRMSearchViewController").new animated:YES];
}

- (void)getMainData {
    [self.crmService getHomeReportCountDataWithComplete:^{
        self.tabScrollView.dataArray = @[kFormat(@"CRM %ld", self.crmService.crmCount), kFormat(@"获客 %ld", self.crmService.clueCount)];
    }];
}

- (void)getFilterData {
    [self.crmService getCRMFilterDataRequestWithComplete:^(id  _Nullable responseObject) {
        CRMScrollContentViewController *vc = self.pageContentView.childsVCs.firstObject;
        vc.filterDataArray = self.crmService.filterDataArray;
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
- (CRMTopOperationView *)topOperationView {
    if (!_topOperationView) {
        _topOperationView = [[CRMTopOperationView alloc] initWithFrame:CGRectMake(10, kTopBarHeight+10, kScreenW-20, 70)];
        _topOperationView.dataArray = @[@{@"logo": @"home_live",
                                          @"title": @"分享获客",
                                          @"subTitle": @"发布海外圈 免费获客",
                                          @"identifier": @"shareArticle"},
                                        @{@"logo": @"home_live",
                                          @"title": @"获客资讯",
                                          @"subTitle": @"每日转发 获客利器",
                                          @"identifier": @"communityArticle"}
        ];
    }
    return _topOperationView;
}

- (QHWTabScrollView *)tabScrollView {
    if (!_tabScrollView) {
        _tabScrollView = [[QHWTabScrollView alloc] initWithFrame:CGRectMake(0, self.topOperationView.bottom+10, kScreenW, 48)];
        _tabScrollView.itemWidthType = ItemWidthTypeFixed;
        _tabScrollView.hideIndicatorView = NO;
        _tabScrollView.tagIndicatorColor = kColorThemea4abb3;
        _tabScrollView.itemSelectedColor = kColorThemea4abb3;
        _tabScrollView.itemUnselectedColor = kColorTheme2a303c;
        _tabScrollView.itemSelectedBackgroundColor = kColorThemefff;
        _tabScrollView.itemUnselectedBackgroundColor = kColorThemefff;
        _tabScrollView.dataArray = @[@"CRM", @"获客"];
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
        NSArray *statusArray = @[@(1), @(2)];
        for (int i=0; i<statusArray.count; i++) {
            CRMScrollContentViewController *vc = [[CRMScrollContentViewController alloc] init];
            vc.crmType = [statusArray[i] integerValue];
            vc.interval = self.interval;
            [contentVCs addObject:vc];
        }
        CGFloat height = self.interval ? (kScreenH-self.tabScrollView.bottom) : (kScreenH-self.tabScrollView.bottom-kBottomBarHeight);
        _pageContentView = [[QHWPageContentView alloc] initWithFrame:CGRectMake(0, self.tabScrollView.bottom, kScreenW, height) childVCs:contentVCs parentVC:self delegate:self];
    }
    return _pageContentView;
}

- (CRMService *)crmService {
    if (!_crmService) {
        _crmService = CRMService.new;
    }
    return _crmService;
}

@end
