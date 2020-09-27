//
//  CRMViewController.m
//  Laike
//
//  Created by xiaobu on 2020/6/23.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "CRMViewController.h"
#import "CRMScrollContentViewController.h"
#import "CardScrollContentViewController.h"
#import "CRMService.h"
#import "CTMediator+ViewController.h"
#import "UserModel.h"
#import "QHWBaseSubContentTableViewCell.h"

@interface CRMViewController ()  <UITableViewDelegate, UITableViewDataSource, QHWPageContentViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CRMTableHeaderView *crmTableHeaderView;//tableheaderview
@property (nonatomic, strong) CRMTypeHeaderView *crmTypeHeaderView;

@property (nonatomic, strong) QHWBaseSubContentTableViewCell *contentCell;
@property (nonatomic, assign) BOOL canScroll;

@property (nonatomic, strong) CRMService *crmService;

@end

@implementation CRMViewController

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self name:@"CRMSwipeLeaveTop" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.kNavigationView.hidden = YES;
    QHWNavgationView *tempNavigationView = [[QHWNavgationView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kTopBarHeight)];
    tempNavigationView.leftBtn.hidden = !self.interval;
    tempNavigationView.title = @"客户管理";
    tempNavigationView.rightBtn.btnTitle(@"+").btnTitleColor(kColorFromHexString(@"a0a0a0")).btnFont([UIFont systemFontOfSize:30 weight:UIFontWeightThin]).btnAction(self, @selector(rightNavBtnAction:));
    tempNavigationView.rightBtn.y = kStatusBarHeight-2;
    [tempNavigationView.leftBtn setImage:kImageMake(@"global_back") forState:0];
    [tempNavigationView.leftBtn addTarget:self action:@selector(leftNavBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [tempNavigationView.rightAnotherBtn addTarget:self action:@selector(rightAnthorNavBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tempNavigationView];
    
    [self.view addSubview:self.tableView];
    self.canScroll = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeScrollStatusNotification) name:@"CRMSwipeLeaveTop" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self getMainData];
    if (self.crmService.filterDataArray.count == 0) {
        [self getFilterData];
    }
}

- (void)leftNavBtnAction:(UIButton *)sender {
    [self.getCurrentMethodCallerVC.navigationController popViewControllerAnimated:YES];
}

- (void)rightNavBtnAction:(UIButton *)sender {
    [CTMediator.sharedInstance CTMediator_viewControllerForAddCustomerWithCustomerId:@"" RealName:@"" MobilePhone:@""];
}

- (void)getMainData {
    [self.crmService getHomeReportCountDataWithComplete:^{
        NSInteger index = self.crmTypeHeaderView.tabScrollView.currentIndex;
        self.crmTypeHeaderView.tabScrollView.dataArray = @[kFormat(@"访客（%ld）", (long)UserModel.shareUser.visitCount), kFormat(@"线索（%ld）", self.crmService.clueCount), kFormat(@"客户（%ld）", self.crmService.crmCount)];
        [self.crmTypeHeaderView.tabScrollView scrollToIndex:index];
    }];
}

- (void)getFilterData {
    [self.crmService getCRMFilterDataRequestWithComplete:^(id  _Nullable responseObject) {
        CRMScrollContentViewController *vc = self.contentCell.pageContentView.childsVCs[2];
        vc.filterDataArray = self.crmService.filterDataArray;
    }];
}

#pragma mark ------------UIScrollView-------------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    列表位移
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    CGFloat bottomCellOffset = self.crmTableHeaderView.height;
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
        CardScrollContentViewController *vc = [[CardScrollContentViewController alloc] init];
        vc.cardType = 1;
        [contentVCs addObject:vc];
        NSArray *statusArray = @[@(2), @(1)];
        for (int i=0; i<statusArray.count; i++) {
            CRMScrollContentViewController *vc = [[CRMScrollContentViewController alloc] init];
            vc.crmType = [statusArray[i] integerValue];
            vc.interval = self.interval;
            [contentVCs addObject:vc];
        }
        _contentCell.viewControllers = contentVCs;
        _contentCell.pageContentView = [[QHWPageContentView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-kTopBarHeight-kBottomBarHeight-32) childVCs:contentVCs parentVC:self delegate:self];
        [_contentCell.contentView addSubview:_contentCell.pageContentView];
    }
    return _contentCell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (!self.crmTypeHeaderView) {
        self.crmTypeHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(CRMTypeHeaderView.class)];
        self.crmTypeHeaderView.tabScrollView.dataArray = @[kFormat(@"访客（%ld）", (long)UserModel.shareUser.visitCount), @"线索", @"客户"];
        WEAKSELF
        self.crmTypeHeaderView.tabScrollView.clickTagBlock = ^(NSInteger index) {
            weakSelf.contentCell.pageContentView.contentViewCurrentIndex = index;
            [weakSelf configCRMContentVCCallObserveWithIndex:index];
        };
    }
    return self.crmTypeHeaderView;
}

#pragma mark ------------QHWPageContentViewDelegate-------------
- (void)QHWContentViewWillBeginDragging:(QHWPageContentView *)contentView {
    self.tableView.scrollEnabled = NO;
}

