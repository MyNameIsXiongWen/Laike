//
//  CRMService.m
//  Laike
//
//  Created by xiaobu on 2020/6/24.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "CRMService.h"
#import "UserModel.h"
#import "CTMediator+ViewController.h"

@implementation CRMService

- (void)getHomeReportCountDataWithComplete:(void (^)(void))complete {
    [QHWHttpLoading showWithMaskTypeBlack];
    [QHWHttpManager.sharedInstance QHW_POST:kHomeReportCount parameters:@{} success:^(id responseObject) {
        self.crmCount = [responseObject[@"data"][@"crmCount"] integerValue];
        self.clueCount = [responseObject[@"data"][@"clueCount"] integerValue];
        complete();
    } failure:^(NSError *error) {
        complete();
    }];
}

- (void)getCRMFilterDataRequestWithComplete:(void (^)(id _Nullable))complete {
    [QHWHttpManager.sharedInstance QHW_POST:kCRMFilter parameters:@{} success:^(id responseObject) {
        self.clientSourceList = [NSArray yy_modelArrayWithClass:FilterCellModel.class json:responseObject[@"data"][@"clientSourceList"]];
        self.clientLevelList = [NSArray yy_modelArrayWithClass:FilterCellModel.class json:responseObject[@"data"][@"clientLevelList"]];
        self.industryList = [NSArray yy_modelArrayWithClass:FilterCellModel.class json:responseObject[@"data"][@"industryList"]];
        self.intentionLevelList = [NSArray yy_modelArrayWithClass:FilterCellModel.class json:responseObject[@"data"][@"intentionLevelList"]];
        self.followStatusList = [NSArray yy_modelArrayWithClass:FilterCellModel.class json:responseObject[@"data"][@"followStatusList"]];
        [self handleFilterDataWithResponse:responseObject[@"data"]];
        complete(responseObject[@"data"]);
    } failure:^(NSError *error) {
        complete(nil);
    }];
}

- (void)getCRMListDataRequestWithCondition:(NSDictionary *)condition Complete:(void (^)(void))complete {
    [QHWHttpLoading showWithMaskTypeBlack];
    NSMutableDictionary *params = @{@"currentPage": @(self.itemPageModel.pagination.currentPage),
                                    @"pageSize": @(self.itemPageModel.pagination.pageSize)}.mutableCopy;
    if (condition.allKeys.count > 0) {
        [params addEntriesFromDictionary:condition];
    }
    [QHWHttpManager.sharedInstance QHW_POST:kCRMList parameters:params success:^(id responseObject) {
        self.itemPageModel = [QHWItemPageModel yy_modelWithJSON:responseObject[@"data"]];
        if (self.itemPageModel.pagination.currentPage == 1) {
            [self.crmArray removeAllObjects];
        }
        [self.crmArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:CRMModel.class json:self.itemPageModel.list]];
        complete();
    } failure:^(NSError *error) {
        complete();
    }];
}

- (void)getCRMDetailInfoRequestWithComplete:(void (^)(void))complete {
    [QHWHttpLoading showWithMaskTypeBlack];
    [QHWHttpManager.sharedInstance QHW_POST:kCRMDetailInfo parameters:@{@"id": self.customerId ?: @""} success:^(id responseObject) {
        self.crmModel = [CRMModel yy_modelWithJSON:responseObject[@"data"]];
        self.tableHeaderViewHeight = 140 + 40 + self.crmModel.detailRemarkStrH + 40 + self.crmModel.detailIndustryStrH + 5 + self.crmModel.detailCountryStrH + 10;
        complete();
    } failure:^(NSError *error) {
        complete();
    }];
}

