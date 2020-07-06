//
//  DistributionService.m
//  Laike
//
//  Created by xiaobu on 2020/7/4.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "DistributionService.h"

@implementation DistributionService

- (void)getClientFilterDataRequestWithComplete:(void (^)(void))complete {
    [QHWHttpManager.sharedInstance QHW_POST:kDistributionFilter parameters:@{} success:^(id responseObject) {
        FilterCellModel *cellModel = FilterCellModel.new;
        cellModel.name = @"全部";
        cellModel.code = @"0";
        [self.followStatusArray addObject:cellModel];
        [self.followStatusArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:FilterCellModel.class json:responseObject[@"data"][@"followStatusList"]]];
        complete();
    } failure:^(NSError *error) {
        complete();
    }];
}

- (void)getClientListRequestWithFollowStatusCode:(NSString *)code Complete:(void (^)(void))complete {
    [QHWHttpLoading showWithMaskTypeBlack];
    NSDictionary *params = @{@"followStatus": code,
                             @"currentPage": @(self.itemPageModel.pagination.currentPage),
                             @"pageSize": @(self.itemPageModel.pagination.pageSize)};
    [QHWHttpManager.sharedInstance QHW_POST:kDistributionClientList parameters:params success:^(id responseObject) {
        self.itemPageModel = [QHWItemPageModel yy_modelWithJSON:responseObject[@"data"]];
        if (self.itemPageModel.pagination.currentPage == 1) {
            [self.clientArray removeAllObjects];
        }
        [self.clientArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:ClientModel.class json:self.itemPageModel.list]];
        complete();
    } failure:^(NSError *error) {
        complete();
    }];
}

- (void)getClientDetailInfoRequestComplete:(void (^)(void))complete {
    [QHWHttpLoading showWithMaskTypeBlack];
    NSDictionary *params = @{@"clientId": self.customerId ?: @"",
                             @"currentPage": @(self.itemPageModel.pagination.currentPage),
                             @"pageSize": @(self.itemPageModel.pagination.pageSize)};
    [QHWHttpManager.sharedInstance QHW_POST:kDistributionClientList parameters:params success:^(id responseObject) {
        self.itemPageModel = [QHWItemPageModel yy_modelWithJSON:responseObject[@"data"]];
        if (self.itemPageModel.pagination.currentPage == 1) {
            [self.clientArray removeAllObjects];
        }
        [self.clientArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:ClientModel.class json:self.itemPageModel.list]];
        complete();
    } failure:^(NSError *error) {
        complete();
    }];
}

- (QHWItemPageModel *)itemPageModel {
    if (!_itemPageModel) {
        _itemPageModel = QHWItemPageModel.new;
    }
    return _itemPageModel;
}

- (NSMutableArray<FilterCellModel *> *)followStatusArray {
    if (!_followStatusArray) {
        _followStatusArray = NSMutableArray.array;
    }
    return _followStatusArray;
}

- (NSMutableArray *)clientArray {
    if (!_clientArray) {
        _clientArray = NSMutableArray.array;
    }
    return _clientArray;
}

@end

@implementation ClientModel

@end
