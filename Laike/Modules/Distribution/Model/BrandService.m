//
//  BrandService.m
//  Laike
//
//  Created by xiaobu on 2020/9/25.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "BrandService.h"

@implementation BrandService

- (void)getBrandListRequestComplete:(void (^)(void))complete {
    [QHWHttpLoading showWithMaskTypeBlack];
    NSDictionary *params = @{@"currentPage": @(self.itemPageModel.pagination.currentPage),
                             @"pageSize": @(self.itemPageModel.pagination.pageSize)};
    [QHWHttpManager.sharedInstance QHW_POST:@"" parameters:params success:^(id responseObject) {
        self.itemPageModel = [QHWItemPageModel yy_modelWithJSON:responseObject[@"data"]];
        if (self.itemPageModel.pagination.currentPage == 1) {
            [self.tableViewDataArray removeAllObjects];
        }
        [self.tableViewDataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:BrandModel.class json:self.itemPageModel.list]];
        complete();
    } failure:^(NSError *error) {
        complete();
    }];
}

- (void)getBrandDetailRequestComplete:(void (^)(void))complete {
    [QHWHttpLoading show];
    [QHWHttpManager.sharedInstance QHW_POST:@"" parameters:@{@"id": self.brandId ?: @""} success:^(id responseObject) {
        self.detailModel = [BrandModel yy_modelWithDictionary:responseObject[@"data"]];
        [self handleBrandDetailDataWithModel:self.detailModel];
        complete();
    } failure:^(NSError *error) {
        complete();
    }];
}

- (void)handleBrandDetailDataWithModel:(BrandModel *)model {
    QHWBaseModel *infoModel = [[QHWBaseModel alloc] configModelIdentifier:@"BrandTableViewCell" Height:95 Data:@[@[model]]];
    [self.tableViewDataArray addObject:infoModel];
    
    QHWBaseModel *introModel = [[QHWBaseModel alloc] configModelIdentifier:@"RichTextTableViewCell" Height:100 Data:@[@{@"data": model.brandIntro ?: @"", @"identifier": @"BrandIntroRichTextTableViewCell"}]];
    [self.tableViewDataArray addObject:introModel];
    
    QHWBaseModel *productModel = [[QHWBaseModel alloc] configModelIdentifier:@"QHWMainBusinessTableViewCell" Height:140 Data:model.productList];
    productModel.headerTitle = @"主推产品";
    [self.tableViewDataArray addObject:productModel];
}

@end