- (void)getCRMTrackListDataRequestWithComplete:(void (^)(void))complete {
    [QHWHttpLoading showWithMaskTypeBlack];
    NSDictionary *params = @{@"id": self.customerId ?: @"",
                             @"currentPage": @(self.itemPageModel.pagination.currentPage),
                             @"pageSize": @(self.itemPageModel.pagination.pageSize)};
    [QHWHttpManager.sharedInstance QHW_POST:kCRMTrackList parameters:params success:^(id responseObject) {
        self.itemPageModel = [QHWItemPageModel yy_modelWithJSON:responseObject[@"data"]];
        if (self.itemPageModel.pagination.currentPage == 1) {
            [self.trackArray removeAllObjects];
        }
        [self.trackArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:CRMTrackModel.class json:self.itemPageModel.list]];
        complete();
    } failure:^(NSError *error) {
        complete();
    }];
}

- (void)getClueListDataRequestWithComplete:(void (^)(void))complete {
    [QHWHttpLoading showWithMaskTypeBlack];
    NSDictionary *params = @{@"currentPage": @(self.itemPageModel.pagination.currentPage),
                             @"pageSize": @(self.itemPageModel.pagination.pageSize)};
    [QHWHttpManager.sharedInstance QHW_POST:kClueList parameters:params success:^(id responseObject) {
        self.itemPageModel = [QHWItemPageModel yy_modelWithJSON:responseObject[@"data"]];
        if (self.itemPageModel.pagination.currentPage == 1) {
            [self.crmArray removeAllObjects];
        }
        [self.crmArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:CRMModel.class json:self.itemPageModel.list]];
        complete();
    } failure:^(NSError *error) {
        complete();
    }];
}

- (void)getClueActionListDataRequestWithComplete:(void (^)(void))complete {
    NSDictionary *params = @{@"userId": self.customerId ?: @"",
                             @"currentPage": @(self.itemPageModel.pagination.currentPage),
                             @"pageSize": @(self.itemPageModel.pagination.pageSize)};
    [self getActionClueListWithParams:params Url:kClueActionList Complete:complete];
}

- (void)getClueActionAllListDataRequestWithComplete:(void (^)(void))complete {
    NSDictionary *params = @{@"id": self.customerId ?: @"",
                             @"currentPage": @(self.itemPageModel.pagination.currentPage),
                             @"pageSize": @(self.itemPageModel.pagination.pageSize)};
    [self getActionClueListWithParams:params Url:kClueActionAllList Complete:complete];
}

- (void)getActionClueListWithParams:(NSDictionary *)params Url:(NSString *)url Complete:(void (^)(void))complete {
    [QHWHttpLoading showWithMaskTypeBlack];
    [QHWHttpManager.sharedInstance QHW_POST:url parameters:params success:^(id responseObject) {
        self.crmModel = [CRMModel yy_modelWithJSON:responseObject[@"data"]];
        self.itemPageModel = [QHWItemPageModel yy_modelWithJSON:responseObject[@"data"]];
        if (self.itemPageModel.pagination.currentPage == 1) {
            [self.advisoryArray removeAllObjects];
        }
        [self.advisoryArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:CRMAdvisoryModel.class json:self.itemPageModel.list]];
        complete();
    } failure:^(NSError *error) {
        complete();
    }];
}

