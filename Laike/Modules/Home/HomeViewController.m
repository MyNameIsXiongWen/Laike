//
//  HomeViewController.m
//  Laike
//
//  Created by xiaobu on 2020/6/22.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeTableHeaderView.h"
#import "QHWBaseSubContentTableViewCell.h"
#import "HomeScrollContentViewController.h"
#import "HomeService.h"
#import "QHWSystemService.h"
#import "QSchoolService.h"

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource, QHWPageContentViewDelegate, HomeTableHeaderViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HomeTableHeaderView *homeTableHeaderView;//tableheaderview
@property (nonatomic, strong) HomeCommunityTypeHeaderView *homeCommunityTypeHeaderView;//headerview

@property (nonatomic, strong) QHWBaseSubContentTableViewCell *contentCell;
@property (nonatomic, assign) BOOL canScroll;
@property (nonatomic, strong) HomeService *homeService;
@property (nonatomic, strong) QHWSystemService *systemService;
@property (nonatomic, strong) QSchoolService *schoolService;
@property (nonatomic, strong) dispatch_group_t group;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.canScroll = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeScrollStatusNotification) name:@"HomeSwipeLeaveTop" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.kNavigationView.hidden = YES;
}

- (void)getMainData {
    [self getConsultantRequest];
    [self getReportRequest];
    [self getPopularityRequest];
    [self getHomeSchoolRequest];
    dispatch_group_notify(self.group, dispatch_get_main_queue(), ^{
        self.homeService.consultantArray = self.systemService.consultantArray;
        self.homeService.schoolArray = self.schoolService.tableViewDataArray;
        [self.homeService handleHomeData];
        self.homeTableHeaderView.height = self.homeService.headerViewTableHeight;
        self.homeTableHeaderView.service = self.homeService;
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    });
}

- (void)getConsultantRequest {
    dispatch_group_enter(self.group);
    [self.homeService getHomeConsultantDataWithComplete:^{
        dispatch_group_leave(self.group);
    }];
}

- (void)getReportRequest {
    dispatch_group_enter(self.group);
    [self.homeService getHomeReportDataWithComplete:^{
        dispatch_group_leave(self.group);
    }];
}

- (void)getPopularityRequest {
    dispatch_group_enter(self.group);
    [self.systemService getLikeRankRequestWithSubjectType:1 Complete: ^{
        dispatch_group_leave(self.group);
    }];
}

- (void)getHomeSchoolRequest {
    dispatch_group_enter(self.group);
    [self.schoolService getSchoolDataWithLearnType:1 Complete:^{
        dispatch_group_leave(self.group);
    }];
}

#pragma mark ------------UIScrollView-------------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    列表位移
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    CGFloat bottomCellOffset = self.homeTableHeaderView.height;
    if (contentOffsetY >= bottomCellOffset) {
        scrollView.contentOffset = CGPointMake(0, bottomCellOffset);
        if (self.canScroll) {
            self.canScroll = NO;
            self.contentCell.cellCanScroll = YES;
        }
    } else {
        if (!self.canScroll) {//子视图没到顶部
            scrollView.contentOffset = CGPointMake(0, bottomCellOffset);
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.contentCell.pageContentView.contentViewCanScroll = NO;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSLog(@"DidEndScrolling===%f", scrollView.contentOffset.y);
    [self scrollViewEndAnimate:scrollView];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    [self scrollViewEndAnimate:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewEndAnimate:scrollView];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    [self scrollViewEndAnimate:scrollView];
}

- (void)scrollViewEndAnimate:(UIScrollView *)scrollView {
    self.contentCell.pageContentView.contentViewCanScroll = YES;
}

#pragma mark ------------Notification-------------
- (void)changeScrollStatusNotification {//改变主视图的状态
    self.canScroll = YES;
    self.contentCell.cellCanScroll = NO;
}

#pragma mark ------------UITableView Delegate-------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    _contentCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(QHWBaseSubContentTableViewCell.class)];
    NSArray *identifierArray = @[@"house", @"migration", @"student", @"study", @"treatment"];
    if (_contentCell.viewControllers.count == 0) {
        NSMutableArray *contentVCs = [NSMutableArray array];
        for (int i=0; i<identifierArray.count; i++) {
            HomeScrollContentViewController *vc = [[HomeScrollContentViewController alloc] init];
            vc.identifier = identifierArray[i];
            vc.pageType = 1;
            [contentVCs addObject:vc];
        }
        _contentCell.viewControllers = contentVCs;
        _contentCell.pageContentView = [[QHWPageContentView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-kBottomBarHeight-kStatusBarHeight-32) childVCs:contentVCs parentVC:self delegate:self];
        [_contentCell.contentView addSubview:_contentCell.pageContentView];
    }
    return _contentCell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (!self.homeCommunityTypeHeaderView) {
        self.homeCommunityTypeHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(HomeCommunityTypeHeaderView.class)];
        self.homeCommunityTypeHeaderView.tabScrollView.dataArray = @[@"海外房产", @"移民", @"留学", @"游学", @"海外医疗"];
        WEAKSELF
        self.homeCommunityTypeHeaderView.tabScrollView.clickTagBlock = ^(NSInteger index) {
            weakSelf.contentCell.pageContentView.contentViewCurrentIndex = index;
        };
    }
    return self.homeCommunityTypeHeaderView;
}

