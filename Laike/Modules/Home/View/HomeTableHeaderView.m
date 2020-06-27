//
//  HomeTableHeaderView.m
//  Laike
//
//  Created by xiaobu on 2020/6/22.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "HomeTableHeaderView.h"
#import "CTMediator+ViewController.h"

@interface HomeTableHeaderView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIImageView *bkgView;
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
        [self addSubview:self.bkgView];
        [self addSubview:self.tableView];
    }
    return self;
}

- (void)setService:(HomeService *)service {
    _service = service;
    for (QHWBaseModel *baseModel in self.service.tableViewDataArray) {
        [_tableView registerClass:NSClassFromString(baseModel.identifier) forCellReuseIdentifier:baseModel.identifier];
    }
    self.userInfoView.nameLabel.text = service.homeModel.realName;
    self.userInfoView.companyLabel.text = service.homeModel.companyName;
    [self.userInfoView.avatarImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(service.homeModel.headPath)]];
    self.tableView.height = service.headerViewTableHeight-165;
    [self.tableView reloadData];
}

- (void)clickUserInfoView {
    [self.getCurrentMethodCallerVC.navigationController pushViewController:NSClassFromString(@"MineInfoViewController").new animated:YES];
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

- (void)clickMinePopularityInfoTableViewCell {
    [self.getCurrentMethodCallerVC.navigationController pushViewController:NSClassFromString(@"RankViewController").new animated:YES];
}

- (void)clickMineCardTableViewCell {
    [CTMediator.sharedInstance CTMediator_viewControllerForCard];
}

- (void)clickMineCustomerTableViewCell {
    [CTMediator.sharedInstance CTMediator_viewControllerForCRM];
}

- (void)clickMineSchoolTableViewCell {
    [CTMediator.sharedInstance CTMediator_viewControllerForQSchool];
}

#pragma mark ------------UI-------------
- (UIView *)bkgView {
    if (!_bkgView) {
        _bkgView = UIImageView.ivFrame(CGRectMake(0, 0, kScreenW, 190)).ivBkgColor(kColorFromHexString(@"bdb5b5"));
    }
    return _bkgView;
}

- (UserInfoView *)userInfoView {
    if (!_userInfoView) {
        _userInfoView = [[UserInfoView alloc] initWithFrame:CGRectMake(0, 60, kScreenW, 70)];
        _userInfoView.userInteractionEnabled = YES;
        [_userInfoView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickUserInfoView)]];
        [self addSubview:_userInfoView];
    }
    return _userInfoView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UICreateView initWithFrame:CGRectMake(0, 165, kScreenW, 0) Style:UITableViewStylePlain Object:self];
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.scrollEnabled = NO;
        [self addSubview:_tableView];
    }
    return _tableView;
}

@end

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
    
}

@end
