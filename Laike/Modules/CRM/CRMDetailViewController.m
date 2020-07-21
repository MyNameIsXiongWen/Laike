//
//  CRMDetailViewController.m
//  Laike
//
//  Created by xiaobu on 2020/7/2.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "CRMDetailViewController.h"
#import "CRMDetailHeaderView.h"
#import "QHWBaseSubContentTableViewCell.h"
#import "CRMDetailScrollContentViewController.h"
#import "CRMService.h"
#import "CTMediator+ViewController.h"
#import "QHWMoreView.h"
#import "QHWLabelAlertView.h"

@interface CRMDetailViewController () <UITableViewDelegate, UITableViewDataSource, QHWPageContentViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CRMDetailHeaderView *tableHeaderView;
@property (nonatomic, strong) CRMDetailSectionHeaderView *sectionHeaderView;
@property (nonatomic, strong) CRMDetailBottomView *btmView;

@property (nonatomic, strong) QHWBaseSubContentTableViewCell *contentCell;
@property (nonatomic, assign) BOOL canScroll;
@property (nonatomic, strong) CRMService *crmService;

@end

@implementation CRMDetailViewController

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationAddCustomerSuccess object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:@"CRMDetailSwipeLeaveTop" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.kNavigationView.title = @"客户详情";
    [self.kNavigationView.rightBtn setImage:kImageMake(@"global_more") forState:0];
    self.canScroll = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeScrollStatusNotification) name:@"CRMDetailSwipeLeaveTop" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMainData) name:kNotificationAddCustomerSuccess object:nil];
    [self.view addSubview:self.btmView];
}

- (void)rightNavBtnAction:(UIButton *)sender {
    QHWMoreView *moreView = [[QHWMoreView alloc] initWithFrame:CGRectMake(kScreenW-125, kTopBarHeight, 105, 85)
                                                     ViewArray:@[@{@"title":@"完善信息", @"identifier":@"completeInfomation"},
                                                                 @{@"title":@"放弃跟进", @"identifier":@"giveUpFollowUp"}]];
    WEAKSELF
    moreView.clickBtnBlock = ^(NSString * _Nonnull identifier) {
        if ([identifier isEqualToString:@"completeInfomation"]) {
            [CTMediator.sharedInstance CTMediator_viewControllerForAddCustomerWithCustomerId:weakSelf.customerId RealName:@"" MobilePhone:@""];
        } else if ([identifier isEqualToString:@"giveUpFollowUp"]) {
            [weakSelf showAlertLabelView];
        }
    };
    [moreView show];
}

- (void)showAlertLabelView {
    QHWLabelAlertView *alert = [[QHWLabelAlertView alloc] initWithFrame:CGRectZero];
    [alert configWithTitle:@"提醒" cancleText:@"取消" confirmText:@"确认"];
    alert.contentString = @"是否放弃跟进?";
    WEAKSELF
    alert.confirmBlock = ^{
        [alert dismiss];
        [weakSelf.crmService CRMGiveUpTrackRequest];
    };
    [alert show];
}

- (void)getMainData {
    [self.crmService getCRMDetailInfoRequestWithComplete:^{
        self.kNavigationView.title = self.crmService.crmModel.realName;
        self.tableHeaderView.crmModel = self.crmService.crmModel;
        self.tableHeaderView.height = self.crmService.tableHeaderViewHeight;
        self.btmView.mobilePhone = self.crmService.crmModel.mobileNumber;
        [self.tableView reloadData];
    }];
}

#pragma mark ------------UIScrollView-------------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    列表位移
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    CGFloat bottomCellOffset = self.tableHeaderView.height;
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
    NSArray *identifierArray = @[@"track", @"advisory"];
    if (_contentCell.viewControllers.count == 0) {
        NSMutableArray *contentVCs = [NSMutableArray array];
        for (int i=0; i<identifierArray.count; i++) {
            CRMDetailScrollContentViewController *vc = [[CRMDetailScrollContentViewController alloc] init];
            vc.identifier = identifierArray[i];
            vc.crmService = self.crmService;
            [contentVCs addObject:vc];
        }
        _contentCell.viewControllers = contentVCs;
        _contentCell.pageContentView = [[QHWPageContentView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-kBottomDangerHeight-75-kStatusBarHeight-42) childVCs:contentVCs parentVC:self delegate:self];
        [_contentCell.contentView addSubview:_contentCell.pageContentView];
    }
    return _contentCell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (!self.sectionHeaderView) {
        self.sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(CRMDetailSectionHeaderView.class)];
        self.sectionHeaderView.tabScrollView.dataArray = @[@"跟进记录", @"咨询记录"];
        WEAKSELF
        self.sectionHeaderView.tabScrollView.clickTagBlock = ^(NSInteger index) {
            weakSelf.contentCell.pageContentView.contentViewCurrentIndex = index;
        };
    }
    return self.sectionHeaderView;
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
    [self.sectionHeaderView.tabScrollView scrollToIndex:endIndex];
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
        _tableView = [UICreateView initWithRecognizeSimultaneouslyFrame:CGRectMake(0, kTopBarHeight, kScreenW, kScreenH-kTopBarHeight-kBottomDangerHeight-75) Style:UITableViewStylePlain Object:self];
        _tableView.scrollsToTop = NO;
        _tableView.tableHeaderView = self.tableHeaderView;
        _tableView.rowHeight = kScreenH-kBottomDangerHeight-75-kStatusBarHeight-42;
        _tableView.sectionHeaderHeight = 42;
        [_tableView registerClass:QHWBaseSubContentTableViewCell.class forCellReuseIdentifier:NSStringFromClass(QHWBaseSubContentTableViewCell.class)];
        [_tableView registerClass:CRMDetailSectionHeaderView.class forHeaderFooterViewReuseIdentifier:NSStringFromClass(CRMDetailSectionHeaderView.class)];
