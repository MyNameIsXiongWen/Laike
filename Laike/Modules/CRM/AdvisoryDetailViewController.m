//
//  AdvisoryDetailViewController.m
//  Laike
//
//  Created by xiaobu on 2020/7/4.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "AdvisoryDetailViewController.h"
#import "AdvisoryDetailHeaderView.h"
#import "CRMService.h"
#import "QHWMoreView.h"
#import "CTMediator+ViewController.h"
#import "CRMTrackCell.h"
#import "QHWLabelAlertView.h"
#import <CallKit/CallKit.h>

@interface AdvisoryDetailViewController () <UITableViewDelegate, UITableViewDataSource, CXCallObserverDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) AdvisoryDetailHeaderView *tableHeaderView;
@property (nonatomic, strong) AdvisoryDetailBottomView *btmView;
@property (nonatomic, strong) CRMService *crmService;
@property (nonatomic, strong) CXCallObserver *callObserve;
@property (nonatomic, assign) BOOL showCallAlertView;

@end

@implementation AdvisoryDetailViewController

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.kNavigationView.title = @"获客详情";
    [self.kNavigationView.rightBtn setImage:kImageMake(@"global_more") forState:0];
    [self.view addSubview:self.btmView];
    self.callObserve = CXCallObserver.new;
    [self.callObserve setDelegate:self queue:dispatch_get_main_queue()];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(getMainData) name:kNotificationAddCustomerSuccess object:nil];
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    if (!parent) {
        [NSNotificationCenter.defaultCenter removeObserver:self];
        self.callObserve = nil;
    }
}

- (void)callObserver:(CXCallObserver *)callObserver callChanged:(CXCall *)call {
    if (![NSStringFromClass(self.getCurrentMethodCallerVC.class) isEqualToString:NSStringFromClass(self.class)]) {
        return;
    }
    if (call.outgoing && call.hasEnded) {
        if (!self.showCallAlertView) {
            self.showCallAlertView = YES;
            QHWLabelAlertView *alert = [[QHWLabelAlertView alloc] initWithFrame:CGRectZero];
            alert.closeBtn.hidden = NO;
            [alert configWithTitle:@"通话反馈" cancleText:@"放弃跟进" confirmText:@"转到客户"];
            alert.contentString = @"您联系的客户是否可以继续跟进，建议多次联系，可增加成交机会";
            WEAKSELF
            alert.closeBlock = ^{
                weakSelf.showCallAlertView = NO;
            };
            alert.cancelBlock = ^{
                weakSelf.showCallAlertView = NO;
                [weakSelf showAlertLabelView];
            };
            alert.confirmBlock = ^{
                weakSelf.showCallAlertView = NO;
                [alert dismiss];
                if (![NSStringFromClass(weakSelf.getCurrentMethodCallerVC.class) isEqualToString:@"CRMAddCustomerViewController"]) {
                    [CTMediator.sharedInstance CTMediator_viewControllerForAddCustomerWithCustomerId:@"" RealName:weakSelf.crmService.crmModel.realName MobilePhone:weakSelf.crmService.crmModel.mobileNumber];
                }
            };
            [alert show];
        }
    }
}

- (void)rightNavBtnAction:(UIButton *)sender {
    QHWMoreView *moreView = [[QHWMoreView alloc] initWithFrame:CGRectMake(kScreenW-125, kTopBarHeight, 105, 85)
                                                     ViewArray:@[@{@"title":@"转到客户", @"identifier":@"convertCRM"},
                                                                 @{@"title":@"放弃跟进", @"identifier":@"giveUpFollowUp"}]];
    WEAKSELF
    moreView.clickBtnBlock = ^(NSString * _Nonnull identifier) {
        if ([identifier isEqualToString:@"convertCRM"]) {
            [CTMediator.sharedInstance CTMediator_viewControllerForAddCustomerWithCustomerId:@"" RealName:weakSelf.crmService.crmModel.realName MobilePhone:weakSelf.crmService.crmModel.mobileNumber];
        } else if ([identifier isEqualToString:@"giveUpFollowUp"]) {
            [weakSelf showAlertLabelView];
        }
    };
    [moreView show];
}

- (void)showAlertLabelView {
    QHWLabelAlertView *alert = [[QHWLabelAlertView alloc] initWithFrame:CGRectZero];
    [alert configWithTitle:@"放弃跟进" cancleText:@"取消" confirmText:@"确认放弃"];
    alert.contentString = @"放弃跟进，您的客户将会转回到公司公客";
    WEAKSELF
    alert.confirmBlock = ^{
        [alert dismiss];
        [weakSelf.crmService advisoryGiveUpTrackRequest];
    };
    [alert show];
}

