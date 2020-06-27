//
//  LiveOrganizerViewController.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/6/11.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "LiveOrganizerViewController.h"
#import "MainBusinessDetailBottomView.h"
#import "QHWBaseCellProtocol.h"
#import "ActivityDetailViewController.h"

@interface LiveOrganizerViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) MainBusinessDetailBottomView *bottomView;

@end

@implementation LiveOrganizerViewController

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationReloadRichText object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.bottomView];
    for (QHWBaseModel *baseModel in self.service.tableViewDataArray) {
        [self.tableView registerClass:NSClassFromString(baseModel.identifier) forCellReuseIdentifier:baseModel.identifier];
    }
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(reloadRichTextCellNotification:) name:kNotificationReloadRichText object:nil];
}

- (void)addTableView {
    self.tableView = [UICreateView initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - kTopBarHeight - kBottomDangerHeight - self.bottomView.height - 40 - 200) Style:UITableViewStyleGrouped Object:self];
    [self.tableView registerClass:ActivityDetailSectionHeaderView.class forHeaderFooterViewReuseIdentifier:NSStringFromClass(ActivityDetailSectionHeaderView.class)];
    [self.view addSubview:self.tableView];
}

#pragma mark ------------Notification-------------
- (void)reloadRichTextCellNotification:(NSNotification *)notification {
    NSDictionary *dic = notification.object;
    NSString *identifier = dic[@"identifier"];
    [self.service.tableViewDataArray enumerateObjectsUsingBlock:^(QHWBaseModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
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
    return self.service.tableViewDataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    QHWBaseModel *baseModel = self.service.tableViewDataArray[indexPath.section];
    return baseModel.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QHWBaseModel *model = self.service.tableViewDataArray[indexPath.section];
    UITableViewCell<QHWBaseCellProtocol> *cell = [tableView dequeueReusableCellWithIdentifier:model.identifier];
    [cell configCellData:model.data];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    QHWBaseModel *model = self.service.tableViewDataArray[section];
    if (model.headerTitle.length > 0) {
        return 65;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    QHWBaseModel *model = self.service.tableViewDataArray[section];
    if (model.headerTitle.length > 0) {
        ActivityDetailSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(ActivityDetailSectionHeaderView.class)];
        headerView.titleLabel.text = model.headerTitle;
        return headerView;
    }
    return UIView.new;
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

- (MainBusinessDetailBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[MainBusinessDetailBottomView alloc] initWithFrame:CGRectMake(0, kScreenH-kTopBarHeight-200-40-kBottomDangerHeight-75, kScreenW, 75)];
        _bottomView.businessType = 103001;
        _bottomView.detailModel = self.service.liveDetailModel;
        _bottomView.onlineButton.enabled = YES;
        [_bottomView.onlineButton setTitle:@"报名" forState:0];
        _bottomView.onlineButton.backgroundColor = kColorTheme3cb584;
    }
    return _bottomView;
}

@end
