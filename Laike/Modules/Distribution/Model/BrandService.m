//
//  BrandService.m
//  Laike
//
//  Created by xiaobu on 2020/9/25.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "BrandService.h"

@implementation BrandService

- (instancetype)init {
    if (self == [super init]) {
        self.tableViewCellArray = @[@"BrandTableViewCell",
                                    @"RichTextTableViewCell",
                                    @"QHWMainBusinessTableViewCell"].mutableCopy;
    }
    return self;
}

- (void)getBrandListRequestComplete:(void (^)(void))complete {
    [QHWHttpLoading showWithMaskTypeBlack];
    NSDictionary *params = @{@"currentPage": @(self.itemPageModel.pagination.currentPage),
                             @"pageSize": @(self.itemPageModel.pagination.pageSize)};
    [QHWHttpManager.sharedInstance QHW_POST:kBrandList parameters:params success:^(id responseObject) {
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
    [QHWHttpManager.sharedInstance QHW_POST:kBrandInfo parameters:@{@"id": self.brandId ?: @""} success:^(id responseObject) {
        self.detailModel = [BrandModel yy_modelWithDictionary:responseObject[@"data"]];
        [self handleBrandDetailDataWithModel:self.detailModel];
        complete();
    } failure:^(NSError *error) {
        complete();
    }];
}

- (void)getBrandProductListRequestComplete:(void (^)(void))complete {
    [QHWHttpLoading show];
    [QHWHttpManager.sharedInstance QHW_POST:kBrandProductList parameters:@{@"id": self.brandId ?: @""} success:^(id responseObject) {
        self.productList = [NSArray yy_modelArrayWithClass:QHWMainBusinessDetailBaseModel.class json:responseObject[@"data"][@"list"]];
        if (self.productList.count > 0) {
            QHWBaseModel *productModel = [[QHWBaseModel alloc] configModelIdentifier:@"QHWMainBusinessTableViewCell" Height:140 Data:self.productList];
            productModel.headerTitle = @"主推产品";
            [self.tableViewDataArray addObject:productModel];
        }
        complete();
    } failure:^(NSError *error) {
        complete();
    }];
}

- (void)handleBrandDetailDataWithModel:(BrandModel *)model {
    QHWBaseModel *infoModel = [[QHWBaseModel alloc] configModelIdentifier:@"BrandTableViewCell" Height:95 Data:@[@[model, @(YES)]]];
    [self.tableViewDataArray addObject:infoModel];
    
    QHWBaseModel *introModel = [[QHWBaseModel alloc] configModelIdentifier:@"RichTextTableViewCell" Height:0 Data:@[@{@"data": model.brandInfo ?: @"", @"identifier": @"BrandInfoRichTextTableViewCell"}]];
    introModel.headerTitle = @"品牌介绍";
    [self.tableViewDataArray addObject:introModel];
}

@end
