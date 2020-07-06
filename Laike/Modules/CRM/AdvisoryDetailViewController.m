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

@interface AdvisoryDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) AdvisoryDetailHeaderView *tableHeaderView;
@property (nonatomic, strong) AdvisoryDetailBottomView *btmView;
@property (nonatomic, strong) CRMService *crmService;

@end

@implementation AdvisoryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.kNavigationView.title = @"获客详情";
    [self.kNavigationView.rightBtn setImage:kImageMake(@"global_more") forState:0];
    [self.view addSubview:self.btmView];
}

- (void)rightNavBtnAction:(UIButton *)sender {
    QHWMoreView *moreView = [[QHWMoreView alloc] initWithFrame:CGRectMake(kScreenW-125, kTopBarHeight, 105, 85)
                                                     ViewArray:@[@{@"title":@"转到CRM", @"identifier":@"convertCRM"},
                                                                 @{@"title":@"放弃跟进", @"identifier":@"giveUpFollowUp"}]];
    WEAKSELF
    moreView.clickBtnBlock = ^(NSString * _Nonnull identifier) {
        if ([identifier isEqualToString:@"convertCRM"]) {
            [weakSelf showAlertLabelView];
        } else if ([identifier isEqualToString:@"giveUpFollowUp"]) {
            [weakSelf.crmService CRMGiveUpTrackRequest];
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
        [CTMediator.sharedInstance CTMediator_viewControllerForAddCustomerWithCustomerId:weakSelf.customerId];
    };
    [alert show];
}

- (void)getMainData {
    [self.crmService getClueActionAllListDataRequestWithComplete:^{
        self.kNavigationView.title = self.crmService.crmModel.realName;
        self.tableHeaderView.crmModel = self.crmService.crmModel;
        [self.tableView reloadData];
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
        _tableView = [UICreateView initWithRecognizeSimultaneouslyFrame:CGRectMake(0, kTopBarHeight, kScreenW, kScreenH-kTopBarHeight-kBottomDangerHeight-75) Style:UITableViewStylePlain Object:self];
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
            [CTMediator.sharedInstance CTMediator_viewControllerForAddCustomerWithCustomerId:weakSelf.customerId];
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
        self.convertCRMBtn = UIButton.btnFrame(CGRectMake(15, 15, 125, 45)).btnTitle(@"转到CRM").btnFont(kFontTheme18).btnTitleColor(kColorTheme21a8ff).btnBorderColor(kColorTheme21a8ff).btnCornerRadius(5).btnAction(self, @selector(clickConvertCRMBtn));
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
    
}

@end