- (void)CRMAddCustomerRequestWithComplete:(void (^)(void))complete {
    [QHWHttpLoading showWithMaskTypeBlack];
    NSMutableArray *businessArray = NSMutableArray.array;
    for (FilterCellModel *model in self.industryList) {
        if (model.selected) {
            [businessArray addObject:@{@"id": model.id}];
        }
    }
    NSMutableArray *countryArray = NSMutableArray.array;
    for (FilterCellModel *model in self.intentionCountryArray) {
        if (model.selected) {
            [countryArray addObject:@{@"id": model.id}];
        }
    }
    FilterCellModel *clientLevelModel;
    for (FilterCellModel *model in self.clientLevelList) {
        if (model.selected) {
            clientLevelModel = model;
            break;
        }
    }
    FilterCellModel *intentionModel;
    for (FilterCellModel *model in self.intentionLevelList) {
        if (model.selected) {
            intentionModel = model;
            break;
        }
    }
    
    NSMutableDictionary *params = @{@"realName": self.crmModel.realName ?: @""}.mutableCopy;
    if (self.crmModel.gender) {
        params[@"gender"] = @(self.crmModel.gender);
    }
    if (self.crmModel.wechatNumber) {
        params[@"wechatNumber"] = self.crmModel.wechatNumber;
    }
    if (self.crmModel.note.length > 0) {
        params[@"note"] = self.crmModel.note;
    }
    if (businessArray.count > 0) {
        params[@"industryList"] = businessArray;
    }
    if (countryArray.count > 0) {
        params[@"countryList"] = countryArray;
    }
    if (intentionModel) {
        params[@"intentionLevelCode"] = intentionModel.code;
    }
    if (clientLevelModel) {
        params[@"clientLevel"] = clientLevelModel.code;
    }
    NSString *urlString = kCRMAdd;
    NSString *remiderString = @"添加成功";
    if (self.customerId.length > 0) {
        params[@"id"] = self.customerId;
        urlString = kCRMEdit;
        remiderString = @"";
    } else {
        FilterCellModel *sourceModel;
        for (FilterCellModel *model in self.clientSourceList) {
            if (model.selected) {
                sourceModel = model;
                break;
            }
        }
        if (sourceModel) {
            params[@"clientSourceCode"] = sourceModel.code;
        }
        params[@"mobileNumber"] = self.crmModel.mobileNumber ?: @"";
    }
    [QHWHttpManager.sharedInstance QHW_POST:urlString parameters:params success:^(id responseObject) {
        [SVProgressHUD showInfoWithStatus:remiderString];
        [self.getCurrentMethodCallerVC.navigationController popViewControllerAnimated:YES];
        [NSNotificationCenter.defaultCenter postNotificationName:kNotificationAddCustomerSuccess object:nil];
        complete();
    } failure:^(NSError *error) {
        complete();
    }];
}

- (void)CRMAddTrackRequestWithFollowStatusCode:(NSInteger)followStatusCode Remark:(NSString *)remark Complete:(void (^)(void))complete {
    [QHWHttpLoading showWithMaskTypeBlack];
    NSDictionary *params = @{@"followStatusCode": @(followStatusCode),
                             @"id": self.customerId ?: @"",
                             @"content": remark};
    [QHWHttpManager.sharedInstance QHW_POST:kCRMAddTrack parameters:params success:^(id responseObject) {
        [SVProgressHUD showInfoWithStatus:@"跟进成功"];
        [self.getCurrentMethodCallerVC.navigationController popViewControllerAnimated:YES];
        [NSNotificationCenter.defaultCenter postNotificationName:kNotificationAddTrackSuccess object:nil];
        complete();
    } failure:^(NSError *error) {
        complete();
    }];
}

- (void)CRMGiveUpTrackRequest {
    if (UserModel.shareUser.bindStatus == 2) {
        [CTMediator.sharedInstance CTMediator_viewControllerForBindCompany];
        return;
    }
    [QHWHttpLoading showWithMaskTypeBlack];
    [QHWHttpManager.sharedInstance QHW_POST:kCRMGiveUpTrack parameters:@{@"id": self.customerId ?: @""} success:^(id responseObject) {
        [SVProgressHUD showInfoWithStatus:@"放弃跟进"];
        [NSNotificationCenter.defaultCenter postNotificationName:kNotificationAddCustomerSuccess object:nil];
        for (UIViewController *vc in self.getCurrentMethodCallerVC.navigationController.childViewControllers) {
            if ([NSStringFromClass(vc.class) isEqualToString:@"CRMViewController"]) {
                [self.getCurrentMethodCallerVC.navigationController popToViewController:vc animated:YES];
                break;
            }
        }
    } failure:^(NSError *error) {
    }];
}