- (void)QHWContentViewDidEndDecelerating:(QHWPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    self.tableView.scrollEnabled = YES;
    [self.crmTypeHeaderView.tabScrollView scrollToIndex:endIndex];
    [self configCRMContentVCCallObserveWithIndex:endIndex];
}

- (void)configCRMContentVCCallObserveWithIndex:(NSInteger)index {
    CRMScrollContentViewController *vc0 = (CRMScrollContentViewController *)self.contentCell.pageContentView.childsVCs[1];
    vc0.selectedIndex = index;
    CRMScrollContentViewController *vc1 = (CRMScrollContentViewController *)self.contentCell.pageContentView.childsVCs[2];
    vc1.selectedIndex = index;
    if (index == 1) {
        vc1.callObserve = CXCallObserver.new;
        [vc1.callObserve setDelegate:vc1 queue:nil];
    } else {
        [vc1.callObserve setDelegate:nil queue:nil];
        vc1.callObserve = nil;
    }
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
        _tableView.tableHeaderView = self.crmTableHeaderView;
        _tableView.rowHeight = kScreenH-kStatusBarHeight-kBottomBarHeight-32;
        _tableView.sectionHeaderHeight = 32;
        [_tableView registerClass:QHWBaseSubContentTableViewCell.class forCellReuseIdentifier:NSStringFromClass(QHWBaseSubContentTableViewCell.class)];
        [_tableView registerClass:CRMTypeHeaderView.class forHeaderFooterViewReuseIdentifier:NSStringFromClass(CRMTypeHeaderView.class)];
        [QHWRefreshManager.sharedInstance normalHeaderWithScrollView:_tableView RefreshBlock:^{
            [self getMainData];
        }];
    }
    return _tableView;
}

- (CRMTableHeaderView *)crmTableHeaderView {
    if (!_crmTableHeaderView) {
        _crmTableHeaderView = [[CRMTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 247)];
    }
    return _crmTableHeaderView;
}

- (CRMService *)crmService {
    if (!_crmService) {
        _crmService = CRMService.new;
    }
    return _crmService;
}

@end

@implementation CRMTypeHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = kColorThemefff;
    }
    return self;
}

- (QHWTabScrollView *)tabScrollView {
    if (!_tabScrollView) {
        _tabScrollView = [[QHWTabScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 32)];
        _tabScrollView.itemWidthType = ItemWidthTypeFixed;
        _tabScrollView.hideIndicatorView = NO;
        _tabScrollView.tagIndicatorColor = kColorTheme21a8ff;
        _tabScrollView.itemSelectedColor = kColorTheme21a8ff;
        _tabScrollView.itemUnselectedColor = kColorTheme2a303c;
        _tabScrollView.itemSelectedBackgroundColor = kColorThemefff;
        _tabScrollView.itemUnselectedBackgroundColor = kColorThemefff;
        _tabScrollView.textFont = kMediumFontTheme18;
        [self addSubview:_tabScrollView];
    }
    return _tabScrollView;
}

@end

@implementation CRMTableHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self addSubview:self.searchBkgView];
        [self addSubview:self.topOperationView];
    }
    return self;
}

- (SearchBkgView *)searchBkgView {
    if (!_searchBkgView) {
        _searchBkgView = [[SearchBkgView alloc] initWithFrame:CGRectMake(0, 10, kScreenW, 32)];
        _searchBkgView.placeholderLabel.text = @"输入客户姓名或电话";
        WEAKSELF
        _searchBkgView.clickSearchBkgBlock = ^{
            [weakSelf.getCurrentMethodCallerVC.navigationController pushViewController:NSClassFromString(@"CRMSearchViewController").new animated:YES];
        };
    }
    return _searchBkgView;
}

- (CRMTopOperationView *)topOperationView {
    if (!_topOperationView) {
        UILabel *label = UILabel.labelFrame(CGRectMake(10, self.searchBkgView.bottom, kScreenW-20, 40)).labelText(@"推广获客").labelTitleColor(kColorTheme000).labelFont(kMediumFontTheme16);
        [self addSubview:label];
        _topOperationView = [[CRMTopOperationView alloc] initWithFrame:CGRectMake(0, label.bottom, kScreenW, 150)];
        _topOperationView.dataArray = @[[TopOperationModel initialWithLogo:@"home_community_content"
                                                                     Title:@"发海外圈"
                                                                  SubTitle:@"打造个人IP"
                                                                Identifier:@"community_content"],
                                        [TopOperationModel initialWithLogo:@"home_gallery"
                                                                     Title:@"海报获客"
                                                                  SubTitle:@"生成专属海报"
                                                                Identifier:@"home_gallery"],
                                        [TopOperationModel initialWithLogo:@"home_product"
                                                                     Title:@"产品素材"
                                                                  SubTitle:@"公司优质产品"
                                                                Identifier:@"home_product"],
                                        [TopOperationModel initialWithLogo:@"home_card"
                                                                     Title:@"专属名片"
                                                                  SubTitle:@"转发认证名片"
                                                                Identifier:@"home_card"]
                            ];
    }
    return _topOperationView;
}

@end