#pragma mark ------------HomeTableHeaderViewDelegate-------------
- (void)HomeTableHeaderView_selectedTabScrollView:(NSInteger)index {
//    self.contentCell.pageContentView.contentViewCurrentIndex = index;
}

#pragma mark ------------QHWPageContentViewDelegate-------------
- (void)QHWContentViewWillBeginDragging:(QHWPageContentView *)contentView {
    self.tableView.scrollEnabled = NO;
}

- (void)QHWContentViewDidEndDecelerating:(QHWPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    self.tableView.scrollEnabled = YES;
    [self.homeCommunityTypeHeaderView.tabScrollView scrollToIndex:endIndex];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UICreateView initWithRecognizeSimultaneouslyFrame:CGRectMake(0, 0, kScreenW, kScreenH-kBottomBarHeight) Style:UITableViewStylePlain Object:self];
        _tableView.scrollsToTop = NO;
        _tableView.tableHeaderView = self.homeTableHeaderView;
        _tableView.rowHeight = kScreenH-kBottomBarHeight-kStatusBarHeight-32;
        _tableView.sectionHeaderHeight = kStatusBarHeight+32;
        [_tableView registerClass:QHWBaseSubContentTableViewCell.class forCellReuseIdentifier:NSStringFromClass(QHWBaseSubContentTableViewCell.class)];
        [_tableView registerClass:HomeCommunityTypeHeaderView.class forHeaderFooterViewReuseIdentifier:NSStringFromClass(HomeCommunityTypeHeaderView.class)];
        [QHWRefreshManager.sharedInstance normalHeaderWithScrollView:_tableView RefreshBlock:^{
            [self getMainData];
        }];
        [self.view addSubview:_tableView];
        [self.view sendSubviewToBack:_tableView];
    }
    return _tableView;
}

- (HomeTableHeaderView *)homeTableHeaderView {
    if (!_homeTableHeaderView) {
        _homeTableHeaderView = [[HomeTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 42)];
        _homeTableHeaderView.delegate = self;
    }
    return _homeTableHeaderView;
}

- (HomeService *)homeService {
    if (!_homeService) {
        _homeService = HomeService.new;
    }
    return _homeService;
}

- (QHWSystemService *)systemService {
    if (!_systemService) {
        _systemService = QHWSystemService.new;
    }
    return _systemService;
}

- (QSchoolService *)schoolService {
    if (!_schoolService) {
        _schoolService = QSchoolService.new;
    }
    return _schoolService;
}

- (dispatch_group_t)group {
    if (!_group) {
        _group = dispatch_group_create();
    }
    return _group;
}

@end

@implementation HomeCommunityTypeHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = kColorThemefff;
    }
    return self;
}

- (QHWTabScrollView *)tabScrollView {
    if (!_tabScrollView) {
        _tabScrollView = [[QHWTabScrollView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, kScreenW, 32)];
        _tabScrollView.itemWidthType = ItemWidthTypeFixedAdaptive;
        _tabScrollView.itemSelectedColor = kColorThemefb4d56;
        _tabScrollView.itemUnselectedColor = kColorTheme2a303c;
        _tabScrollView.itemSelectedBackgroundColor = kColorThemefff;
        _tabScrollView.itemUnselectedBackgroundColor = kColorThemefff;
        _tabScrollView.textFont = kMediumFontTheme18;
        [self addSubview:_tabScrollView];
    }
    return _tabScrollView;
}

@end