- (void)advisoryGiveUpTrackRequest {
    if (UserModel.shareUser.bindStatus == 2) {
        [CTMediator.sharedInstance CTMediator_viewControllerForBindCompany];
        return;
    }
    [QHWHttpLoading showWithMaskTypeBlack];
    [QHWHttpManager.sharedInstance QHW_POST:kCRMAdvisoryGiveUpTrack parameters:@{@"id": self.customerId ?: @""} success:^(id responseObject) {
        [SVProgressHUD showInfoWithStatus:@"放弃跟进"];
        [NSNotificationCenter.defaultCenter postNotificationName:kNotificationAddCustomerSuccess object:nil];
        for (UIViewController *vc in self.getCurrentMethodCallerVC.navigationController.childViewControllers) {
            if ([NSStringFromClass(vc.class) isEqualToString:@"CRMViewController"]) {
                [self.getCurrentMethodCallerVC.navigationController popToViewController:vc animated:YES];
                break;
            }
        }
    } failure:^(NSError *error) {
    }];
}

- (void)handleFilterDataWithResponse:(NSDictionary *)dic {
    NSMutableArray *tempSourceFilterArray = NSMutableArray.array;
    FilterCellModel *nolimitSourceModel = [FilterCellModel modelWithName:@"不限" Code:@""];
    nolimitSourceModel.valueStr = @"clientSourceCode";
    [tempSourceFilterArray addObject:nolimitSourceModel];
    [tempSourceFilterArray addObjectsFromArray:self.clientSourceList];
    [self.filterDataArray addObject:[FilterBtnViewCellModel modelWithName:@"来源"
                                                                  Img:@"global_down"
                                                            DataArray:@[[QHWFilterModel modelWithTitle:@"来源"
                                                                                                   Key:@"clientSourceCode"
                                                                                               Content:tempSourceFilterArray
                                                                                       MutableSelected:NO]]
                                                                Color:kColorTheme2a303c]];
    
    NSMutableArray *tempDemandFilterArray = NSMutableArray.array;
    FilterCellModel *nolimitDemandModel = [FilterCellModel modelWithName:@"不限" Code:@""];
    nolimitDemandModel.valueStr = @"industryId";
    [tempDemandFilterArray addObject:nolimitDemandModel];
    [tempDemandFilterArray addObjectsFromArray:self.industryList];
    [self.filterDataArray addObject:[FilterBtnViewCellModel modelWithName:@"需求"
                                                                  Img:@"global_down"
                                                            DataArray:@[[QHWFilterModel modelWithTitle:@"需求"
                                                                                                   Key:@"industryId"
                                                                                               Content:tempDemandFilterArray
                                                                                       MutableSelected:NO]]
                                                                Color:kColorTheme2a303c]];
    
    NSMutableArray *tempIntentionFilterArray = NSMutableArray.array;
    FilterCellModel *nolimitIntentionModel = [FilterCellModel modelWithName:@"不限" Code:@""];
    nolimitIntentionModel.valueStr = @"intentionLevelCode";
    [tempIntentionFilterArray addObject:nolimitIntentionModel];
    [tempIntentionFilterArray addObjectsFromArray:self.intentionLevelList];
    [self.filterDataArray addObject:[FilterBtnViewCellModel modelWithName:@"意向"
                                                                  Img:@"global_down"
                                                            DataArray:@[[QHWFilterModel modelWithTitle:@"意向"
                                                                                                   Key:@"intentionLevelCode"
                                                                                               Content:tempIntentionFilterArray
                                                                                       MutableSelected:NO]]
                                                                Color:kColorTheme2a303c]];
    
    NSMutableArray *tempProcessFilterArray = NSMutableArray.array;
    FilterCellModel *nolimitProcessModel = [FilterCellModel modelWithName:@"不限" Code:@""];
    nolimitProcessModel.valueStr = @"followStatusCode";
    [tempProcessFilterArray addObject:nolimitProcessModel];
    [tempProcessFilterArray addObjectsFromArray:self.followStatusList];
    [self.filterDataArray addObject:[FilterBtnViewCellModel modelWithName:@"进度"
                                                                  Img:@"global_down"
                                                            DataArray:@[[QHWFilterModel modelWithTitle:@"进度"
                                                                                                   Key:@"followStatusCode"
                                                                                               Content:tempProcessFilterArray
                                                                                       MutableSelected:NO]]
                                                                Color:kColorTheme2a303c]];
}

