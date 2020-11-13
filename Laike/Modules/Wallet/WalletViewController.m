//
//  WalletViewController.m
//  Laike
//
//  Created by xiaobu on 2020/11/3.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "WalletViewController.h"
#import "WalletService.h"

@interface WalletViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WallerHeaderView *headerView;
@property (nonatomic, strong) WalletService *service;

@end

@implementation WalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.kNavigationView.title = @"我的钱包";
    self.kNavigationView.rightBtn.frame = CGRectMake(kScreenW-90, kStatusBarHeight, 70, 44);
    self.kNavigationView.rightBtn.btnTitle(@"赚钱规则").btnFont(kFontTheme14);
    [self.view addSubview:self.tableView];
}

- (void)rightNavBtnAction:(UIButton *)sender {
    RuleView *ruleView = [[RuleView alloc] initWithFrame:CGRectMake(40, (kScreenH-370)/2, kScreenW-80, 370)];
    [ruleView show];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getWalletInfoRequest];
    [self getWalletListRequest];
}

- (void)getWalletInfoRequest {
    [self.service getWalletInfoRequestWithComplete:^(NSDictionary * _Nullable dataDic) {
        if (dataDic) {
            self.headerView.balanceLabel.text = kFormat(@"¥ %.2f", [dataDic[@"balance"] floatValue]/100.0);
            self.headerView.userDataView.dataArray = @[@{@"title": @"今日收益", @"value": kFormat(@"¥ %.2f", [dataDic[@"dayMoney"] floatValue]/100.0)},
                                                       @{@"title": @"总收益", @"value": kFormat(@"¥ %.2f", [dataDic[@"totalMoney"] floatValue]/100.0)},
                                                       @{@"title": @"可提现", @"value": kFormat(@"¥ %.2f", [dataDic[@"balance"] floatValue]/100.0)}];
            WEAKSELF
            self.headerView.clickWithdrawBlock = ^{
                [weakSelf.navigationController pushViewController:NSClassFromString(@"WithdrawViewController").new animated:YES];
            };
        }
    }];
}

- (void)getWalletListRequest {
    [self.service getWalletListRequestWithComplete:^{
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
        [self.tableView showNodataView:self.service.tableViewDataArray.count == 0 offsetY:200 button:nil];
        [QHWRefreshManager.sharedInstance endRefreshWithScrollView:self.tableView PageModel:self.service.itemPageModel];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.service.tableViewDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WalletTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(WalletTableViewCell.class)];
    WalletModel *model = (WalletModel *)self.service.tableViewDataArray[indexPath.row];
    cell.titleLabel.text = model.title;
    cell.subtitleLabel.text = model.subtitle;
    if (model.paymentStatus == 1) {
        cell.moneyLabel.text = kFormat(@"+ %.2f", model.transactionMoney.floatValue/100.0);
        cell.moneyLabel.textColor = kColorFromHexString(@"f85b5b");
    } else {
        cell.moneyLabel.text = kFormat(@"提现 %.2f", model.transactionMoney.floatValue/100.0);
        cell.moneyLabel.textColor = kColorTheme999;
    }
    cell.timeLabel.text = model.createTime;
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
        _tableView = [UICreateView initWithFrame:CGRectMake(0, kTopBarHeight, kScreenW, kScreenH-kTopBarHeight) Style:UITableViewStylePlain Object:self];
        _tableView.tableHeaderView = self.headerView;
        _tableView.rowHeight = 60;
        [_tableView registerClass:WalletTableViewCell.class forCellReuseIdentifier:NSStringFromClass(WalletTableViewCell.class)];
        [QHWRefreshManager.sharedInstance normalHeaderWithScrollView:_tableView RefreshBlock:^{
            self.service.itemPageModel.pagination.currentPage = 1;
            [self getWalletInfoRequest];
            [self getWalletListRequest];
        }];
        [QHWRefreshManager.sharedInstance normalFooterWithScrollView:_tableView RefreshBlock:^{
            self.service.itemPageModel.pagination.currentPage++;
            [self getWalletListRequest];
        }];
    }
    return _tableView;
}

- (WallerHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[WallerHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 215)];
    }
    return _headerView;
}

- (WalletService *)service {
    if (!_service) {
        _service = WalletService.new;
    }
    return _service;
}

@end

@implementation WallerHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self addSubview:self.bkgImgView];
        [self.bkgImgView addSubview:self.balanceLabel];
        [self.bkgImgView addSubview:self.balanceSubtitleLabel];
        [self.bkgImgView addSubview:self.withdrawBtn];
        [self.bkgImgView addSubview:self.userDataView];
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)clickWithdrawBtn {
    if (self.clickWithdrawBlock) {
        self.clickWithdrawBlock();
    }
}

- (UIImageView *)bkgImgView {
    if (!_bkgImgView) {
        _bkgImgView = UIImageView.ivFrame(CGRectMake(15, 15, kScreenW-30, 150)).ivBkgColor(kColorTheme21a8ff).ivCornerRadius(10);
        _bkgImgView.userInteractionEnabled = YES;
    }
    return _bkgImgView;
}

