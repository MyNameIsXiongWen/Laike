//
//  HomeTableHeaderView.m
//  Laike
//
//  Created by xiaobu on 2020/6/22.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "HomeTableHeaderView.h"
#import "CTMediator+ViewController.h"
#import "UserModel.h"
#import "SearchBkgView.h"
#import "AppDelegate.h"

@interface HomeTableHeaderView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) SearchBkgView *searchBkgView;
@property (nonatomic, strong) UserInfoView *userInfoView;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HomeTableHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.whiteColor;
        [self addSubview:self.searchBkgView];
        [self addSubview:self.tableView];
    }
    return self;
}

- (void)setService:(HomeService *)service {
    _service = service;
    for (QHWBaseModel *baseModel in self.service.tableViewDataArray) {
        [_tableView registerClass:NSClassFromString(baseModel.identifier) forCellReuseIdentifier:baseModel.identifier];
    }
//    self.userInfoView.nameLabel.text = service.homeModel.realName;
//    self.userInfoView.companyLabel.text = service.homeModel.companyName;
//    [self.userInfoView.avatarImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(service.homeModel.headPath)]];
    self.tableView.height = service.headerViewTableHeight-10-32-15;
    [self.tableView reloadData];
}

#pragma mark ------------UITableViewDelegate-------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.service.tableViewDataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    QHWBaseModel *model = self.service.tableViewDataArray[indexPath.section];
    return model.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QHWBaseModel *model = self.service.tableViewDataArray[indexPath.section];
    UITableViewCell <QHWBaseCellProtocol>*cell = [tableView dequeueReusableCellWithIdentifier:model.identifier];
    [cell configCellData:model.data];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QHWBaseModel *model = self.service.tableViewDataArray[indexPath.section];
    [CTMediator.sharedInstance performTarget:self action:kFormat(@"click%@", model.identifier) params:nil];
}

- (void)clickHomeDynamicTableViewCell {
    AppDelegate *delegate = (AppDelegate *)UIApplication.sharedApplication.delegate;
    delegate.tabBarVC.selectedIndex = 2;
}

- (void)clickHomePopularityInfoTableViewCell {
    [self.getCurrentMethodCallerVC.navigationController pushViewController:NSClassFromString(@"RankViewController").new animated:YES];
}

- (void)clickHomeCardTableViewCell {
    [CTMediator.sharedInstance CTMediator_viewControllerForCard];
}

- (void)clickHomeCustomerTableViewCell {
    if (UserModel.shareUser.bindStatus == 2) {
        [CTMediator.sharedInstance CTMediator_viewControllerForBindCompany];
        return;
    }
    [CTMediator.sharedInstance CTMediator_viewControllerForIntervalCRM];
}

- (void)clickHomeSchoolTableViewCell {
    [CTMediator.sharedInstance CTMediator_viewControllerForQSchool];
}

#pragma mark ------------UI-------------
- (SearchBkgView *)searchBkgView {
    if (!_searchBkgView) {
        _searchBkgView = [[SearchBkgView alloc] initWithFrame:CGRectMake(0, 10, kScreenW, 32)];
        _searchBkgView.searchBgView.borderColor(kColorTheme21a8ff);
        _searchBkgView.placeholderLabel.text = @"输入市场热门商品";
        _searchBkgView.searchBtn.hidden = NO;
        WEAKSELF
        _searchBkgView.clickSearchBkgBlock = ^{
            [weakSelf.getCurrentMethodCallerVC.navigationController pushViewController:NSClassFromString(@"DistributionSearchViewController").new animated:YES];
        };
    }
    return _searchBkgView;
}

- (UserInfoView *)userInfoView {
    if (!_userInfoView) {
        _userInfoView = [[UserInfoView alloc] initWithFrame:CGRectMake(0, 60, kScreenW, 70)];
        [self addSubview:_userInfoView];
    }
    return _userInfoView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UICreateView initWithFrame:CGRectMake(0, self.searchBkgView.bottom+15, kScreenW, 0) Style:UITableViewStylePlain Object:self];
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.scrollEnabled = NO;
        
        UIView *footerView = UIView.viewFrame(CGRectMake(0, 0, kScreenW, 50));
        [footerView addSubview:UILabel.labelFrame(CGRectMake(15, 0, 200, 45)).labelFont(kMediumFontTheme24).labelTitleColor(kColorTheme2a303c).labelText(@"推广获客")];
        _tableView.tableFooterView = footerView;
        
        [self addSubview:_tableView];
    }
    return _tableView;
}

@end

#import "QHWShareView.h"
#import "UserModel.h"

@implementation UserInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.avatarImgView = UIImageView.ivFrame(CGRectMake(15, 0, self.height, self.height)).ivCornerRadius(self.height/2);
        [self addSubview:self.avatarImgView];
        
        self.nameLabel = UILabel.labelFrame(CGRectMake(self.avatarImgView.right+10, 5, kScreenW-200, 33)).labelTitleColor(kColorThemefff).labelFont(kMediumFontTheme24);
        [self addSubview:self.nameLabel];
        
        self.companyLabel = UILabel.labelFrame(CGRectMake(self.nameLabel.left, self.nameLabel.bottom, self.nameLabel.width, 17)).labelTitleColor(kColorThemefff).labelFont(kFontTheme14);
        [self addSubview:self.companyLabel];
        
        self.shareBtn = UIButton.btnFrame(CGRectMake(kScreenW-95, 25, 80, 20)).btnTitle(@"分享名片").btnTitleColor(kColorThemefff).btnFont(kFontTheme14).btnBkgColor([UIColor colorFromHexString:@"566586"]).btnCornerRadius(2).btnAction(self, @selector(clickShareBtn));
        [self addSubview:self.shareBtn];
    }
    return self;
}

- (void)clickShareBtn {
    QHWShareView *shareView = [[QHWShareView alloc] initWithFrame:CGRectMake(0, kScreenH, kScreenW, 220) dict:@{@"detailModel":UserModel.shareUser, @"shareType": @(ShareTypeConsultant)}];
    [shareView show];
}

@end
