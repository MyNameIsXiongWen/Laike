//
//  CRMService.m
//  Laike
//
//  Created by xiaobu on 2020/6/24.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "CRMService.h"

@implementation CRMService

- (void)getCRMFilterDataRequestWithComplete:(void (^)(void))complete {
    [QHWHttpManager.sharedInstance QHW_POST:kCRMFilter parameters:@{} success:^(id responseObject) {
        [self handleFilterDataWithResponse:responseObject[@"data"]];
        complete();
    } failure:^(NSError *error) {
        complete();
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

- (void)CRMAddCustomerRequestWithName:(NSString *)name Phone:(NSString *)phone Source:(NSInteger)source Remark:(NSString *)remark Complete:(void (^)(void))complete {
    [QHWHttpLoading showWithMaskTypeBlack];
    NSDictionary *params = @{@"clientSourceCode": @(source),
                             @"realName": name,
                             @"mobileNumber": phone,
                             @"note": remark};
    [QHWHttpManager.sharedInstance QHW_POST:kCRMAdd parameters:params success:^(id responseObject) {
        [SVProgressHUD showInfoWithStatus:@"添加成功"];
        [self.getCurrentMethodCallerVC.navigationController popViewControllerAnimated:YES];
        [NSNotificationCenter.defaultCenter postNotificationName:kNotificationAddCustomerSuccess object:nil];
        complete();
    } failure:^(NSError *error) {
        complete();
    }];
}

- (void)handleFilterDataWithResponse:(NSDictionary *)dic {
    NSMutableArray *tempSourceFilterArray = NSMutableArray.array;
    FilterCellModel *nolimitSourceModel = [FilterCellModel modelWithName:@"不限" Code:@""];
    nolimitSourceModel.valueStr = @"clientSourceCode";
    [tempSourceFilterArray addObject:nolimitSourceModel];
    [tempSourceFilterArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:FilterCellModel.class json:dic[@"clientSourceList"]]];
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
    [tempDemandFilterArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:FilterCellModel.class json:dic[@"industryList"]]];
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
    [tempIntentionFilterArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:FilterCellModel.class json:dic[@"intentionLevelList"]]];
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
    [tempProcessFilterArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:FilterCellModel.class json:dic[@"followStatusList"]]];
    [self.filterDataArray addObject:[FilterBtnViewCellModel modelWithName:@"进度"
                                                                  Img:@"global_down"
                                                            DataArray:@[[QHWFilterModel modelWithTitle:@"进度"
                                                                                                   Key:@"followStatusCode"
                                                                                               Content:tempProcessFilterArray
                                                                                       MutableSelected:NO]]
                                                                Color:kColorTheme2a303c]];
}

#pragma mark ------------DATA-------------
- (QHWItemPageModel *)itemPageModel {
    if (!_itemPageModel) {
        _itemPageModel = QHWItemPageModel.new;
    }
    return _itemPageModel;
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

@end

@implementation CRMModel

@end
