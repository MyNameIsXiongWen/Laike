//
//  DistributionService.m
//  Laike
//
//  Created by xiaobu on 2020/7/4.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "DistributionService.h"
#import "CRMService.h"

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
            [self.tableViewDataArray removeAllObjects];
        }
        [self.tableViewDataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:ClientModel.class json:self.itemPageModel.list]];
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
    [QHWHttpManager.sharedInstance QHW_POST:kDistributionClientInfo parameters:params success:^(id responseObject) {
        self.clientDetailModel = [ClientModel yy_modelWithJSON:responseObject[@"data"]];
        self.tableHeaderViewHeight = 140 + 40 + self.clientDetailModel.businessHeight + 40 + self.clientDetailModel.productHeight + 40 + self.clientDetailModel.infoHeight + 20 + 50 + 20;
        complete();
    } failure:^(NSError *error) {
        complete();
    }];
}

- (void)getClientDetailTrackListRequestComplete:(void (^)(void))complete {
    [QHWHttpLoading showWithMaskTypeBlack];
    NSDictionary *params = @{@"clientId": self.customerId ?: @"",
                             @"currentPage": @(self.itemPageModel.pagination.currentPage),
                             @"pageSize": @(self.itemPageModel.pagination.pageSize)};
    [QHWHttpManager.sharedInstance QHW_POST:kDistributionTrackList parameters:params success:^(id responseObject) {
        self.itemPageModel = [QHWItemPageModel yy_modelWithJSON:responseObject[@"data"]];
        if (self.itemPageModel.pagination.currentPage == 1) {
            [self.tableViewDataArray removeAllObjects];
        }
        [self.tableViewDataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:CRMTrackModel.class json:self.itemPageModel.list]];
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

@end

@implementation ClientModel

- (CGFloat)businessHeight {
    if (!_businessHeight) {
        _businessHeight = MAX(20, [self.businessName getHeightWithFont:kFontTheme14 constrainedToSize:CGSizeMake(kScreenW-40, CGFLOAT_MAX)]);
    }
    return _businessHeight;
}

- (CGFloat)productHeight {
    if (!_productHeight) {
        _productHeight = MAX(20, [self.name getHeightWithFont:kFontTheme14 constrainedToSize:CGSizeMake(kScreenW-40, CGFLOAT_MAX)]);
    }
    return _productHeight;
}

- (CGFloat)infoHeight {
    if (!_infoHeight) {
        _infoHeight = MAX(20, [self.note getHeightWithFont:kFontTheme14 constrainedToSize:CGSizeMake(kScreenW-40, CGFLOAT_MAX)]);
    }
    return _infoHeight;
}

@end
