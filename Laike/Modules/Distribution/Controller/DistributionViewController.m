//
//  DistributionViewController.m
//  Laike
//
//  Created by xiaobu on 2020/6/22.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "DistributionViewController.h"
#import "DistributionScrollContentViewController.h"
#import "DistributionTableHeaderView.h"
#import "QHWBaseSubContentTableViewCell.h"
#import "BrandService.h"

@interface DistributionViewController () <UITableViewDelegate, UITableViewDataSource, QHWPageContentViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DistributionTableHeaderView *distributionTableHeaderView;//tableheaderview
@property (nonatomic, strong) DistributionTypeHeaderView *distributionTypeHeaderView;

@property (nonatomic, strong) QHWBaseSubContentTableViewCell *contentCell;
@property (nonatomic, assign) BOOL canScroll;

@property (nonatomic, strong) BrandService *service;

@end

@implementation DistributionViewController

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self name:@"DistributionSwipeLeaveTop" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.kNavigationView.title = @"分销市场";
    self.kNavigationView.leftBtn.hidden = YES;
    self.canScroll = YES;
    [self.view addSubview:self.tableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeScrollStatusNotification) name:@"DistributionSwipeLeaveTop" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)getMainData {
    [self.service getBrandListRequestComplete:^{
        [self.tableView.mj_header endRefreshing];
        self.distributionTableHeaderView.brandView.dataArray = self.service.tableViewDataArray;
    }];
}

#pragma mark ------------UIScrollView-------------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    列表位移
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    CGFloat bottomCellOffset = self.distributionTableHeaderView.height;
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
    if (_contentCell.viewControllers.count == 0) {
        NSMutableArray *contentVCs = [NSMutableArray array];
        NSArray *identifierArray = @[@"house", @"migration", @"student", @"study", @"treatment"];
        NSArray *typeArray = @[@(1), @(3), @(4), @(2), @(102001)];
        for (int i=0; i<identifierArray.count; i++) {
            DistributionScrollContentViewController *vc = DistributionScrollContentViewController.new;
            vc.identifier = identifierArray[i];
            vc.businessType = [typeArray[i] integerValue];
            [contentVCs addObject:vc];
        }
        _contentCell.viewControllers = contentVCs;
        _contentCell.pageContentView = [[QHWPageContentView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-kTopBarHeight-kBottomBarHeight-32) childVCs:contentVCs parentVC:self delegate:self];
        [_contentCell.contentView addSubview:_contentCell.pageContentView];
    }
    return _contentCell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (!self.distributionTypeHeaderView) {
        self.distributionTypeHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(DistributionTypeHeaderView.class)];
        self.distributionTypeHeaderView.tabScrollView.dataArray = @[@"海外房产", @"移民", @"留学", @"游学", @"海外医疗"];
        WEAKSELF
        self.distributionTypeHeaderView.tabScrollView.clickTagBlock = ^(NSInteger index) {
            weakSelf.contentCell.pageContentView.contentViewCurrentIndex = index;
        };
    }
    return self.distributionTypeHeaderView;
}

#pragma mark ------------QHWPageContentViewDelegate-------------
- (void)QHWContentViewWillBeginDragging:(QHWPageContentView *)contentView {
    self.tableView.scrollEnabled = NO;
}

- (void)QHWContentViewDidEndDecelerating:(QHWPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    self.tableView.scrollEnabled = YES;
    [self.distributionTypeHeaderView.tabScrollView scrollToIndex:endIndex];
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
        _tableView = [UICreateView initWithRecognizeSimultaneouslyFrame:CGRectMake(0, kTopBarHeight, kScreenW, kScreenH-kTopBarHeight-kBottomBarHeight) Style:UITableViewStylePlain Object:self];
        _tableView.scrollsToTop = NO;
        _tableView.tableHeaderView = self.distributionTableHeaderView;
        _tableView.rowHeight = kScreenH-kStatusBarHeight-kBottomBarHeight-32;
        _tableView.sectionHeaderHeight = 32;
        [_tableView registerClass:QHWBaseSubContentTableViewCell.class forCellReuseIdentifier:NSStringFromClass(QHWBaseSubContentTableViewCell.class)];
        [_tableView registerClass:DistributionTypeHeaderView.class forHeaderFooterViewReuseIdentifier:NSStringFromClass(DistributionTypeHeaderView.class)];
        [QHWRefreshManager.sharedInstance normalHeaderWithScrollView:_tableView RefreshBlock:^{
            [self getMainData];
        }];
    }
    return _tableView;
}

- (DistributionTableHeaderView *)distributionTableHeaderView {
    if (!_distributionTableHeaderView) {
        _distributionTableHeaderView = [[DistributionTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 260)];
    }
    return _distributionTableHeaderView;
}

- (BrandService *)service {
    if (!_service) {
        _service = BrandService.new;
    }
    return _service;
}

@end

@implementation DistributionTypeHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = kColorThemefff;
    }
    return self;
}

- (QHWTabScrollView *)tabScrollView {
    if (!_tabScrollView) {
        _tabScrollView = [[QHWTabScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 32)];
        _tabScrollView.itemWidthType = ItemWidthTypeFixedAdaptive;
        _tabScrollView.itemSelectedColor = kColorTheme21a8ff;
        _tabScrollView.itemUnselectedColor = kColorTheme2a303c;
        _tabScrollView.itemSelectedBackgroundColor = kColorThemefff;
        _tabScrollView.itemUnselectedBackgroundColor = kColorThemefff;
        _tabScrollView.textFont = kMediumFontTheme18;
        _tabScrollView.dataArray = @[@"海外房产", @"移民", @"留学", @"游学", @"海外医疗"];
        [self addSubview:_tabScrollView];
        [self addSubview:UIView.viewFrame(CGRectMake(0, _tabScrollView.bottom-0.5, kScreenW, 0.5)).bkgColor(kColorThemeeee)];
    }
    return _tabScrollView;
}

@end