- (UILabel *)balanceLabel {
    if (!_balanceLabel) {
        _balanceLabel = UILabel.labelFrame(CGRectMake(0, 40, self.bkgImgView.width, 30)).labelFont(kFontTheme24).labelTitleColor(kColorThemefff).labelTextAlignment(NSTextAlignmentCenter);
    }
    return _balanceLabel;
}

- (UILabel *)balanceSubtitleLabel {
    if (!_balanceSubtitleLabel) {
        _balanceSubtitleLabel = UILabel.labelFrame(CGRectMake(0, self.balanceLabel.bottom+5, self.bkgImgView.width, 15)).labelText(@"账户余额").labelFont(kFontTheme12).labelTitleColor(kColorThemefff).labelTextAlignment(NSTextAlignmentCenter);
    }
    return _balanceSubtitleLabel;
}

- (UIButton *)withdrawBtn {
    if (!_withdrawBtn) {
        _withdrawBtn = UIButton.btnFrame(CGRectMake(self.bkgImgView.width-60, 20, 50, 24)).btnTitle(@"提现").btnFont(kFontTheme13).btnTitleColor(kColorThemefff).btnCornerRadius(4).btnBorderColor(kColorThemefff).btnBkgColor(UIColor.clearColor).btnAction(self, @selector(clickWithdrawBtn));
    }
    return _withdrawBtn;
}

- (UserDataView *)userDataView {
    if (!_userDataView) {
        _userDataView = [[UserDataView alloc] initWithFrame:CGRectMake(0, self.balanceSubtitleLabel.bottom+10, kScreenW-30, 35)];
        _userDataView.nameColor = kColorThemefff;
        _userDataView.countColor = kColorThemefff;
    }
    return _userDataView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.labelFrame(CGRectMake(15, self.bkgImgView.bottom+10, self.bkgImgView.width, 40)).labelText(@"明细").labelFont(kMediumFontTheme17);
    }
    return _titleLabel;
}

@end

@implementation WalletTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30);
            make.top.mas_equalTo(10);
        }];
        [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-30);
            make.top.mas_equalTo(10);
        }];
        [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30);
            make.bottom.mas_equalTo(-10);
        }];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-30);
            make.bottom.mas_equalTo(-10);
        }];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.5);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.bottom.mas_equalTo(0);
        }];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.labelInit().labelTitleColor(kColorTheme000).labelFont(kMediumFontTheme15);
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel {
    if (!_subtitleLabel) {
        _subtitleLabel = UILabel.labelInit().labelTitleColor(kColorTheme999).labelFont(kFontTheme14);
        [self.contentView addSubview:_subtitleLabel];
    }
    return _subtitleLabel;
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = UILabel.labelInit().labelFont(kFontTheme14);
        [self.contentView addSubview:_moneyLabel];
    }
    return _moneyLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = UILabel.labelInit().labelTitleColor(kColorTheme999).labelFont(kFontTheme14);
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}

- (UIView *)line {
    if (!_line) {
        _line = UIView.viewInit().bkgColor(kColorThemeeee);
        [self.contentView addSubview:_line];
    }
    return _line;
}

@end

@implementation RuleView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.popType = PopTypeCenter;
        UIButton *closeBtn = UIButton.btnFrame(CGRectMake(self.width-30, 10, 20, 20)).btnImage(kImageMake(@"publish_close")).btnAction(self, @selector(closeBtnAction));
        [self addSubview:closeBtn];
        
        UILabel *label1 = UILabel.labelFrame(CGRectMake(0, 40, self.width, 25)).labelText(@"赚钱规则").labelTextAlignment(NSTextAlignmentCenter).labelFont(kFontTheme20).labelTitleColor(kColorTheme666);
        [self addSubview:label1];
        
        UILabel *label2 = UILabel.labelFrame(CGRectMake(15, label1.bottom+20, self.width-30, 20)).labelText(@"1：注册即得30元").labelFont(kFontTheme15).labelTitleColor(kColorTheme999);
        [self addSubview:label2];
        
        UILabel *label3 = UILabel.labelFrame(CGRectMake(15, label2.bottom, self.width-30, 55)).labelText(@"2：转发产品、海外圈、获客软文、名片、活动召集、直播邀约页面，每1个用户阅读，得0.1元").labelFont(kFontTheme15).labelTitleColor(kColorTheme999).labelNumberOfLines(0);
        [label3 sizeToFit];
        [self addSubview:label3];
        
        UILabel *label4 = UILabel.labelFrame(CGRectMake(15, label3.bottom, self.width-30, 20)).labelText(@"3：每天签到1次，得0.2元").labelFont(kFontTheme15).labelTitleColor(kColorTheme999);
        [self addSubview:label4];
        
        UILabel *label5 = UILabel.labelFrame(CGRectMake(15, label4.bottom, self.width-30, 20)).labelText(@"4：分销成交可得万元佣金").labelFont(kFontTheme15).labelTitleColor(kColorTheme999);
        [self addSubview:label5];
        
        UILabel *label6 = UILabel.labelFrame(CGRectMake(15, label5.bottom, self.width-30, 20)).labelText(@"5：提现规则：50或50的整数倍").labelFont(kFontTheme15).labelTitleColor(kColorTheme999);
        [self addSubview:label6];
    }
    return self;
}

- (void)closeBtnAction {
    [self dismiss];
}

- (void)popView_cancel {
    
}

@end
