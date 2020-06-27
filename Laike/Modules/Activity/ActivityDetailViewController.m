//
//  ActivityDetailViewController.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/30.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "ArtivityDetailTableHeaderView.h"
#import "MainBusinessDetailBottomView.h"
#import "QHWSystemService.h"
#import "QHWBaseCellProtocol.h"
//#import "QHWShareView.h"

@interface ActivityDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ArtivityDetailTableHeaderView *tableHeaderView;
@property (nonatomic, strong) MainBusinessDetailBottomView *bottomView;
@property (nonatomic, strong) QHWSystemService *activityService;

@end

@implementation ActivityDetailViewController

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationReloadRichText object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.kNavigationView.rightBtn setImage:kImageMake(@"global_share") forState:0];
    [self getDetailInfoRequest];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(reloadRichTextCellNotification:) name:kNotificationReloadRichText object:nil];
}

- (void)rightNavBtnAction:(UIButton *)sender {
//    QHWShareView *shareView = [[QHWShareView alloc] initWithFrame:CGRectMake(0, kScreenH, kScreenW, 220) dict:@{@"detailModel":self.activityService.activityDetailModel, @"shareType": @(ShareTypeMainBusiness)}];
//    [shareView show];
}

- (void)getDetailInfoRequest {
    [self.activityService getActivityDetailInfoRequestWithActivityId:self.activityId Complete:^(BOOL status) {
        if (status) {
            for (QHWBaseModel *baseModel in self.activityService.tableViewDataArray) {
                [self.tableView registerClass:NSClassFromString(baseModel.identifier) forCellReuseIdentifier:baseModel.identifier];
            }
            self.kNavigationView.title = self.activityService.activityDetailModel.name;
            self.tableHeaderView.activityModel = self.activityService.activityDetailModel;
            self.tableHeaderView.height = self.activityService.activityDetailHeaderHeight;
            self.bottomView.businessType = 17;
            self.bottomView.detailModel = self.activityService.activityDetailModel;
            if (self.activityService.activityDetailModel.entryStatus == 1) {
                self.bottomView.onlineButton.enabled = YES;
                [self.bottomView.onlineButton setTitle:@"报名" forState:0];
                self.bottomView.onlineButton.backgroundColor = kColorTheme3cb584;
            } else {
                self.bottomView.onlineButton.enabled = NO;
                [self.bottomView.onlineButton setTitle:@"已结束" forState:0];
                self.bottomView.onlineButton.backgroundColor = kColorThemeeee;
                [self.bottomView.onlineButton setTitleColor:kColorThemea4abb3 forState:0];
            }
            [self.tableView reloadData];
        }
    }];
}

#pragma mark ------------Notification-------------
- (void)reloadRichTextCellNotification:(NSNotification *)notification {
    NSDictionary *dic = notification.object;
    NSString *identifier = dic[@"identifier"];
    [self.activityService.tableViewDataArray enumerateObjectsUsingBlock:^(QHWBaseModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([model.data isKindOfClass:NSDictionary.class]) {
            NSDictionary *subDic = (NSDictionary *)model.data;
            if ([identifier isEqualToString:subDic[@"identifier"]]) {
                model.height = [dic[@"height"] floatValue];
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:idx]] withRowAnimation:UITableViewRowAnimationNone];
                *stop = YES;
            }
        }
    }];
}

#pragma mark ------------UITableViewDelegate-------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.activityService.tableViewDataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    QHWBaseModel *baseModel = self.activityService.tableViewDataArray[indexPath.section];
    return baseModel.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QHWBaseModel *model = self.activityService.tableViewDataArray[indexPath.section];
    UITableViewCell<QHWBaseCellProtocol> *cell = [tableView dequeueReusableCellWithIdentifier:model.identifier];
    [cell configCellData:model.data];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 65;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    QHWBaseModel *baseModel = self.activityService.tableViewDataArray[section];
    ActivityDetailSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(ActivityDetailSectionHeaderView.class)];
    headerView.titleLabel.text = baseModel.headerTitle;
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return UIView.new;
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
        _tableView = [UICreateView initWithFrame:CGRectMake(0, kTopBarHeight, kScreenW, kScreenH - kTopBarHeight - kBottomDangerHeight - self.bottomView.height) Style:UITableViewStyleGrouped Object:self];
        _tableView.showsVerticalScrollIndicator = YES;
        _tableView.tableHeaderView = self.tableHeaderView;
        [_tableView registerClass:ActivityDetailSectionHeaderView.class forHeaderFooterViewReuseIdentifier:NSStringFromClass(ActivityDetailSectionHeaderView.class)];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (ArtivityDetailTableHeaderView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[ArtivityDetailTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 300)];
    }
    return _tableHeaderView;
}

- (MainBusinessDetailBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[MainBusinessDetailBottomView alloc] initWithFrame:CGRectMake(0, kScreenH-kBottomDangerHeight-75, kScreenW, 75)];
        [self.view addSubview:_bottomView];
    }
    return _bottomView;
}

- (QHWSystemService *)activityService {
    if (!_activityService) {
        _activityService = QHWSystemService.new;
    }
    return _activityService;
}

@end

@implementation ActivityDetailSectionHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithReuseIdentifier:reuseIdentifier]) {
        self.titleLabel = UILabel.labelFrame(CGRectMake(15, 0, 200, 65)).labelFont(kMediumFontTheme18).labelTitleColor(kColorTheme2a303c);
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

@end
