//
//  DistributionScrollContentViewController.m
//  Laike
//
//  Created by xiaobu on 2020/9/14.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "DistributionScrollContentViewController.h"
#import "QHWBaseCellProtocol.h"
#import "HomeService.h"
#import "MainBusinessService.h"
#import "QHWSystemService.h"
#import "CTMediator+ViewController.h"
#import "QHWFilterView.h"
#import "QHWCountryFilterView.h"

@interface DistributionScrollContentViewController () <UITableViewDelegate, UITableViewDataSource>

//@property (nonatomic, strong) HomeService *service;
@property (nonatomic, strong) MainBusinessTypeHeaderView *mainBusinessTypeHeaderView;//headerview

@property (nonatomic, strong) MainBusinessService *service;
@property (nonatomic, strong) QHWSystemService *bannerService;
@property (nonatomic, strong) dispatch_group_t group;

@end


@implementation DistributionScrollContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.group = dispatch_group_create();
    [self getMainBusinessDataRequest];
}

- (void)addTableView {
    CGFloat height = kScreenH-kBottomBarHeight-kTopBarHeight-138;
    self.tableView = [UICreateView initWithFrame:CGRectMake(0, 0, kScreenW, height) Style:UITableViewStylePlain Object:self];
    [self.tableView registerClass:MainBusinessTypeHeaderView.class forHeaderFooterViewReuseIdentifier:NSStringFromClass(MainBusinessTypeHeaderView.class)];
    [self.view addSubview:self.tableView];
    [QHWRefreshManager.sharedInstance normalHeaderWithScrollView:self.tableView RefreshBlock:^{
        [self getListDataWithFirstPage];
    }];
    [QHWRefreshManager.sharedInstance normalFooterWithScrollView:self.tableView RefreshBlock:^{
        self.service.itemPageModel.pagination.currentPage++;
        [self getMainBusinessListDataRequest];
    }];
}

- (void)getMainBusinessDataRequest {
    if (self.businessType == 1 || self.businessType == 3) {
        [self getFilterCountryDataRequest];
        [self getMainBusinessFilterDataRequest];
    }
    [self getMainBusinessListDataRequest];
    [self handleResult];
}

- (void)handleResult {
    dispatch_group_notify(self.group, dispatch_get_main_queue(), ^{
        for (QHWBaseModel *baseModel in self.service.tableViewDataArray) {
            [self.tableView registerClass:NSClassFromString(baseModel.identifier) forCellReuseIdentifier:baseModel.identifier];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
        [self.tableView showNodataView:self.service.tableViewDataArray.count == 0 offsetY:0 Text:@"即将上线"];
        [QHWRefreshManager.sharedInstance endRefreshWithScrollView:self.tableView PageModel:self.service.itemPageModel];
    });
}

- (void)getFilterCountryDataRequest {
    dispatch_group_enter(self.group);
    [self.service getFilterCountryRequest:^ {
        dispatch_group_leave(self.group);
    }];
}

- (void)getMainBusinessFilterDataRequest {
    dispatch_group_enter(self.group);
    [self.service getListFilterDataRequest:^ {
        dispatch_group_leave(self.group);
    }];
}

- (void)getMainBusinessListDataRequest {
    dispatch_group_enter(self.group);
    [self.service getDistributionListRequestWithIdentifier:self.identifier Complete:^{
        dispatch_group_leave(self.group);
        [self.tableView.mj_header endRefreshing];
        [self handleResult];
    }];
}

#pragma mark ------------UITableViewDelegate-------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.service.tableViewDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    QHWBaseModel *baseModel = self.service.tableViewDataArray[indexPath.row];
    return baseModel.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.service.tableViewDataArray.count) {
        QHWBaseModel *baseModel = self.service.tableViewDataArray[indexPath.row];
        UITableViewCell<QHWBaseCellProtocol> *cell = [tableView dequeueReusableCellWithIdentifier:baseModel.identifier];
        [cell configCellData:baseModel.data];
        return cell;
    }
    return UITableViewCell.new;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.service.tableViewDataArray.count) {
        NSArray *array = (NSArray *)self.service.tableViewDataArray[indexPath.row].data;
        QHWMainBusinessDetailBaseModel *baseModel = (QHWMainBusinessDetailBaseModel *)array.firstObject;
        for (NSDictionary *dic in self.service.tableViewCellArray) {
            if ([self.identifier isEqualToString:dic[@"identifier"]]) {
                [CTMediator.sharedInstance CTMediator_viewControllerForMainBusinessDetailWithBusinessType:[dic[@"businessType"] integerValue] BusinessId:baseModel.id];
                break;
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.service.filterArray.count > 0 ? 40 : CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.service.filterArray.count > 0) {
        self.mainBusinessTypeHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(MainBusinessTypeHeaderView.class)];
        self.mainBusinessTypeHeaderView.filterBtnView.dataArray = self.service.filterArray;
        WEAKSELF
        self.mainBusinessTypeHeaderView.filterBtnView.didSelectItemBlock = ^(FilterBtnViewCellModel * _Nonnull model) {
            [weakSelf handleTypeHeaderViewDidSelectItemWithModel:model];
        };
        return self.mainBusinessTypeHeaderView;
    }
    return UIView.new;
}

