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
#import "CTMediator+ViewController.h"
#import <CallKit/CallKit.h>

@interface CRMScrollContentViewController () <UITableViewDelegate, UITableViewDataSource, CXCallObserverDelegate>

@property (nonatomic, strong) MainBusinessFilterBtnView *filterBtnView;
@property (nonatomic, strong) CRMService *crmService;
@property (nonatomic, strong) NSMutableDictionary *conditionDic;
@property (nonatomic, strong) CXCallObserver *callObserve;
@property (nonatomic, strong) CRMModel *selectedCRMModel;

@end

@implementation CRMScrollContentViewController

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationAddCustomerSuccess object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(getMainData) name:kNotificationAddCustomerSuccess object:nil];
    self.callObserve = CXCallObserver.new;
    [self.callObserve setDelegate:self queue:dispatch_get_main_queue()];
}

- (void)callObserver:(CXCallObserver *)callObserver callChanged:(CXCall *)call {
    if (call.hasEnded) {
        if (self.crmType == 2) {
            [CTMediator.sharedInstance CTMediator_viewControllerForAddCustomerWithCustomerId:@"" RealName:self.selectedCRMModel.realName MobilePhone:self.selectedCRMModel.mobileNumber];
        }
    }
}

- (void)setFilterDataArray:(NSMutableArray<FilterBtnViewCellModel *> *)filterDataArray {
    _filterDataArray = filterDataArray;
    if (self.crmType == 1) {
        self.filterBtnView.dataArray = filterDataArray;
    }
}

- (void)addTableView {
    CGFloat headerHeight = self.crmType == 1 ? 40 : 0;
    CGFloat tableHeight = self.interval ? (kScreenH-kTopBarHeight-138-headerHeight) : (kScreenH-kTopBarHeight-138-headerHeight-kBottomBarHeight);
    self.tableView = [UICreateView initWithFrame:CGRectMake(0, headerHeight, kScreenW, tableHeight) Style:UITableViewStylePlain Object:self];
    self.tableView.rowHeight = 120;
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
    cell.countLabel.hidden = self.crmType == 1;
    CRMModel *model = self.crmService.crmArray[indexPath.row];
    if (model.headPath.length > 0) {
        [cell.avatarImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(model.headPath)]];
    } else {
        cell.avatarImgView.image = [UIImage imageWithColor:kColorThemefff size:CGSizeMake(50, 50) text:model.realName textAttributes:@{NSForegroundColorAttributeName: kColorTheme21a8ff} circular:YES];
    }
    cell.nameLabel.text = model.realName;
    if (model.industryNameArray.count == 0) {
        [cell.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.avatarImgView.mas_top).offset(15);
        }];
    }
    [cell.tagView setTagWithTagArray:model.industryNameArray];
    if (self.crmType == 2) {
        NSString *countStr = kFormat(@"咨询%ld次", model.actionCount);
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:countStr];
        [attr addAttributes:@{NSForegroundColorAttributeName: kColorTheme21a8ff} range:[countStr rangeOfString:kFormat(@"%ld", model.actionCount)]];
        cell.countLabel.attributedText = attr;
        [cell.convertBtn setTitle:@"转到客户" forState:0];
        [cell.convertBtn setTitle:@"已转客户" forState:UIControlStateSelected];
        [cell.convertBtn setTitleColor:kColorThemea4abb3 forState:UIControlStateSelected];
        cell.convertBtn.selected = model.clientStatus == 2;
    } else {
        [cell.convertBtn setTitle:@"写跟进" forState:0];
    }
    WEAKSELF
    cell.clickContactBlock = ^{
        weakSelf.selectedCRMModel = model;
        kCallTel(model.mobileNumber);
    };
    cell.clickConvertBlock = ^{
        if (weakSelf.crmType == 1) {
            [CTMediator.sharedInstance CTMediator_viewControllerForAddTrackWithCustomerId:model.id];
        } else {
            [CTMediator.sharedInstance CTMediator_viewControllerForAddCustomerWithCustomerId:@"" RealName:model.realName MobilePhone:model.mobileNumber];
        }
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CRMModel *model = self.crmService.crmArray[indexPath.row];
    if (self.crmType == 1) {
        [CTMediator.sharedInstance CTMediator_viewControllerForCRMDetailWithCustomerId:model.id];
    } else {
        [CTMediator.sharedInstance CTMediator_viewControllerForAdvisoryDetailWithCustomerId:model.userId];
    }
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
