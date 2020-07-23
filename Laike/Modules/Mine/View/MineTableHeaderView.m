//
//  MineTableHeaderView.m
//  Laike
//
//  Created by xiaobu on 2020/7/1.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "MineTableHeaderView.h"
#import "HomeTableHeaderView.h"

@interface MineTableHeaderView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIImageView *bkgView;
@property (nonatomic, strong) UserInfoView *userInfoView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *tableViewDataArray;

@end

@implementation MineTableHeaderView

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
        [self addSubview:self.userInfoView];
        [self addSubview:self.tableView];
    }
    return self;
}

- (void)setUserModel:(UserModel *)userModel {
    _userModel = userModel;
    
    self.userInfoView.nameLabel.text = userModel.realName;
    self.userInfoView.companyLabel.text = userModel.companyName;
    [self.userInfoView.avatarImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(userModel.headPath)]];
    
    [_tableView registerClass:NSClassFromString(@"MineDataTableViewCell") forCellReuseIdentifier:@"MineDataTableViewCell"];
    self.tableViewDataArray = @[[[QHWBaseModel alloc] configModelIdentifier:@"MineDataTableViewCell"
                                                                     Height:100
                                                                       Data:@[@{@"title": @"访问", @"value": @(userModel.visitCount)},
                                                                              @{@"title": @"线索", @"value": @(userModel.consultCount)},
                                                                              @{@"title": @"客户", @"value": @(userModel.crmCount)},
                                                                              @{@"title": @"报备客户", @"value": @(userModel.distributionCount)}]]];
    
    [self.tableView reloadData];
}

- (void)clickUserInfoView {
    [self.getCurrentMethodCallerVC.navigationController pushViewController:NSClassFromString(@"MineInfoViewController").new animated:YES];
}

#pragma mark ------------UITableViewDelegate-------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    QHWBaseModel *model = self.tableViewDataArray[indexPath.section];
    return model.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QHWBaseModel *model = self.tableViewDataArray[indexPath.section];
    UITableViewCell <QHWBaseCellProtocol>*cell = [tableView dequeueReusableCellWithIdentifier:model.identifier];
    [cell configCellData:model.data];
    return cell;
}

#pragma mark ------------UI-------------
- (UIView *)bkgView {
    if (!_bkgView) {
        _bkgView = UIImageView.ivFrame(CGRectMake(0, 0, kScreenW, 190));
        [_bkgView addSubview:UIImageView.ivFrame(_bkgView.bounds).ivImage(kImageMake(@"mine_bkg"))];
    }
    return _bkgView;
}

- (UserInfoView *)userInfoView {
    if (!_userInfoView) {
        _userInfoView = [[UserInfoView alloc] initWithFrame:CGRectMake(0, 60, kScreenW, 70)];
        _userInfoView.avatarImgView.userInteractionEnabled = YES;
        [_userInfoView.avatarImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickUserInfoView)]];
        [self addSubview:_userInfoView];
    }
    return _userInfoView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UICreateView initWithFrame:CGRectMake(0, 165, kScreenW, 100) Style:UITableViewStylePlain Object:self];
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.scrollEnabled = NO;
        [self addSubview:_tableView];
    }
    return _tableView;
}

- (NSArray *)tableViewDataArray {
    if (!_tableViewDataArray) {
        _tableViewDataArray = NSArray.array;
    }
    return _tableViewDataArray;
}

@end