- (void)handleCRMDetailInfoData {
    [self.tableViewDataArray removeAllObjects];
    QHWBaseModel *nameModel = [[QHWBaseModel alloc] configModelIdentifier:@"AddCustomerTFViewCell" Height:60 Data:@{@"title": @"* 姓名", @"placeholder": @"请输入客户姓名", @"data": self.crmModel, @"identifier": @"realName"}];
    [self.tableViewDataArray addObject:nameModel];
    
    QHWBaseModel *genderModel = [[QHWBaseModel alloc] configModelIdentifier:@"AddCustomerGenderCell" Height:60 Data:self.crmModel];
    [self.tableViewDataArray addObject:genderModel];
    
    BOOL disable = NO;
    BOOL unselectable = NO;
    if (self.customerId.length > 0) {
        disable = YES;
    } else {
        if (self.crmModel.mobileNumber.length > 0) {
            disable = YES;
            unselectable = YES;
        }
    }
    QHWBaseModel *phoneModel = [[QHWBaseModel alloc] configModelIdentifier:@"AddCustomerTFViewCell" Height:60 Data:@{@"title": @"* 手机", @"placeholder": @"请输入客户手机号", @"data": self.crmModel, @"identifier": @"mobileNumber", @"disable": @(disable)}];
    [self.tableViewDataArray addObject:phoneModel];
    
    QHWBaseModel *wechatModel = [[QHWBaseModel alloc] configModelIdentifier:@"AddCustomerTFViewCell" Height:60 Data:@{@"title": @"   微信", @"placeholder": @"请输入客户微信号", @"data": self.crmModel, @"identifier": @"wechatNumber"}];
    [self.tableViewDataArray addObject:wechatModel];
    
    QHWBaseModel *remarkModel = [[QHWBaseModel alloc] configModelIdentifier:@"AddCustomerRemarkCell" Height:165 Data:self.crmModel];
    [self.tableViewDataArray addObject:remarkModel];
    
    QHWBaseModel *sourceModel = [[QHWBaseModel alloc] configModelIdentifier:@"AddCustomerSelectionCell" Height:80+[self getHeightFromArray:self.clientSourceList] Data:@{@"title": @"* 客户来源", @"mutable": @(NO), @"data": self.clientSourceList, @"model": self.crmModel, @"identifier": @"source", @"unselectable": @(unselectable)}];
    [self.tableViewDataArray addObject:sourceModel];
    
    QHWBaseModel *crmLevelModel = [[QHWBaseModel alloc] configModelIdentifier:@"AddCustomerSelectionCell" Height:80+[self getHeightFromArray:self.clientLevelList] Data:@{@"title": @"客户等级", @"mutable": @(NO), @"data": self.clientLevelList, @"model": self.crmModel, @"identifier": @"crmLevel"}];
    [self.tableViewDataArray addObject:crmLevelModel];
    
    QHWBaseModel *businessModel = [[QHWBaseModel alloc] configModelIdentifier:@"AddCustomerSelectionCell" Height:80+[self getHeightFromArray:self.industryList] Data:@{@"title": @"意向业务", @"mutable": @(YES), @"data": self.industryList, @"model": self.crmModel, @"identifier": @"business"}];
    [self.tableViewDataArray addObject:businessModel];
    
    QHWBaseModel *intentionLevelModel = [[QHWBaseModel alloc] configModelIdentifier:@"AddCustomerSelectionCell" Height:80+[self getHeightFromArray:self.intentionLevelList] Data:@{@"title": @"意向等级", @"mutable": @(NO), @"data": self.intentionLevelList, @"model": self.crmModel, @"identifier": @"intentionLevel"}];
    [self.tableViewDataArray addObject:intentionLevelModel];
    
    if (self.customerId.length > 0) {
        if (self.crmModel.clientSourceCode) {
            for (FilterCellModel *cellModel in self.clientSourceList) {
                if (cellModel.code.integerValue == self.crmModel.clientSourceCode) {
                    cellModel.selected = YES;
                    break;
                }
            }
        }
        if (self.crmModel.clientLevel) {
            for (FilterCellModel *cellModel in self.clientLevelList) {
                if (cellModel.code.integerValue == self.crmModel.clientLevel) {
                    cellModel.selected = YES;
                    break;
                }
            }
        }
        if (self.crmModel.intentionLevelCode) {
            for (FilterCellModel *cellModel in self.intentionLevelList) {
                if (cellModel.code.integerValue == self.crmModel.intentionLevelCode) {
                    cellModel.selected = YES;
                    break;
                }
            }
        }
        if (self.crmModel.industryList.count > 0) {
            for (NSDictionary *dic in self.crmModel.industryList) {
                for (FilterCellModel *cellModel in self.industryList) {
                    if ([cellModel.code isEqualToString:dic[@"id"]]) {
                        cellModel.selected = YES;
                    }
                }
            }
            
        }
        if (self.crmModel.countryList.count > 0) {
            for (NSDictionary *dic in self.crmModel.countryList) {
                @autoreleasepool {
                    for (FilterCellModel *continentModel in self.countryArray) {
                        @autoreleasepool {
                            for (FilterCellModel *countryModel in continentModel.children) {
                                if ([countryModel.id isEqualToString:dic[@"id"]]) {
                                    countryModel.selected = YES;
                                    [self.intentionCountryArray addObject:countryModel];
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    if (unselectable) {
        self.clientSourceList.firstObject.selected = YES;
        self.crmModel.clientSourceCode = self.clientSourceList.firstObject.code.integerValue;
    }
    
    QHWBaseModel *countryModel = [[QHWBaseModel alloc] configModelIdentifier:@"AddCustomerCountryCell" Height:self.intentionCountryHeight Data:@{@"title": @"意向国家", @"placeholder": @"请选择意向国家", @"data": self, @"identifier": @"country", @"selection": @(YES)}];
    [self.tableViewDataArray addObject:countryModel];
}

- (CGFloat)getHeightFromArray:(NSArray *)array {
    NSInteger row = ceil(array.count/3.0);
    return row * 45 - 15;
}

- (CGFloat)intentionCountryHeight {
    return [self getHeightByTargetColumnSource:self.intentionCountryArray];
}

- (CGFloat)getHeightByTargetColumnSource:(NSArray *)target {
    CGFloat height = 30+30;
    CGFloat width = 0;
    NSMutableArray *array = target.mutableCopy;
    [array addObject:FilterCellModel.new];
    for (FilterCellModel *model in array) {
        CGFloat modelWidth = [model.name getWidthWithFont:kFontTheme14 constrainedToSize:CGSizeMake(1000, 30)];
        if (modelWidth < 30) {
            modelWidth = 30;
        }
        model.size = CGSizeMake(modelWidth + 20, 30);
        width += model.size.width + 15;
        if (width > (kScreenW - 100)) {
            width = model.size.width + 15;
            height += 45;
        }
    }
    return height;
}

#pragma mark ------------DATA-------------
- (QHWItemPageModel *)itemPageModel {
    if (!_itemPageModel) {
        _itemPageModel = QHWItemPageModel.new;
    }
    return _itemPageModel;
}

- (CRMModel *)crmModel {
    if (!_crmModel) {
        _crmModel = CRMModel.new;
    }
    return _crmModel;
}

- (NSMutableArray<FilterBtnViewCellModel *> *)filterDataArray {
    if (!_filterDataArray) {
        _filterDataArray = NSMutableArray.array;
    }
    return _filterDataArray;
}

- (NSMutableArray *)crmArray {
    if (!_crmArray) {
        _crmArray = NSMutableArray.array;
    }
    return _crmArray;
}

- (NSMutableArray *)trackArray {
    if (!_trackArray) {
        _trackArray = NSMutableArray.array;
    }
    return _trackArray;
}

- (NSMutableArray *)advisoryArray {
    if (!_advisoryArray) {
        _advisoryArray = NSMutableArray.array;
    }
    return _advisoryArray;
}

- (NSMutableArray *)intentionCountryArray {
    if (!_intentionCountryArray) {
        _intentionCountryArray  = NSMutableArray.array;
    }
    return _intentionCountryArray;
}

@end

@implementation CRMModel

- (NSString *)genderStr {
    switch (self.gender) {
        case 1:
            return @"男";
            break;
            
        case 2:
            return @"女";
            break;
            
        default:
            return @"未设置";
            break;
    }
}

- (NSString *)industryStr {
    if (!_industryStr) {
        NSMutableArray *array = NSMutableArray.array;
        for (NSDictionary *dic in self.industryList) {
            [array addObject:dic[@"name"]];
        }
        if (array.count == 0) {
            _industryStr = @"业务：暂无";
        } else {
            _industryStr = kFormat(@"业务：%@", [array componentsJoinedByString:@"、"]);
        }
    }
    return _industryStr;
}

- (NSArray *)industryNameArray {
    if (!_industryNameArray) {
        NSMutableArray *array = NSMutableArray.array;
        for (NSDictionary *dic in self.industryList) {
            [array addObject:dic[@"name"]];
        }
        _industryNameArray = array.copy;
    }
    return _industryNameArray;
}

- (NSString *)countryStr {
    if (!_countryStr) {
        NSMutableArray *array = NSMutableArray.array;
        for (NSDictionary *dic in self.countryList) {
            [array addObject:dic[@"name"]];
        }
        if (array.count == 0) {
            _countryStr = @"国家：暂无";
        } else {
            _countryStr = kFormat(@"国家：%@", [array componentsJoinedByString:@"、"]);
        }
    }
    return _countryStr;
}

- (CGFloat)detailRemarkStrH {
    if (!_detailRemarkStrH) {
        _detailRemarkStrH = MAX(20, [self.note getHeightWithFont:kFontTheme14 constrainedToSize:CGSizeMake(kScreenW-40, CGFLOAT_MAX)]);
    }
    return _detailRemarkStrH;
}

- (CGFloat)detailIndustryStrH {
    if (!_detailIndustryStrH) {
        _detailIndustryStrH = MAX(20, [self.industryStr getHeightWithFont:kFontTheme14 constrainedToSize:CGSizeMake(kScreenW-40, CGFLOAT_MAX)]);
    }
    return _detailIndustryStrH;
}

- (CGFloat)detailCountryStrH {
    if (!_detailCountryStrH) {
        _detailCountryStrH = MAX(20, [self.countryStr getHeightWithFont:kFontTheme14 constrainedToSize:CGSizeMake(kScreenW-40, CGFLOAT_MAX)]);
    }
    return _detailCountryStrH;
}

@end

@implementation CRMTrackModel

- (CGFloat)trackHeight {
    if (!_trackHeight) {
        _trackHeight = 10 + 20 + 10 + 10 + MAX(20, [self.content ?: self.note getHeightWithFont:kFontTheme14 constrainedToSize:CGSizeMake(kScreenW-60, CGFLOAT_MAX)]);
    }
    return _trackHeight;
}

@end

@implementation CRMAdvisoryModel

- (CGFloat)advisoryHeight {
    if (!_advisoryHeight) {
        _advisoryHeight = 10 + 20 + 10 + 10 + MAX(20, [self.title2 getHeightWithFont:kFontTheme14 constrainedToSize:CGSizeMake(kScreenW-60, CGFLOAT_MAX)]);
    }
    return _advisoryHeight;
}

@end