//        [QHWRefreshManager.sharedInstance normalHeaderWithScrollView:_tableView RefreshBlock:^{
//            [self getMainData];
//        }];
        [self.view addSubview:_tableView];
        [self.view sendSubviewToBack:_tableView];
    }
    return _tableView;
}

- (CRMDetailHeaderView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[CRMDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 42)];
    }
    return _tableHeaderView;
}

- (CRMDetailBottomView *)btmView {
    if (!_btmView) {
        _btmView = [[CRMDetailBottomView alloc] initWithFrame:CGRectMake(0, kScreenH-kBottomDangerHeight-75, kScreenW, 75)];
        _btmView.customerId = self.customerId;
    }
    return _btmView;
}

- (CRMService *)crmService {
    if (!_crmService) {
        _crmService = CRMService.new;
        _crmService.customerId = self.customerId;
    }
    return _crmService;
}

@end

@implementation CRMDetailSectionHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = kColorThemefff;
    }
    return self;
}

- (QHWTabScrollView *)tabScrollView {
    if (!_tabScrollView) {
        _tabScrollView = [[QHWTabScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 42)];
        _tabScrollView.itemWidthType = ItemWidthTypeFixed;
        _tabScrollView.itemSelectedColor = kColorTheme21a8ff;
        _tabScrollView.itemUnselectedColor = kColorTheme000;
        _tabScrollView.itemSelectedBackgroundColor = kColorThemefff;
        _tabScrollView.itemUnselectedBackgroundColor = kColorThemefff;
        _tabScrollView.textFont = kFontTheme16;
        [self addSubview:_tabScrollView];
        [self addSubview:UIView.viewFrame(CGRectMake(0, 41.5, kScreenW, 0.5)).bkgColor(kColorThemeeee)];
    }
    return _tabScrollView;
}

@end

@implementation CRMDetailBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.infoBtn = UIButton.btnFrame(CGRectMake(15, 12, 50, 55)).btnImage(kImageMake(@"crm_info")).btnAction(self, @selector(clickInfoBtn));
        self.infoBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        [self.infoBtn addSubview:UILabel.labelFrame(CGRectMake(0, 40, 50, 15)).labelText(@"完善信息").labelFont(kFontTheme10).labelTitleColor(kColorTheme666).labelTextAlignment(NSTextAlignmentCenter)];
        [self addSubview:self.infoBtn];
        
        self.trackBtn = UIButton.btnFrame(CGRectMake(self.infoBtn.right+10, 15, 50, 55)).btnImage(kImageMake(@"crm_record")).btnAction(self, @selector(clickTrackBtn));
        self.trackBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        [self.trackBtn addSubview:UILabel.labelFrame(CGRectMake(0, 37, 50, 15)).labelText(@"跟进记录").labelFont(kFontTheme10).labelTitleColor(kColorTheme666).labelTextAlignment(NSTextAlignmentCenter)];
        [self addSubview:self.trackBtn];
        
        self.contactBtn = UIButton.btnFrame(CGRectMake(self.trackBtn.right+25, 15, kScreenW-170, 45)).btnTitle(@"联系客户").btnFont(kFontTheme18).btnTitleColor(kColorThemefff).btnBkgColor(kColorTheme21a8ff).btnCornerRadius(5).btnAction(self, @selector(clickContactBtn));
        [self addSubview:self.contactBtn];
        
        [self addSubview:UIView.viewFrame(CGRectMake(0, 0, kScreenW, 0.5)).bkgColor(kColorThemeeee)];
    }
    return self;
}

- (void)clickInfoBtn {
    [CTMediator.sharedInstance CTMediator_viewControllerForAddCustomerWithCustomerId:self.customerId RealName:@"" MobilePhone:@""];
}

- (void)clickTrackBtn {
    [CTMediator.sharedInstance CTMediator_viewControllerForAddTrackWithCustomerId:self.customerId];
}

- (void)clickContactBtn {
    kCallTel(self.mobilePhone);
}

@end
