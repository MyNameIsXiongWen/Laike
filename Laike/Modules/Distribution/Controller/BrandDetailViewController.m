//
//  BrandDetailViewController.m
//  Laike
//
//  Created by xiaobu on 2020/9/24.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "BrandDetailViewController.h"
#import "BrandService.h"
#import "CTMediator+ViewController.h"
#import "QHWMainBusinessDetailBaseModel.h"
#import "MainBusinessDetailViewController.h"

@interface BrandDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) BrandService *service;

@end

@implementation BrandDetailViewController

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationReloadRichText object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(reloadRichTextCellNotification:) name:kNotificationReloadRichText object:nil];
    self.kNavigationView.title = @"品牌馆";
    [self getBrandDetailRequest];
}

- (void)getBrandDetailRequest {
    [self.service getBrandDetailRequestComplete:^{
        [self.tableView reloadData];
    }];
    [self.service getBrandProductListRequestComplete:^{
        [self.tableView reloadData];
    }];
}

#pragma mark ------------Notification-------------
- (void)reloadRichTextCellNotification:(NSNotification *)notification {
    NSDictionary *dic = notification.object;
    NSString *identifier = dic[@"identifier"];
    [self.service.tableViewDataArray enumerateObjectsUsingBlock:^(QHWBaseModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *array = (NSArray *)model.data;
        for (int i=0; i<array.count; i++) {
            id object = array[i];
            if ([object isKindOfClass:NSDictionary.class]) {
                NSDictionary *subDic = (NSDictionary *)object;
                if ([identifier isEqualToString:subDic[@"identifier"]]) {
                    model.height = [dic[@"height"] floatValue];
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:idx]] withRowAnimation:UITableViewRowAnimationNone];
                    *stop = YES;
                }
            }
        }
    }];
}

#pragma mark ------------UITableViewDelegate-------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.service.tableViewDataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    QHWBaseModel *baseModel = self.service.tableViewDataArray[section];
    NSArray *array = (NSArray *)baseModel.data;
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    QHWBaseModel *baseModel = self.service.tableViewDataArray[indexPath.section];
    id object = baseModel.data[indexPath.row];
    if ([object isKindOfClass:QHWBaseModel.class]) {
        QHWBaseModel *subBaseModel = (QHWBaseModel *)object;
        return subBaseModel.height;
    }
    return baseModel.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QHWBaseModel *model = self.service.tableViewDataArray[indexPath.section];
    UITableViewCell<QHWBaseCellProtocol> *cell = [tableView dequeueReusableCellWithIdentifier:model.identifier];
    [cell configCellData:model.data[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    QHWBaseModel *baseModel = self.service.tableViewDataArray[section];
    return baseModel.headerTitle ? 55 : CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    QHWBaseModel *baseModel = self.service.tableViewDataArray[section];
    if (baseModel.headerTitle) {
        MainBusinessDetailSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(MainBusinessDetailSectionHeaderView.class)];
        headerView.titleLabel.text = baseModel.headerTitle;
        headerView.moreBtn.hidden = !baseModel.showMoreBtn;
        return headerView;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QHWBaseModel *baseModel = self.service.tableViewDataArray[indexPath.section];
    NSArray *array = (NSArray *)baseModel.data;
    if (indexPath.row < array.count) {
        [CTMediator.sharedInstance performTarget:self action:[NSString stringWithFormat:@"click%@:", baseModel.identifier] params:@{@"indexPath": indexPath}];
    }
}

- (void)clickQHWMainBusinessTableViewCell:(NSDictionary *)params {
    NSIndexPath *indexPath = params[@"indexPath"];
    QHWBaseModel *baseModel = self.service.tableViewDataArray[indexPath.section];
    NSArray *array = (NSArray *)baseModel.data;
    QHWMainBusinessDetailBaseModel *model = array[indexPath.row];
    [CTMediator.sharedInstance CTMediator_viewControllerForMainBusinessDetailWithBusinessType:model.businessType BusinessId:model.id];
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
        for (NSString *cellIdentifier in self.service.tableViewCellArray) {
            [_tableView registerClass:NSClassFromString(cellIdentifier) forCellReuseIdentifier:cellIdentifier];
        }
        [_tableView registerClass:MainBusinessDetailSectionHeaderView.class forHeaderFooterViewReuseIdentifier:NSStringFromClass(MainBusinessDetailSectionHeaderView.class)];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (BrandService *)service {
    if (!_service) {
        _service = BrandService.new;
        _service.brandId = self.brandId;
    }
    return _service;
}

@end