#pragma mark ------------houseTypeHeaderView-------------
- (void)handleTypeHeaderViewDidSelectItemWithModel:(FilterBtnViewCellModel *)model {
    __weak typeof(model) wModel = model;
    WEAKSELF
    QHWFilterModel *tempFilterModel = model.dataArray.firstObject;
    if ([tempFilterModel.key isEqualToString:@"countryId"]) {
        QHWCountryFilterView *filterView = [[QHWCountryFilterView alloc] initWithFrame:CGRectMake(0, kTopBarHeight+178, kScreenW, MIN(model.dataArray.firstObject.content.count*40, 280))];
        filterView.isTreatment = [self.identifier isEqualToString:@"treatment"];
        filterView.dataArray = model.dataArray.firstObject.content;
        filterView.didSelectedBlock = ^(FilterCellModel * _Nonnull countryCellModel, FilterCellModel * _Nonnull cityCellModel) {
            wModel.color = kColorThemefb4d56;
            if (cityCellModel.code.length == 0) {
                wModel.name = countryCellModel.name;
                if ([weakSelf.service.conditionDic.allKeys containsObject:cityCellModel.valueStr]) {
                    [weakSelf.service.conditionDic removeObjectForKey:cityCellModel.valueStr];
                }
                if (countryCellModel.code.length == 0) {
                    if ([weakSelf.service.conditionDic.allKeys containsObject:countryCellModel.valueStr]) {
                        [weakSelf.service.conditionDic removeObjectForKey:countryCellModel.valueStr];
                    }
                } else {
                    weakSelf.service.conditionDic[countryCellModel.valueStr] = countryCellModel.code;
                }
            } else {
                wModel.name = cityCellModel.name;
                weakSelf.service.conditionDic[cityCellModel.valueStr] = cityCellModel.code;
                weakSelf.service.conditionDic[countryCellModel.valueStr] = countryCellModel.code;
            }
            weakSelf.mainBusinessTypeHeaderView.filterBtnView.dataArray = weakSelf.service.filterArray;
            [weakSelf getListDataWithFirstPage];
        };
        [filterView show];
    } else {
        CGFloat height = 70+model.dataArray.count*60;
        for (QHWFilterModel *filterModel in model.dataArray) {
            NSInteger row = ceil(filterModel.content.count/4.0);
            height += 30*row + 10*(row-1);
        }
        QHWFilterView *filterView = [[QHWFilterView alloc] initWithFrame:CGRectMake(0, kTopBarHeight+178, kScreenW, MIN(height, kScreenH-kTopBarHeight-178))];
        filterView.dataArray = model.dataArray;
        filterView.clickResetBlock = ^{
            wModel.name = wModel.btnTitleName;
            wModel.color = kColorTheme2a303c;
            weakSelf.mainBusinessTypeHeaderView.filterBtnView.dataArray = weakSelf.service.filterArray;
            [weakSelf getListDataWithFirstPage];
        };
        filterView.clickConfirmBlock = ^{
            NSString *btnTitle = wModel.btnTitleName;
            if (![wModel.name isEqualToString:@"更多筛选"]) {
                for (QHWFilterModel *filterModel in wModel.dataArray) {
                    FilterCellModel *tempModel = nil;
                    for (FilterCellModel *model in filterModel.content) {
                        if (model.selected) {
                            tempModel = model;
                            break;
                        }
                    }
                    if (tempModel) {
                        btnTitle = tempModel.name;
                    }
                }
                wModel.name = btnTitle;
                wModel.color = kColorThemefb4d56;
                weakSelf.mainBusinessTypeHeaderView.filterBtnView.dataArray = weakSelf.service.filterArray;
            }
            [weakSelf getListDataWithFirstPage];
        };
        [filterView show];
    }
}

- (void)getListDataWithFirstPage {
    self.service.itemPageModel.pagination.currentPage = 1;
    [self getMainBusinessListDataRequest];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (MainBusinessService *)service {
    if (!_service) {
        _service = MainBusinessService.new;
        _service.businessType = self.businessType;
    }
    return _service;
}

- (QHWSystemService *)bannerService {
    if (!_bannerService) {
        _bannerService = QHWSystemService.new;
    }
    return _bannerService;
}

@end

@implementation MainBusinessTypeHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = kColorThemefff;
    }
    return self;
}

- (MainBusinessFilterBtnView *)filterBtnView {
    if (!_filterBtnView) {
        _filterBtnView = [[MainBusinessFilterBtnView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
        [self addSubview:_filterBtnView];
        [self addSubview:UIView.viewFrame(CGRectMake(0, 39.5, kScreenW, 0.5)).bkgColor(kColorThemeeee)];
    }
    return _filterBtnView;
}

@end
