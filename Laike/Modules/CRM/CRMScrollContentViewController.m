//
//  CRMScrollContentViewController.m
//  Laike
//
//  Created by xiaobu on 2020/6/23.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "CRMScrollContentViewController.h"
#import "CRMTableViewCell.h"
#import "CRMService.h"
#import "MainBusinessFilterBtnView.h"
#import "QHWCountryFilterView.h"

@interface CRMScrollContentViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) MainBusinessFilterBtnView *filterBtnView;
@property (nonatomic, strong) CRMService *crmService;
@property (nonatomic, strong) NSMutableDictionary *conditionDic;

@end

@implementation CRMScrollContentViewController

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationAddCustomerSuccess object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(getMainData) name:kNotificationAddCustomerSuccess object:nil];
}

- (void)setFilterDataArray:(NSMutableArray<FilterBtnViewCellModel *> *)filterDataArray {
    _filterDataArray = filterDataArray;
    if (self.crmType == 1) {
        self.filterBtnView.dataArray = filterDataArray;
    }
}

- (void)addTableView {
    CGFloat height = self.crmType == 1 ? 40 : 0;
    self.tableView = [UICreateView initWithFrame:CGRectMake(0, height, kScreenW, kScreenH-kTopBarHeight-(128+height)) Style:UITableViewStylePlain Object:self];
    self.tableView.rowHeight = 80;
    [self.tableView registerClass:CRMTableViewCell.class forCellReuseIdentifier:NSStringFromClass(CRMTableViewCell.class)];
    [QHWRefreshManager.sharedInstance normalHeaderWithScrollView:self.tableView RefreshBlock:^{
        self.crmService.itemPageModel.pagination.currentPage = 1;
        [self getMainData];
    }];
    [QHWRefreshManager.sharedInstance normalFooterWithScrollView:self.tableView RefreshBlock:^{
        self.crmService.itemPageModel.pagination.currentPage++;
        [self getMainData];
    }];
    [self.view addSubview:self.tableView];
}

- (void)getMainData {
    if (self.crmType == 1) {
        [self.crmService getCRMListDataRequestWithCondition:self.conditionDic Complete:^{
            [self handleResponseObject];
        }];
    } else if (self.crmType == 2) {
        [self.crmService getClueListDataRequestWithComplete:^{
            [self handleResponseObject];
        }];
    }
}

- (void)getListDataWithFirstPage {
    self.crmService.itemPageModel.pagination.currentPage = 1;
    [self getMainData];
}

- (void)handleResponseObject {
    if ([self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header endRefreshing];
    }
    if ([self.tableView.mj_footer isRefreshing]) {
        [self.tableView.mj_footer endRefreshing];
    }
    [self.tableView reloadData];
    [self.tableView showNodataView:self.crmService.crmArray.count == 0 offsetY:0 button:nil];
    [QHWRefreshManager.sharedInstance endRefreshWithScrollView:self.tableView PageModel:self.crmService.itemPageModel];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.crmService.crmArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CRMTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(CRMTableViewCell.class)];
    CRMModel *model = self.crmService.crmArray[indexPath.row];
//    [cell.avatarImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(model.headPath)]];
    cell.avatarImgView.image = [UIImage imageWithColor:kColorThemefff size:CGSizeMake(50, 50) text:model.realName textAttributes:@{NSForegroundColorAttributeName: kColorTheme21a8ff} circular:YES];
    cell.nameLabel.text = model.realName;
    return cell;
}

- (void)confirmSelectItemWithFilterModel:(FilterBtnViewCellModel * _Nonnull )model ItemModel:(FilterCellModel * _Nonnull) countryCellModel {
    if (countryCellModel.code.length == 0) {
        model.name = model.btnTitleName;
        model.color = kColorTheme2a303c;
        if ([self.conditionDic.allKeys containsObject:model.dataArray.firstObject.key]) {
            [self.conditionDic removeObjectForKey:model.dataArray.firstObject.key];
        }
    } else {
        model.name = countryCellModel.name;
        model.color = kColorThemefb4d56;
        self.conditionDic[model.dataArray.firstObject.key] = countryCellModel.code;
    }
    self.filterBtnView.dataArray = self.filterDataArray;
    [self getListDataWithFirstPage];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (MainBusinessFilterBtnView *)filterBtnView {
    if (!_filterBtnView) {
        _filterBtnView = [[MainBusinessFilterBtnView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
        WEAKSELF
        _filterBtnView.didSelectItemBlock = ^(FilterBtnViewCellModel * _Nonnull model) {
            QHWCountryFilterView *filterView = [[QHWCountryFilterView alloc] initWithFrame:CGRectMake(0, kTopBarHeight+168, kScreenW, MIN(model.dataArray.firstObject.content.count*40, 200))];
            filterView.isTreatment = YES;
            filterView.dataArray = model.dataArray.firstObject.content;
            __weak typeof(model) wModel = model;
            filterView.didSelectedBlock = ^(FilterCellModel * _Nonnull countryCellModel, FilterCellModel * _Nonnull cityCellModel) {
                [weakSelf confirmSelectItemWithFilterModel:wModel ItemModel:countryCellModel];
            };
            [filterView show];
        };
        [self.view addSubview:_filterBtnView];
        [self.view addSubview:UIView.viewFrame(CGRectMake(0, 0, kScreenW, 0.5)).bkgColor(kColorThemeeee)];
    }
    return _filterBtnView;
}

- (CRMService *)crmService {
    if (!_crmService) {
        _crmService = CRMService.new;
    }
    return _crmService;
}

- (NSMutableDictionary *)conditionDic {
    if (!_conditionDic) {
        _conditionDic = NSMutableDictionary.dictionary;
    }
    return _conditionDic;
}

@end
