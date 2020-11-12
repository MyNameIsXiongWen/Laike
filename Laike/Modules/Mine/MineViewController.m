//
//  MineViewController.m
//  Laike
//
//  Created by xiaobu on 2020/6/22.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "MineViewController.h"
#import "MineTableHeaderView.h"
#import "QHWGeneralTableViewCell.h"
#import "MineService.h"
#import "WalletService.h"
#import "CTMediator+ViewController.h"
#import "CancelBindCompanyViewController.h"
#import "SigninView.h"

@interface MineViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MineTableHeaderView *tableHeaderView;
@property (nonatomic, strong) UIImageView *signinImageView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) MineService *service;
@property (nonatomic, strong) WalletService *walletService;

@end

@implementation MineViewController

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationBindSuccess object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.signinImageView];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(getMineInfoRequest) name:kNotificationBindSuccess object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.kNavigationView.hidden = YES;
    [self getMineInfoRequest];
    [self getWalletInfoRequest];
}

- (void)getMineInfoRequest {
    [self.service getMineInfoRequestComplete:^{
        self.tableHeaderView.userModel = self.service.userModel;
    }];
}

- (void)getWalletInfoRequest {
    [self.walletService getWalletInfoRequestWithComplete:^(NSDictionary * _Nullable dataDic) {
        if (dataDic) {
            self.tableHeaderView.userDataArray = @[@{@"title": @"今日收益", @"value": kFormat(@"%.2f", [dataDic[@"dayMoney"] floatValue]/100.0)},
                                                   @{@"title": @"总收益", @"value": kFormat(@"%.2f", [dataDic[@"totalMoney"] floatValue]/100.0)},
                                                   @{@"title": @"可提现", @"value": kFormat(@"%.2f", [dataDic[@"balance"] floatValue]/100.0)}];
            NSInteger status = [dataDic[@"checkStatus"] integerValue];//签到状态：1-未签到；2-已签到
            self.signinImageView.hidden = status == 2;
        }
    }];
}

- (void)clickSignin {
    [self.walletService signinRequestWithComplete:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self getWalletInfoRequest];
        });
        self.signinImageView.hidden = YES;
    }];
}

#pragma mark ------------UITableViewDelegate-------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QHWGeneralTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(QHWGeneralTableViewCell.class)];
    [cell updateLeftImageViewConstraint:26];
    NSDictionary *dic = self.dataArray[indexPath.row];
    cell.leftImageView.image = kImageMake(dic[@"image"]);
    cell.titleLabel.text = dic[@"name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataArray[indexPath.row];
    [CTMediator.sharedInstance performTarget:self action:kFormat(@"click_%@", dic[@"identifier"]) params:nil];
}

- (void)click_school {
    [CTMediator.sharedInstance CTMediator_viewControllerForQSchool];
}

- (void)click_service {
//    [self.navigationController pushViewController:NSClassFromString(@"MyServiceViewController").new animated:YES];
    [CTMediator.sharedInstance CTMediator_viewControllerForChatWithConversationId:nil ReceiverNickName:nil ReceiverHeadPath:nil];
}

- (void)click_feedback {
    [self.navigationController pushViewController:NSClassFromString(@"FeedbackViewController").new animated:YES];
}

- (void)click_company {
    if (self.service.userModel.bindStatus == 1) {
        CancelBindCompanyViewController *vc = CancelBindCompanyViewController.new;
        vc.companyName = self.service.userModel.companyName;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [CTMediator.sharedInstance CTMediator_viewControllerForBindCompany];
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
        _tableView = [UICreateView initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-kBottomBarHeight) Style:UITableViewStylePlain Object:self];
        _tableView.rowHeight = 60;
        _tableView.backgroundColor = kColorThemef5f5f5;
        _tableView.tableHeaderView = self.tableHeaderView;
        [_tableView registerClass:QHWGeneralTableViewCell.class forCellReuseIdentifier:NSStringFromClass(QHWGeneralTableViewCell.class)];
    }
    return _tableView;
}

- (MineTableHeaderView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[MineTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 265)];
        _tableHeaderView.userModel = UserModel.shareUser;
    }
    return _tableHeaderView;
}

- (UIImageView *)signinImageView {
    if (!_signinImageView) {
        _signinImageView = UIImageView.ivFrame(CGRectMake(kScreenW-100, kScreenH-kBottomBarHeight-150, 100, 80)).ivImage(kImageMake(@"signin")).ivAction(self, @selector(clickSignin));
        _signinImageView.hidden = YES;
    }
    return _signinImageView;
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[@{@"image": @"mine_customize", @"identifier": @"school", @"name": @"我的大学"},
                       @{@"image": @"mine_service", @"identifier": @"service", @"name": @"在线客服"},
                       @{@"image": @"mine_feedback", @"identifier": @"feedback", @"name": @"问题反馈"},
                       @{@"image": @"mine_expert", @"identifier": @"company", @"name": @"绑定/解绑公司"}];
    }
    return _dataArray;
}

- (MineService *)service {
    if (!_service) {
        _service = MineService.new;
    }
    return _service;
}

- (WalletService *)walletService {
    if (!_walletService) {
        _walletService = WalletService.new;
    }
    return _walletService;
}

@end