- (void)getMainData {
    [self.crmService getClueActionListDataRequestWithComplete:^{
        self.tableHeaderView.crmModel = self.crmService.crmModel;
        self.btmView.convertCRMBtn.selected = self.crmService.crmModel.clientStatus == 2;
        self.btmView.convertCRMBtn.userInteractionEnabled = self.crmService.crmModel.clientStatus != 2;
        self.btmView.convertCRMBtn.btnBorderColor(self.crmService.crmModel.clientStatus == 2 ? kColorThemea4abb3 : kColorTheme21a8ff);
        [self.tableView reloadData];
        if ([self.tableView.mj_header isRefreshing]) {
            [self.tableView.mj_header endRefreshing];
        }
        if ([self.tableView.mj_footer isRefreshing]) {
            [self.tableView.mj_footer endRefreshing];
        }
        [QHWRefreshManager.sharedInstance endRefreshWithScrollView:self.tableView PageModel:self.crmService.itemPageModel];
        [self.tableView showNodataView:self.crmService.advisoryArray.count == 0 offsetY:180 button:nil];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.crmService.advisoryArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CRMAdvisoryModel *model = self.crmService.advisoryArray[indexPath.row];
    return model.advisoryHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CRMAdvisoryModel *model = self.crmService.advisoryArray[indexPath.row];
    CRMTrackCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(CRMTrackCell.class)];
    cell.titleLabel.text = model.title1;
    cell.timeLabel.text = model.createTime;
    cell.contentLabel.text = model.title2;
    cell.topLine.hidden = indexPath.row == 0;
    return cell;
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
        _tableView = [UICreateView initWithFrame:CGRectMake(0, kTopBarHeight, kScreenW, kScreenH-kTopBarHeight-kBottomDangerHeight-75) Style:UITableViewStylePlain Object:self];
        _tableView.tableHeaderView = self.tableHeaderView;
        [_tableView registerClass:CRMTrackCell.class forCellReuseIdentifier:NSStringFromClass(CRMTrackCell.class)];
        [QHWRefreshManager.sharedInstance normalHeaderWithScrollView:_tableView RefreshBlock:^{
            self.crmService.itemPageModel.pagination.currentPage = 1;
            [self getMainData];
        }];
        [QHWRefreshManager.sharedInstance normalFooterWithScrollView:_tableView RefreshBlock:^{
            self.crmService.itemPageModel.pagination.currentPage++;
            [self getMainData];
        }];
        [self.view addSubview:_tableView];
        [self.view sendSubviewToBack:_tableView];
    }
    return _tableView;
}

- (AdvisoryDetailHeaderView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[AdvisoryDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 180)];
    }
    return _tableHeaderView;
}

- (AdvisoryDetailBottomView *)btmView {
    if (!_btmView) {
        _btmView = [[AdvisoryDetailBottomView alloc] initWithFrame:CGRectMake(0, kScreenH-kBottomDangerHeight-75, kScreenW, 75)];
        _btmView.customerId = self.customerId;
        WEAKSELF
        _btmView.clickLeftBtnBlock = ^{
            [CTMediator.sharedInstance CTMediator_viewControllerForAddCustomerWithCustomerId:@"" RealName:weakSelf.crmService.crmModel.realName MobilePhone:weakSelf.crmService.crmModel.mobileNumber];
        };
        _btmView.clickRightBtnBlock = ^{
            kCallTel(weakSelf.crmService.crmModel.mobileNumber);
        };
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

@implementation AdvisoryDetailBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.convertCRMBtn = UIButton.btnFrame(CGRectMake(15, 15, 125, 45)).btnTitle(@"转到客户").btnFont(kFontTheme18).btnTitleColor(kColorTheme21a8ff).btnBorderColor(kColorTheme21a8ff).btnCornerRadius(5).btnAction(self, @selector(clickConvertCRMBtn));
        [self.convertCRMBtn setTitle:@"已转客户" forState:UIControlStateSelected];
        [self.convertCRMBtn setTitleColor:kColorThemea4abb3 forState:UIControlStateSelected];
        [self addSubview:self.convertCRMBtn];
                
        self.contactBtn = UIButton.btnFrame(CGRectMake(self.convertCRMBtn.right+15, 15, kScreenW-170, 45)).btnTitle(@"联系客户").btnFont(kFontTheme18).btnTitleColor(kColorThemefff).btnBkgColor(kColorTheme21a8ff).btnCornerRadius(5).btnAction(self, @selector(clickContactBtn));
        [self addSubview:self.contactBtn];
        
        [self addSubview:UIView.viewFrame(CGRectMake(0, 0, kScreenW, 0.5)).bkgColor(kColorThemeeee)];
    }
    return self;
}

- (void)clickConvertCRMBtn {
    if (self.clickLeftBtnBlock) {
        self.clickLeftBtnBlock();
    }
}

- (void)clickContactBtn {
    if (self.clickRightBtnBlock) {
        self.clickRightBtnBlock();
    }
}

@end
